SET SCHEMA 'tinderroulette';

CREATE FUNCTION check_same_team(cip1 character(8), cip2 character(8), activityId int)
 RETURNS boolean
 AS
$body$	
BEGIN
	RETURN EXISTS (SELECT * FROM 
	tinderroulette.groups,
	tinderroulette.groupstudent as t1,
	tinderroulette.groupstudent as t2
	WHERE groups.id_activity = activityId
	AND groups.id_group_type = 1
	AND t1.id_group = groups.id_group
	AND t2.id_group = groups.id_group
	AND t1.cip = cip1
	AND t2.cip = cip2
	AND t1.id_group = t2.id_group);
END
$body$
LANGUAGE plpgsql;
