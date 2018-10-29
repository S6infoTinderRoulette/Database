SET SCHEMA 'tinderroulette';

CREATE OR REPLACE FUNCTION user_leave_group(userCip character(8), activityId int)
 RETURNS int
 AS
$body$
	WITH toDelete AS (
		SELECT groupstudent.cip, groupstudent.id_group
		FROM tinderroulette.groups, tinderroulette.groupstudent
		WHERE groupstudent.cip = userCip
		AND groups.id_activity = activityId
		AND groups.id_group_type = 1
		AND groups.id_group = groupstudent.id_group),
	fullGroup AS (
		SELECT DISTINCT fullGroup.id_group FROM tinderroulette.get_full_group(activityId) as fullGroup
	)
	DELETE FROM tinderroulette.groupstudent
	WHERE groupstudent.cip IN (SELECT toDelete.cip FROM toDelete)
	AND groupstudent.id_group IN (SELECT toDelete.id_group FROM toDelete)
	AND groupstudent.id_group NOT IN (SELECT fullGroup.id_group FROM fullGroup)
	RETURNING groupstudent.id_group
$body$
  LANGUAGE SQL


