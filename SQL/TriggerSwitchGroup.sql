DROP FUNCTION tinderroulette.switchgroup_check() CASCADE;

CREATE OR REPLACE FUNCTION tinderroulette.switchgroup_check()
RETURNS trigger AS
$$
BEGIN
	IF EXISTS ( SELECT *
		    FROM tinderroulette.groupstudent
		    WHERE cip = NEW.cip
		    AND id_group = NEW.id_group
	) THEN
		RAISE EXCEPTION 'You cannot request a switch in the same group.';
	END IF;
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER switchgroup_check_trigger
BEFORE INSERT ON tinderroulette.switchgrouprequest
FOR EACH ROW EXECUTE PROCEDURE tinderroulette.switchgroup_check();