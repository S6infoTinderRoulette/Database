SET SCHEMA 'tinderroulette';

CREATE OR REPLACE FUNCTION remove_request(
	cip1 character(8), 
	cip2 character(8), 
	id_activity integer,
	id_request_type integer)
  RETURNS boolean AS
$BODY$	
	WITH toDelete AS (
		SELECT request.id_activity, 
		request.cip_seeking, 
		request.cip_requested, 
		request.id_request_type FROM tinderroulette.request 
		WHERE (cip_seeking = cip1 OR cip_requested =  cip1) 
		AND (cip_seeking = cip2 OR cip_requested = cip2) 
		AND (id_activity = id_activity)
		AND (id_request_type = id_request_type))
	DELETE FROM tinderroulette.request
	WHERE request.id_activity IN (SELECT id_activity FROM toDelete)
	AND request.cip_seeking IN (SELECT cip_seeking FROM toDelete)
	AND request.cip_requested IN (SELECT cip_requested FROM toDelete)
	AND request.id_request_type IN (SELECT id_request_type FROM toDelete)
	RETURNING true;
$BODY$
LANGUAGE sql VOLATILE
