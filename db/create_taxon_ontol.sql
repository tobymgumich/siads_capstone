CREATE OR REPLACE FUNCTION public.create_taxonomy_ontology(tables_list text[])
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    table_name text;
BEGIN
    -- Drop the taxon_ontol table if it exists
    EXECUTE 'DROP TABLE IF EXISTS taxon_ontol CASCADE';
    
    -- Create the taxon_ontol table with the specified schema
    EXECUTE '
    CREATE TABLE taxon_ontol (
        id serial PRIMARY KEY,
        term varchar,
        acronym varchar,
        alt_labels varchar,
        regex_keys varchar,
        taxonomy varchar,
        related_terms varchar,
        wiki_search bool DEFAULT TRUE,
        wiki_match varchar,
        thes_match varchar
    )';
-- INSERT INTO taxon_ontol (taxonomy)
-- SELECT CONCAT_WS('+', level_1, level_2, level_3, level_4, level_5) AS hash_key
-- FROM model_eval_test;    
    -- Loop through the list of tables and insert taxonomy
    FOREACH table_name IN ARRAY tables_list
    LOOP
        EXECUTE format('
            INSERT INTO taxon_ontol (taxonomy)
            SELECT CONCAT_WS(''+'', level_1, level_2, level_3, level_4, level_5) AS hash_key
            FROM %I
            ', table_name);
    END LOOP;

    -- Step 2: Add term
    UPDATE taxon_ontol
    SET term = 
        CASE
            WHEN taxonomy LIKE '%+%' THEN
                REVERSE(SUBSTRING(REVERSE(taxonomy) FROM 1 FOR POSITION('+' IN REVERSE(taxonomy)) - 1))
            ELSE taxonomy
        END;

    -- Step 3: Add acronym
    UPDATE taxon_ontol
    SET acronym = COALESCE(
        (SELECT string_agg(word, '')
         FROM unnest(string_to_array(term, ' ')) AS words(word)
         WHERE word ~ '[A-Z]{3,7}'));

    UPDATE taxon_ontol SET acronym = REPLACE(REPLACE(acronym, '(', ''), ')', '');

    -- Step 4: Create regex_keys
    -- Remove acronym from temporary modified term
    WITH acronym_removed AS (
        SELECT id,
            CASE
                WHEN acronym IS NOT NULL THEN
                    REGEXP_REPLACE(term, acronym, '', 'g')
                ELSE term
            END AS modified_term
        FROM taxon_ontol
    ),

    -- Remove suffixes ('s', 'ing', 'ion') if the string length is more than 8 characters
    suffix_removed AS (
        SELECT id,
            CASE
                WHEN LENGTH(modified_term) > 8 THEN
                    REGEXP_REPLACE(
                        REGEXP_REPLACE(
                            REGEXP_REPLACE(modified_term, 's$', '', 'g'),
                            'ing$', '', 'g'),
                        'ion$', '', 'g')
                ELSE modified_term
            END AS modified_term
        FROM acronym_removed
    ),

    -- Remove parentheses and their content and convert to lowercase
    parentheses_removed AS (
        SELECT id,
            LOWER(REGEXP_REPLACE(modified_term, '(\(|\))', '', 'g')) AS modified_term
        FROM suffix_removed
    ),

    -- Replace spaces and dashes with `(\s|-)?`
    spaces_dashes_replaced AS (
        SELECT id,
            REGEXP_REPLACE(modified_term, '( |-)', '(\\s|-)?', 'g') AS final_term
        FROM parentheses_removed
    )

    -- Update the regex_keys column with acronym
    UPDATE taxon_ontol
    SET regex_keys = '(' || (
        SELECT final_term
        FROM spaces_dashes_replaced
        WHERE taxon_ontol.id = spaces_dashes_replaced.id
    ) || CASE 
            WHEN acronym IS NOT NULL THEN '|\s' || acronym || '(\s|\.|\,)' || ')'
            ELSE ')'
        END;

    -- Step 5a: Add thes_match
	UPDATE taxon_ontol
	SET thes_match = NULL;

	WITH regex_prepared AS (
    SELECT id,
           -- Replace the optional space or hyphen with a space, and remove parentheses
           REGEXP_REPLACE(
               REGEXP_REPLACE(
                   LOWER(regex_keys), 
                   '\\(\\s?-\\s?\\)?', ' ', 'g'),
               '[()]', '', 'g'
           ) AS prepared_keys
    FROM taxon_ontol
	),
	matches_found AS (
    	SELECT t.id, s."Header" AS matched_header
    	FROM regex_prepared t
    	JOIN thesaurus s
    	ON LOWER(s."Header") = t.prepared_keys
	)

	UPDATE taxon_ontol
	SET thes_match = matches_found.matched_header
	FROM matches_found
	WHERE taxon_ontol.id = matches_found.id;

    
    -- Step 5b: Add synonyms as alt_labels
    UPDATE taxon_ontol
    SET alt_labels = NULL;
    
    -- Select Synonym in thesaurus table when it is not null and != ''
    WITH synonyms_selected AS (
        SELECT "Synonym", "Header"
        FROM thesaurus
        WHERE "Synonym" IS NOT NULL AND "Synonym" != ''
    ),

    -- Attempt to match individual keys in regex_keys column in taxon_ontol table to Synonym in thesaurus table
    matches_found AS (
        SELECT taxon_ontol.id, taxon_ontol.regex_keys, taxon_ontol.alt_labels, synonyms_selected."Header" AS matched_header
        FROM taxon_ontol
        JOIN synonyms_selected
        ON EXISTS (
            SELECT 1
            FROM unnest(string_to_array(REPLACE(REPLACE(taxon_ontol.regex_keys, '(', ''), ')', ''), '|')) AS key
            WHERE key = LOWER(synonyms_selected."Synonym")
        )
    )

    -- Update alt_labels with matched headers
    UPDATE taxon_ontol
    SET alt_labels = 
        CASE
            WHEN taxon_ontol.alt_labels IS NULL THEN '(' || matches_found.matched_header || ')'
            ELSE 
                regexp_replace(taxon_ontol.alt_labels, '\)$', '') || '|' || matches_found.matched_header || ')'
        END
    FROM matches_found
    WHERE taxon_ontol.id = matches_found.id;

END;
$function$