insert into exercises(name, body_part, equipment) values
('Back squat','legs','barbell'),
('Bench press','chest','barbell'),
('Deadlift','back','barbell')
on conflict do nothing;
