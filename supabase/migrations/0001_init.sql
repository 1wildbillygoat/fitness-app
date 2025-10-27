-- Core schema (MVP)
create table if not exists profiles(
  id uuid primary key,
  display_name text,
  created_at timestamptz default now()
);
create table if not exists exercises(
  id bigserial primary key,
  name text not null,
  body_part text,
  equipment text
);
create table if not exists workouts(
  id bigserial primary key,
  user_id uuid not null,
  started_at timestamptz default now(),
  ended_at timestamptz
);
create table if not exists workout_sets(
  id bigserial primary key,
  workout_id bigint not null references workouts(id) on delete cascade,
  exercise_id bigint not null references exercises(id),
  set_index int not null,
  reps int,
  weight_kg numeric(6,2),
  rpe numeric(3,1),
  tempo text
);
create table if not exists meals(
  id bigserial primary key,
  user_id uuid not null,
  ate_at timestamptz default now(),
  meal_type text check (meal_type in ('breakfast','lunch','dinner','snack')),
  notes text
);
create table if not exists meal_items(
  id bigserial primary key,
  meal_id bigint not null references meals(id) on delete cascade,
  food_name text not null,
  quantity numeric(10,3),
  unit text,
  kcal int,
  protein_g numeric(6,2),
  carbs_g numeric(6,2),
  fat_g numeric(6,2)
);
create table if not exists biometrics(
  id bigserial primary key,
  user_id uuid not null,
  captured_at date not null,
  weight_kg numeric(6,2),
  bodyfat_pct numeric(5,2),
  sleep_hours numeric(4,2)
);

-- RLS
alter table profiles enable row level security;
alter table workouts enable row level security;
alter table workout_sets enable row level security;
alter table meals enable row level security;
alter table meal_items enable row level security;
alter table biometrics enable row level security;

-- Policies (owner-only)
create policy if not exists workouts_read on workouts for select using (auth.uid() = user_id);
create policy if not exists workouts_insert on workouts for insert with check (auth.uid() = user_id);
create policy if not exists workouts_update on workouts for update using (auth.uid() = user_id);

create policy if not exists profiles_read on profiles for select using (auth.uid() = id);
create policy if not exists profiles_insert on profiles for insert with check (auth.uid() = id);
create policy if not exists profiles_update on profiles for update using (auth.uid() = id);

create policy if not exists meals_read on meals for select using (auth.uid() = user_id);
create policy if not exists meals_insert on meals for insert with check (auth.uid() = user_id);
create policy if not exists meals_update on meals for update using (auth.uid() = user_id);

create policy if not exists meal_items_rw on meal_items
  for all using (exists (select 1 from meals m where m.id = meal_items.meal_id and m.user_id = auth.uid()))
  with check (exists (select 1 from meals m where m.id = meal_items.meal_id and m.user_id = auth.uid()));

create policy if not exists biometrics_rw on biometrics
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Indexes
create index if not exists idx_workouts_user_started on workouts(user_id, started_at desc);
create index if not exists idx_sets_workout_setindex on workout_sets(workout_id, set_index);
create index if not exists idx_meals_user_ateat on meals(user_id, ate_at desc);
create index if not exists idx_biometrics_user_date on biometrics(user_id, captured_at desc);
