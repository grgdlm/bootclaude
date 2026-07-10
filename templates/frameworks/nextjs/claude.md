### Framework: Next.js (App Router)

- Default to Server Components. Add `"use client"` only when you need interactivity,
  browser APIs, or hooks — and push it as far down the tree as possible.
- Data fetching happens on the server (in Server Components / route handlers / server
  actions). Don't fetch in a client component when a server one will do.
- Never leak secrets to the client: only `NEXT_PUBLIC_*` env vars are safe in client code.
- Use the file-system router conventions (`page`, `layout`, `loading`, `error`,
  `route`). Co-locate components with their route when they aren't shared.
- Prefer server actions for mutations; validate input on the server regardless of client
  validation. Revalidate/`revalidatePath` after writes.
- Dev: `next dev` · Build: `next build` · Start: `next start`.
