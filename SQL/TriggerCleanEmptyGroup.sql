SET SCHEMA 'tinderroulette'

CREATE OR REPLACE FUNCTION clean_empty_group()
  RETURNS trigger AS
$$
BEGIN    
    IF NOT EXISTS (SELECT * FROM tinderroulette.groupstudent WHERE id_group = OLD.id_group) THEN
	    DELETE FROM tinderroulette.groups
		WHERE id_group = OLD.id_group;
    END IF;
    RETURN NULL;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER clean_empty_group_trigger
AFTER UPDATE OR DELETE ON tinderroulette.groupstudent
    FOR EACH ROW EXECUTE PROCEDURE clean_empty_group();

