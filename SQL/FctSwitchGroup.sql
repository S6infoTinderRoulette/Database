DROP FUNCTION tinderroulette.SWITCHGROUP(character, character, integer, integer);

CREATE OR REPLACE FUNCTION tinderroulette.SWITCHGROUP(
	cip1 character,
	cip2 character,
	id_group1 integer,
	id_group2 integer)
RETURNS void AS
$$
	UPDATE tinderroulette.GROUPSTUDENT SET id_group = id_group2 WHERE cip = cip1 and id_group = id_group1;
	UPDATE tinderroulette.GROUPSTUDENT SET id_group = id_group1 WHERE cip = cip2 and id_group = id_group2;
$$
LANGUAGE SQL;

-- TEST
-- SELECT tinderroulette.SWITCHGROUP('cotd2511', 'fanv2501', 1, 2);