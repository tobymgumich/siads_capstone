CREATE OR REPLACE FUNCTION public.prevent_duplicate_wikipage()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Check if the new title value already exists in table
    IF EXISTS (SELECT 1 FROM wikipages WHERE title = NEW.title) THEN
        RAISE EXCEPTION 'Duplicate title value: %', NEW.title;
    END IF;
    RETURN NEW;

	-- Check if the new path value already exists in table
    -- IF EXISTS (SELECT 1 FROM wikipages WHERE "path" = NEW.path) THEN
        -- RAISE EXCEPTION 'Duplicate path value: %', NEW.path;
    -- END IF;
    -- RETURN NEW;
END;
$function$
