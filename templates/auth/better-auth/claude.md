### Auth: Better Auth

- Config lives in one server-side auth instance; the client uses the generated client.
  Keep the secret and provider credentials in env, never in client code.
- Always verify the session on the server for protected actions/routes — never trust a
  client-held flag. Gate mutations and sensitive reads server-side.
- Extend via the schema/plugins rather than forking flows; keep the user/session tables
  in the same migration workflow as the rest of your DB.
- On sign-out and privilege changes, ensure sessions are actually invalidated.
