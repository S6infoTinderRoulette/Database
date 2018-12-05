SET SCHEMA 'tinderroulette';

CREATE OR REPLACE FUNCTION create_app()
  RETURNS trigger AS
$$
BEGIN    
    INSERT INTO tinderroulette.classes (id_class, id_app)
	VALUES (NEW.id_app, NEW.id_app);
    RETURN NULL; -- result is ignored since this is an AFTER trigger
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER create_app_trigger
AFTER INSERT ON tinderroulette.APP
    FOR EACH ROW EXECUTE PROCEDURE create_app();
