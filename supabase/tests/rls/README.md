# RLS Test Suite
Goal: prove owner-only access and deny cross-user reads/writes.
Simulate users by setting request.jwt.claims -> {"sub": "<uuid>"}.
