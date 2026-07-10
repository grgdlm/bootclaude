### Backend: Hono

- Small, runtime-agnostic web framework (Node, Bun, Deno, Workers). Keep handlers thin
  and avoid coupling business logic to the request/response objects.
- Validate every input (body, query, params, headers) with a schema validator such as
  `@hono/zod-validator`. Never trust client data.
- Put cross-cutting concerns (auth, logging, CORS, rate limiting) in middleware. Configure
  CORS with an explicit allowlist; do not reflect arbitrary origins.
- Read secrets from the runtime env/binding, never hardcoded. Don't leak stack traces or
  internal details in error responses.
- Handle errors centrally with `app.onError` and `HTTPException`; return correct status
  codes, not `200` with an error body.
- If a TypeScript client consumes the API, expose the RPC (`hc`) types for end-to-end typing.
