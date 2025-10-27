Tables: profiles, exercises, workouts, workout_sets, meals, meal_items, biometrics, orgs,
provider_accounts, provider_tokens, events_inbox, media_assets, ml_models, inference_requests,
inference_outputs, foods_ref, consents, audit_log.
Indexes: workouts(user_id, started_at), workout_sets(workout_id, set_index), media_assets(user_id, captured_at).
RLS: owner-only; provider_tokens deny-by-default; audit_log write-only.
