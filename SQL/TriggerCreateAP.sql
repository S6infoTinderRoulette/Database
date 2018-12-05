SET SCHEMA 'tinderroulette';

CREATE OR REPLACE FUNCTION create_ap()
  RETURNS trigger AS
$$
BEGIN    
    INSERT INTO tinderroulette.classes (id_class, id_ap)
	VALUES (NEW.id_ap, NEW.id_ap);
    RETURN NULL; -- result is ignored since this is an AFTER trigger
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER create_ap_trigger
AFTER INSERT ON tinderroulette.AP
    FOR EACH ROW EXECUTE PROCEDURE create_ap();
