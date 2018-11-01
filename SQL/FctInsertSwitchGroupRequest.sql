-- DROP FUNCTION tinderroulette.insert_switchgrouprequest(character, text, integer);

CREATE OR REPLACE FUNCTION tinderroulette.insert_switchgrouprequest(
	user_cip character,
	idClass text,
	index integer)
RETURNS int AS
$$
	INSERT INTO tinderroulette.switchgrouprequest(id_group, cip, id_class) ( 
	SELECT groups.id_group, user_cip, groups.id_class
	FROM tinderroulette.groups WHERE groups.id_class = idClass and group_index = index and id_group_type = 3) RETURNING switchgrouprequest.id_group;
$$
LANGUAGE sql;

-- Test
--SELECT tinderroulette.insert_switchgrouprequest('abia2601', 's6eAPP 3A18', 3);
-- SELECT tinderroulette.insert_switchgrouprequest('fanv2501', 'S6GEN60002A18', 1);
