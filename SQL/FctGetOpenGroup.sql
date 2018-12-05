SET SCHEMA 'tinderroulette';

CREATE FUNCTION get_open_group(activityId int)
 RETURNS TABLE(id_group integer, cip character(8))
 AS
$body$
	WITH groupWithSpotLeft AS (
		WITH teamPlusSizeLeft AS (
			SELECT nbteamplussize, teamsize 
			FROM tinderroulette.get_number_group(activityId)), existingGroup AS (
			SELECT *
			FROM tinderroulette.get_current_group(activityId))
		SELECT existingGroup.groupid
		FROM existingGroup, teamPlusSizeLeft 
		WHERE existingGroup.teamsize < teamPlusSizeLeft.teamsize
		UNION 
		SELECT existingGroup.groupid FROM existingGroup, teamPlusSizeLeft
		WHERE existingGroup.teamsize = teamPlusSizeLeft.teamsize
		AND teamPlusSizeLeft.nbteamplussize >
		(SELECT COUNT(*) 
		 FROM existingGroup, teamPlusSizeLeft 
		 WHERE teamPlusSizeLeft.teamsize + 1 = existingGroup.teamsize))
	SELECT groupstudent.id_group, groupstudent.cip 
	FROM tinderroulette.groupstudent, groupWithSpotLeft
	WHERE groupstudent.id_group = groupWithSpotLeft.groupid;
$body$
LANGUAGE sql;
