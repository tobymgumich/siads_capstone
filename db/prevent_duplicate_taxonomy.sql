CREATE OR REPLACE FUNCTION public.prevent_duplicate_taxonomy()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Check if the new taxonomy value already exists in ai_terms
    IF EXISTS (SELECT 1 FROM taxon_ontol WHERE taxonomy = NEW.taxonomy) THEN
        RAISE EXCEPTION 'Duplicate taxonomy value: %', NEW.taxonomy;
    END IF;
    RETURN NEW;
END;
$function$
