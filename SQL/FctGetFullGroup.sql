SET SCHEMA 'tinderroulette';

CREATE FUNCTION get_full_group(activityId int)
RETURNS TABLE(id_group integer, cip character(8))
 AS
$body$
	SELECT groupstudent.id_group, groupstudent.cip
	FROM tinderroulette.get_open_group(activityId) as opengroup
	RIGHT JOIN tinderroulette.groupstudent ON groupstudent.id_group = opengroup.id_group
	JOIN tinderroulette.groups ON groups.id_activity = activityId AND groups.id_group = groupstudent.id_group
	WHERE opengroup.id_group IS NULL
$body$
LANGUAGE sql;