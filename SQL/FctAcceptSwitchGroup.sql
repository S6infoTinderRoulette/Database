-- DROP FUNCTION tinderroulette.SWITCHGROUP(character, text);

CREATE OR REPLACE FUNCTION tinderroulette.ACCEPT_SWITCHGROUP(
	cip_requested character,
	user_cip character,
	idclass text)
RETURNS void AS 
$$
BEGIN
	IF EXISTS (
		SELECT id_group
		FROM tinderroulette.switchgrouprequest
		WHERE id_class = idclass
		AND cip = cip_requested
	) THEN
		-- SWITCHGROUP
		PERFORM tinderroulette.SWITCHGROUP(
		cip_requested, 
		user_cip,
		(SELECT id_group FROM tinderroulette.groupstudent WHERE cip = cip_requested),
		(SELECT id_group FROM tinderroulette.groupstudent WHERE cip = user_cip)
		);
		
		-- DELETE REQUEST IN SWITCHGROUPREQUEST
		DELETE FROM tinderroulette.switchgrouprequest
		WHERE cip = cip_requested
		AND id_class = id_class;
		DELETE FROM tinderroulette.switchgrouprequest
		WHERE cip = user_cip
		AND id_class = id_class;
	END IF;
END
$$
LANGUAGE plpgsql;

--SELECT tinderroulette.SWITCHGROUP('cotd2511', 'fanv2501', 1, 2); 
SELECT tinderroulette.ACCEPT_SWITCHGROUP('cotd2511', 'fanv2501', 'S6GEN60002A18');