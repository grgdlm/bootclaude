### Auth: Supabase Auth

- Auth integrates with Postgres RLS: policies key off `auth.uid()`. This is the point of
  Supabase auth — enforce access in RLS policies, not in client code.
- Use `@supabase/ssr` patterns for session handling on server frameworks; refresh tokens
  correctly and read the user server-side for protected work.
- The `anon` key is public; `service_role` bypasses RLS and is server-only.
- Never trust `getSession()` on the client as an authorization decision — validate on the
  server / via RLS. Confirm the user with `getUser()` where authenticity matters.
