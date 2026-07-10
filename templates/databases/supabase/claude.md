### Data: Supabase (Postgres)

- Supabase is Postgres — schema changes belong in versioned migrations
  (`supabase/migrations/`), not ad-hoc dashboard edits you forget to capture.
- **Row Level Security is the real authorization layer.** Assume RLS is ON; every table
  needs policies. Never rely on client-side checks alone. When adding a table, add its
  policies in the same change.
- The `anon` key is public and safe for the client; the `service_role` key bypasses RLS
  and must ONLY be used server-side. Never ship it to the client.
- Prefer typed access via generated types (`supabase gen types typescript`).
- Use the JS client's query builder; for complex logic use Postgres functions/RPC.
