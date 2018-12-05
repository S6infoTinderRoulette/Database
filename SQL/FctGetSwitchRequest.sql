

CREATE OR REPLACE FUNCTION tinderroulette.get_switch_request(
	cipUser character)
RETURNS TABLE(id_group integer, cip text, id_class text, group_index int, group_index_init int)
AS
$$
	SELECT switchgrouprequest.id_group, switchgrouprequest.cip::text, 
	switchgrouprequest.id_class, groups1.group_index, groups2.group_index
	FROM tinderroulette.memberclass, tinderroulette.switchgrouprequest, 
	tinderroulette.groupstudent as groupstudent1, tinderroulette.groupstudent as groupstudent2,
	tinderroulette.groups as groups1, tinderroulette.groups as groups2
	WHERE memberclass.cip = cipUser
	AND memberclass.id_class = switchgrouprequest.id_class
	AND memberclass.cip <> switchgrouprequest.cip
	AND memberclass.cip = groupstudent1.cip
	AND groupstudent1.id_group = switchgrouprequest.id_group
	AND switchgrouprequest.id_group = groups1.id_group
	AND switchgrouprequest.cip = groupstudent2.cip
	AND groupstudent2.id_group = groups2.id_group
	AND groups2.group_index <> groups1.group_index
$$
LANGUAGE sql;

--SELECT * FROM tinderroulette.get_switch_request('fanv2501')

