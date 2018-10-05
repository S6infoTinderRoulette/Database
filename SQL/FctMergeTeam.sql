SET SCHEMA 'tinderroulette';

CREATE OR REPLACE FUNCTION tinderroulette.merge_teams(
	_cip1 character(8), 
	_cip2 character(8), 
	_id_activity integer)
  RETURNS boolean AS
$BODY$
DECLARE 
nb_groups bigint;
nb_membre bigint;
team_created boolean = FALSE;
BEGIN
	IF (NOT tinderroulette.check_same_team(_cip1,_cip2,_id_activity)) THEN
		CREATE TEMP TABLE temp_groups AS
		SELECT * FROM tinderroulette.get_team(_cip1,_id_activity) UNION
		SELECT * FROM tinderroulette.get_team(_cip2,_id_activity);
		
		nb_groups := (SELECT COUNT(DISTINCT temp_groups.id_group) FROM temp_groups);
		nb_membre := (SELECT COUNT(cip) FROM temp_groups);
		
		IF (nb_groups = 2) THEN		
			IF (tinderroulette.group_size_check(nb_membre::int,_id_activity)) THEN
				UPDATE tinderroulette.groupstudent
				   SET id_group = (SELECT id_group FROM temp_groups LIMIT 1)
				WHERE (cip, id_group) IN (SELECT * FROM temp_groups);
				team_created := TRUE;
			END IF;
		ELSIF (nb_groups = 1) THEN
			IF (tinderroulette.group_size_check(nb_membre::int + 1,_id_activity)) THEN
				team_created := TRUE;
			END IF;
		ELSE
			IF (tinderroulette.group_size_check(2,_id_activity)) THEN
				team_created := TRUE;
			END IF;
		END IF;
		DROP TABLE temp_groups;
	END IF;
	RETURN team_created;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;