SET SCHEMA 'tinderroulette';

CREATE OR REPLACE FUNCTION in_class_check()
  RETURNS trigger AS
$$
BEGIN    
    IF NOT EXISTS(SELECT cip, memberclass.id_class 
	FROM tinderroulette.memberclass
	WHERE memberclass.cip =  NEW.cip) THEN
	RAISE EXCEPTION 'Student is not part of this class';
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER in_class_check_trigger
BEFORE INSERT OR UPDATE ON tinderroulette.groupstudent
    FOR EACH ROW EXECUTE PROCEDURE in_class_check();
