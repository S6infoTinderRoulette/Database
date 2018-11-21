

CREATE OR REPLACE FUNCTION tinderroulette.get_switch_request(
	cipUser character)
RETURNS TABLE(id_group integer, cip text, id_class text, group_index int)
AS
$$
	SELECT switchgrouprequest.id_group, switchgrouprequest.cip::text, 
	switchgrouprequest.id_class, groups.group_index
	FROM tinderroulette.memberclass, tinderroulette.switchgrouprequest, tinderroulette.groupstudent, tinderroulette.groups
	WHERE memberclass.cip = cipUser
	AND memberclass.id_class = switchgrouprequest.id_class
	AND memberclass.cip <> switchgrouprequest.cip
	AND memberclass.cip = groupstudent.cip
	AND groupstudent.id_group = switchgrouprequest.id_group
	AND switchgrouprequest.id_group = groups.id_group
$$
LANGUAGE sql;

--SELECT * FROM tinderroulette.get_switch_request('fanv2501')