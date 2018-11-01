-- DROP FUNCTION tinderroulette.SWITCHGROUP(character, text);

CREATE OR REPLACE FUNCTION tinderroulette.ACCEPT_SWITCHGROUP(
	cip_requested character,
	user_cip character,
	idclass text)
RETURNS void AS 
$$
BEGIN
	IF EXISTS (
		SELECT *
		FROM tinderroulette.switchgrouprequest, tinderroulette.groupstudent
		WHERE switchgrouprequest.id_class = idclass
		AND switchgrouprequest.cip = cip_requested
		AND groupstudent.cip = user_cip
		AND groupstudent.id_group = switchgrouprequest.id_group
	) THEN
		-- SWITCHGROUP
		PERFORM tinderroulette.SWITCHGROUP(
		cip_requested, 
		
		user_cip,
		
		(SELECT tinderroulette.groupstudent.id_group
		 FROM tinderroulette.groupstudent
		 INNER JOIN tinderroulette.groups
		 ON tinderroulette.groupstudent.id_group = tinderroulette.groups.id_group
		 AND id_class = idclass
		 AND tinderroulette.groups.id_group_type = 3 
		 AND cip = cip_requested

		),
		 
		( SELECT tinderroulette.switchgrouprequest.id_group
		 FROM tinderroulette.switchgrouprequest, tinderroulette.groupstudent
		 WHERE switchgrouprequest.id_class = idclass
		 AND switchgrouprequest.cip = cip_requested
		 AND groupstudent.cip = user_cip
		 AND groupstudent.id_group = switchgrouprequest.id_group)
		 
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
--SELECT tinderroulette.insert_switchgrouprequest('cotd2511', 'S6GEN60002A18', 2);
--SELECT tinderroulette.insert_switchgrouprequest('fanv2501', 'S6GEN60002A18', 1);
SELECT tinderroulette.ACCEPT_SWITCHGROUP('cotd2511', 'fanv2501', 'S6GEN60002A18');