### Data: PostgreSQL + Drizzle ORM

- Schema lives in `src/db/schema.ts` (or the repo's equivalent) as the single source of
  truth. Change the schema there, then generate a migration — never hand-edit generated SQL.
- Workflow: `drizzle-kit generate` to create a migration, `drizzle-kit migrate` (or the
  app's migrate script) to apply. Don't use `push` against anything but local/dev.
- Prefer the query builder / relational queries; keep raw SQL rare and parameterized.
- Type inference flows from the schema — import inferred types, don't redeclare row shapes.
- Keep DB access behind a repository/query module; don't scatter queries through UI code.
- Connection string is a secret — read from env, never hardcode.
