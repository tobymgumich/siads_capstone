CREATE OR REPLACE FUNCTION public.create_wiki_search()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Drop the existing table if it exists
    DROP TABLE IF EXISTS wiki_search;

    -- Create the new wiki_search table
    CREATE TABLE wiki_search (
        id serial PRIMARY KEY,
        tax_id INT2 NOT NULL,
        tax_term VARCHAR NOT NULL,
        search_wiki BOOLEAN DEFAULT false,
        search_term VARCHAR,
        wikipages_path VARCHAR,
        wikipages_synonyms VARCHAR
    );

    -- Populate the wiki_search table
    INSERT INTO wiki_search (tax_id, tax_term, search_wiki)
    SELECT id, term, wiki_search
    FROM taxon_ontol
    WHERE wiki_search = TRUE;

    -- Process search terms
    UPDATE wiki_search
    SET search_term = (
        -- Remove 2-4 character words in all caps and parentheses
        REGEXP_REPLACE(tax_term, '\s*\([A-Z]{2,6}\)\s*', '', 'g')
    );

    -- Remove trailing 's' from search_term or tax_term
    UPDATE wiki_search
    SET search_term = 
        CASE 
            WHEN search_term IS NOT NULL THEN 
                REGEXP_REPLACE(search_term, 's$', '')
            ELSE 
                REGEXP_REPLACE(tax_term, 's$', '')
        END;

    -- Update search_term from wiki_search_man if it exists
    UPDATE wiki_search ws
    SET search_term = wsm.search_term
    FROM wiki_search_man wsm
    WHERE ws.tax_term = wsm.tax_term;

    -- Match with wikipages
    UPDATE wiki_search ws
    SET wikipages_path = w.path
    FROM wikipages w
    WHERE LOWER(TRIM(w.title)) LIKE LOWER(TRIM(ws.search_term)) || '%';

END;
$function$
