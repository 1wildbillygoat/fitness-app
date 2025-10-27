begin;
select set_config('request.jwt.claims','{"sub":"00000000-0000-4000-8000-000000000001"}', true);
insert into profiles(id, display_name) values ('00000000-0000-4000-8000-000000000001','userA') on conflict do nothing;
select count(*) as own_profile_rows from profiles where id = '00000000-0000-4000-8000-000000000001';
rollback;
