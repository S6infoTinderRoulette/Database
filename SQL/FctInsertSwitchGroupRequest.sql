-- DROP FUNCTION tinderroulette.insert_switchgrouprequest(character, text, integer);

CREATE OR REPLACE FUNCTION tinderroulette.insert_switchgrouprequest(
	user_cip character,
	id_class text,
	index integer)
RETURNS void AS
$$
	INSERT INTO tinderroulette.switchgrouprequest(id_group, cip, id_class) ( 
	SELECT id_group, user_cip, id_class
	FROM tinderroulette.groups WHERE groups.id_class = id_class and group_index = index and id_group_type = 3)
$$
LANGUAGE sql;

-- Test
-- SELECT tinderroulette.insert_switchgrouprequest('cotd2511', 'S6GEN60002A18', 2);