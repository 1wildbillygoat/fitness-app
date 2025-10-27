import { Hono } from 'hono'
import { z } from 'zod'
const app = new Hono()

app.get('/v1/healthz', (c) => c.text('ok'))

const Workout = z.object({ started_at: z.string().datetime() })
app.post('/v1/workouts', async (c) => {
  const body = await c.req.json().catch(() => ({}))
  const parsed = Workout.safeParse(body)
  if (!parsed.success) return c.json({ error: 'invalid_body' }, 400)
  return c.json({ id: 1, ...parsed.data }, 201)
})

app.post('/v1/inference', (c) => c.json({ request_id: crypto.randomUUID(), status: 'queued' }, 202))
app.get('/v1/inference/:id', (c) => c.json({ id: c.req.param('id'), status: 'succeeded' }))

export default app
