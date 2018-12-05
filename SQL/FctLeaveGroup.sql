SET SCHEMA 'tinderroulette';

CREATE OR REPLACE FUNCTION leave_group(userCip character(8), activityId int)
 RETURNS boolean
 AS
$body$
DECLARE 
groupId int;
left_group boolean = FALSE;
BEGIN
    IF NOT (SELECT final FROM tinderroulette.activities 
    WHERE activities.id_activity = activityId) THEN    
	groupId := (tinderroulette.user_leave_group(userCip, activityId));
	IF (SELECT COUNT(*) FROM tinderroulette.groupstudent 
	WHERE groupstudent.id_group = groupId) < 2 THEN
		DELETE FROM tinderroulette.groupstudent 
		WHERE groupstudent.id_group = groupId;		
	END IF;
	IF groupId IS NOT NULL THEN
		left_group := TRUE;
	END IF;
    END IF;
    RETURN left_group;
END
$body$
  LANGUAGE plpgsql

