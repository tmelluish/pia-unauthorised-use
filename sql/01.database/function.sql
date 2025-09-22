CREATE OR REPLACE FUNCTION drop_tables(
  IN tbl text, sch text
)
RETURNS SETOF record AS $$
DECLARE
        query  text;
        t   text;
        schemaname text;
BEGIN
  schemaname := 'public';
  query := 'SELECT tablename FROM pg_tables WHERE schemaname = '''|| schemaname|| ''' and tablename LIKE ''' || tbl || ''';';
  RAISE NOTICE ' % ', query;
  FOR t IN EXECUTE query
  LOOP
  RAISE NOTICE 'Drop table %', quote_ident(t);
   EXECUTE 'DROP TABLE ' || schemaname ||'.'|| quote_ident(t);
  END LOOP;
  RAISE NOTICE 'Done dropping!';
  RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "public".column_exists (ptable text, pcolumn text, pschema text DEFAULT 'public')
    RETURNS boolean
    LANGUAGE sql
    STABLE STRICT
    AS $BODY$
    -- does the requested table.column exist in schema?
    SELECT
        EXISTS (
            SELECT
                NULL
            FROM
                information_schema.columns
            WHERE
                table_name = ptable
                AND column_name = pcolumn
                AND table_schema = pschema);
$BODY$;


CREATE OR REPLACE PROCEDURE "public".rename_column_if_exists (ptable TEXT, pcolumn TEXT, new_name TEXT, pschema text DEFAULT 'public')
LANGUAGE plpgsql
AS $$
BEGIN
    -- Rename the column if it exists.
    IF "public".column_exists (ptable,
        pcolumn,
        pschema) THEN
        IF NOT "public".column_exists(ptable, new_name, pschema) THEN
            EXECUTE FORMAT('ALTER TABLE %I.%I RENAME COLUMN %I TO %I;', pschema, ptable, pcolumn, new_name);
    END IF;
END IF;
END
$$;



CREATE OR REPLACE FUNCTION "public".table_exists (ptable text,  pschema text DEFAULT 'public')
    RETURNS boolean
    LANGUAGE sql
    STABLE STRICT
    AS $BODY$
    -- does the requested table exist in schema?
    SELECT
        EXISTS (
            SELECT
                NULL
            FROM
                information_schema.tables
            WHERE
                table_name = ptable
                AND table_schema = pschema);
$BODY$;


CREATE OR REPLACE PROCEDURE "public".rename_table_if_exists (ptable TEXT, new_name TEXT, pschema text DEFAULT 'public')
LANGUAGE plpgsql
AS $$
BEGIN
    -- Rename the column if it exists.
    IF "public".table_exists (ptable,
        pschema) THEN
        --only rename if the new name is not in use already
        IF NOT "public".table_exists(new_name,pschema) THEN
            EXECUTE FORMAT('ALTER TABLE %I.%I RENAME TO %I;', pschema, ptable, new_name);
    END IF;
END IF;
END
$$;