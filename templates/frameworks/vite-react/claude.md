### Framework: Vite + React (SPA)

- Pure client-side app. There is no server here — data comes from a separate API;
  keep the fetch layer (client, query hooks) clearly separated from UI.
- Use a data-fetching library (TanStack Query or similar) for caching, retries, and
  loading/error state rather than hand-rolled `useEffect` fetches.
- Only `VITE_*` env vars are exposed to the client, and everything client-side is public
  by definition — never put a secret in this codebase.
- Keep the bundle lean: lazy-load routes/heavy components (`React.lazy` + `Suspense`),
  watch for accidental large deps.
- Dev: `vite` · Build: `vite build` · Preview: `vite preview`.
