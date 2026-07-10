### Auth: Clerk

- Wrap the app in the Clerk provider; protect server routes with Clerk's server helpers
  (middleware / `auth()`), not just client `<SignedIn>` guards — client guards are UX,
  server checks are security.
- Only the publishable key is safe client-side; the secret key is server-only.
- Read the user/session from Clerk on the server for anything authoritative; don't pass
  a user id from the client and trust it.
- Sync Clerk users to your DB via webhooks if you store app data keyed by user; verify
  the webhook signature.
