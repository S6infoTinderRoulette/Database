SET SCHEMA 'tinderroulette';

CREATE FUNCTION check_existing_request(cip1 character(8), cip2 character(8), activityId int)
 RETURNS boolean
 AS
$BODY$	
BEGIN
	RETURN EXISTS (SELECT * FROM tinderroulette.request
	WHERE (request.cip_seeking = cip1)
	AND (request.cip_requested = cip2)
	AND request.id_activity = activityId
	AND id_request_type = 1);
END;
$BODY$
LANGUAGE plpgsql