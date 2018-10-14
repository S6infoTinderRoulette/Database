SET SCHEMA 'tinderroulette';

WITH groupWithSpotLeft AS (
	WITH teamPlusSizeLeft AS (
		SELECT nbteamplussize, teamsize FROM tinderroulette.get_number_group(1)),
	existingGroup AS (
		SELECT * FROM tinderroulette.get_current_group(1))
	SELECT existingGroup.groupid FROM existingGroup, teamPlusSizeLeft 
	WHERE existingGroup.teamsize < teamPlusSizeLeft.teamsize
	UNION 
	SELECT existingGroup.groupid FROM existingGroup, teamPlusSizeLeft
	WHERE existingGroup.teamsize = teamPlusSizeLeft.teamsize
	AND teamPlusSizeLeft.nbteamplussize >
	(SELECT COUNT(*) 
	 FROM existingGroup, teamPlusSizeLeft 
	 WHERE teamPlusSizeLeft.teamsize + 1 = existingGroup.teamsize	 )
)
SELECT groupstudent.id_group, groupstudent.cip 
FROM tinderroulette.groupstudent, groupWithSpotLeft
WHERE groupstudent.id_group = groupWithSpotLeft.groupid;

