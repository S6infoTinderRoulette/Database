SET SCHEMA 'tinderroulette';

CREATE OR REPLACE FUNCTION merge_teams(
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
	IF (tinderroulette.check_existing_request(_cip1,_cip2,_id_activity)) THEN
		IF NOT (tinderroulette.check_same_team(_cip1,_cip2,_id_activity)) THEN
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
					PERFORM tinderroulette.remove_request(_cip1,_cip2,_id_activity);
					team_created := TRUE;
				END IF;
			ELSIF (nb_groups = 1) THEN
				IF (tinderroulette.group_size_check(nb_membre::int + 1,_id_activity)) THEN
					IF NOT EXISTS (SELECT * FROM temp_groups WHERE temp_groups.cip = _cip1) THEN				
						IF NOT (SELECT * FROM tinderroulette.check_duplicate_cip(_cip1,_id_activity)) THEN
							INSERT INTO tinderroulette.groupstudent (cip, id_group)
							SELECT DISTINCT _cip1 , id_group FROM temp_groups;	
							PERFORM tinderroulette.remove_request(_cip1,_cip2,_id_activity);				
							team_created := TRUE;
						END IF;
					ELSE
						IF NOT (SELECT * FROM tinderroulette.check_duplicate_cip(_cip2,_id_activity)) THEN
							INSERT INTO tinderroulette.groupstudent (cip, id_group)
							SELECT DISTINCT _cip2 , id_group FROM temp_groups;
							PERFORM tinderroulette.remove_request(_cip1,_cip2,_id_activity);								
							team_created := TRUE;
						END IF;			
					END IF;
				END IF;
			ELSE
				IF (tinderroulette.group_size_check(2,_id_activity)) THEN
					IF NOT ((SELECT * FROM tinderroulette.check_duplicate_cip(_cip1,_id_activity))
					AND (SELECT * FROM tinderroulette.check_duplicate_cip(_cip2,_id_activity))) THEN 
						WITH newGroup AS (
							INSERT INTO tinderroulette.groups (id_group_type, id_activity)
							VALUES (1,_id_activity)
							RETURNING id_group)
						INSERT INTO tinderroulette.groupstudent (cip, id_group)
						SELECT _cip1, newGroup.id_group FROM newGroup
						UNION
						SELECT _cip2, newGroup.id_group FROM newGroup;
						PERFORM tinderroulette.remove_request(_cip1,_cip2,_id_activity);
						team_created := TRUE;
					END IF;
				END IF;
			END IF;
			DROP TABLE temp_groups;
		END IF;
	END IF;
	RETURN team_created;
END;
$BODY$
  LANGUAGE plpgsql