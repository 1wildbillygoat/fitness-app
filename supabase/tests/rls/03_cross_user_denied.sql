begin;
-- seed as admin (adjust if no superuser)
set role postgres;
insert into workouts(user_id, started_at) values ('00000000-0000-4000-8000-000000000001', now());
reset role;

select set_config('request.jwt.claims','{"sub":"00000000-0000-4000-8000-000000000002"}', true);
select count(*) as cross_user_reads from workouts where user_id = '00000000-0000-4000-8000-000000000001';
rollback;
