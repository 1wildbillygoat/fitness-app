begin;
select set_config('request.jwt.claims','{"sub":"00000000-0000-4000-8000-000000000001"}', true);
insert into workouts(user_id, started_at) values ('00000000-0000-4000-8000-000000000001', now());
select count(*) as my_workouts from workouts where user_id = '00000000-0000-4000-8000-000000000001';
rollback;
