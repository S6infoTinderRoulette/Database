SET SCHEMA 'tinderroulette';

CREATE OR REPLACE FUNCTION clean_request()
  RETURNS trigger AS
$$
BEGIN    
   WITH toDelete AS (
	WITH activity AS (
		SELECT id_activity as id FROM tinderroulette.groups WHERE groups.id_group = NEW.id_group
	)
	SELECT DISTINCT request.id_activity, 
		request.cip_seeking, 
		request.cip_requested, 
		request.id_request_type
	FROM 
		activity,
		tinderroulette.get_full_group(activity.id) as fullgroup,
		tinderroulette.request 
	WHERE request.id_activity = activity.id
	AND (request.cip_seeking = fullgroup.cip OR request.cip_requested = fullgroup.cip))
    DELETE FROM tinderroulette.request
	WHERE request.id_activity IN (SELECT id_activity FROM toDelete)
	AND request.cip_seeking IN (SELECT cip_seeking FROM toDelete)
	AND request.cip_requested IN (SELECT cip_requested FROM toDelete)
	AND request.id_request_type IN (SELECT id_request_type FROM toDelete);
    RETURN NULL;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER clean_request_trigger
AFTER INSERT OR UPDATE ON tinderroulette.groupstudent
    FOR EACH ROW EXECUTE PROCEDURE clean_request();
