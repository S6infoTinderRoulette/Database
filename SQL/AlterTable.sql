ALTER TABLE tinderroulette.logs ALTER COLUMN log_timestamp SET DEFAULT now();
ALTER TABLE tinderroulette.request ALTER COLUMN request_timestamp SET DEFAULT now();
ALTER TABLE tinderroulette.switchgrouprequest ALTER COLUMN switchgroup_timestamp SET DEFAULT now();
ALTER TABLE tinderroulette.friendrequest ALTER COLUMN friendrequest_timestamp SET DEFAULT now();	
ALTER TABLE tinderroulette.activities ALTER COLUMN final SET DEFAULT false;
ALTER TABLE tinderroulette.friendlist ADD CHECK (cip <> friend_cip);
ALTER TABLE tinderroulette.request ADD CHECK (cip_seeking <> cip_requested);
ALTER TABLE tinderroulette.members ADD CHECK ((id_member_status <> 2) OR ((id_member_status = 2) AND (email IS NOT NULL)));