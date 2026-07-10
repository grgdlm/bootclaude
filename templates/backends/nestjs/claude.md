### Backend: NestJS

- Organize by module. Controllers stay thin; business logic lives in providers (services).
  Don't put data access or rules in controllers.
- Use dependency injection (constructor injection); never instantiate services manually.
- Validate DTOs with `class-validator` and a global `ValidationPipe` (`whitelist: true`,
  `transform: true`). Reject unknown properties. Never trust request payloads.
- Enforce authn/authz with Guards on protected routes, not ad-hoc checks in handlers.
- Return consistent errors via the `HttpException` hierarchy and exception filters; don't
  throw raw errors that leak internals.
- Keep configuration and secrets in `ConfigModule`/env, never hardcoded. Use interceptors
  for cross-cutting concerns (logging, serialization, timeouts).
