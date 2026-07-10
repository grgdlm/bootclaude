### Data: PostgreSQL + Prisma ORM

- `schema.prisma` is the source of truth. After editing it: `prisma migrate dev`
  (development) / `prisma migrate deploy` (CI/prod). Run `prisma generate` after schema
  changes so the client types update.
- Use a single shared `PrismaClient` instance (avoid instantiating per request; in dev,
  guard against hot-reload creating many clients).
- Watch for N+1: use `include`/`select` deliberately, or `findMany` with relations rather
  than looping queries. Prefer `select` to avoid over-fetching.
- Never interpolate user input into `$queryRawUnsafe`; use parameterized `$queryRaw`.
- Connection string is a secret — env only.
