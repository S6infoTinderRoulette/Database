SET SCHEMA 'tinderroulette';

CREATE OR REPLACE FUNCTION get_switch_group(_cip character(8), _id_class text)
  RETURNS TABLE(cip character(8), id_group integer) AS
$BODY$
	SELECT t1.cip, t1.id_group
	FROM tinderroulette.switchgrouprequest as t1
	WHERE t1.cip = _cip 
	AND t1.id_class = _id_class;
$BODY$
LANGUAGE sql;

SELECT * from tinderroulette.get_switch_group('cotd2511', 'S6GEN60002A18');
--SELECT tinderroulette.insert_switchgrouprequest('cotd2511', 'S6GEN60002A18', 1);