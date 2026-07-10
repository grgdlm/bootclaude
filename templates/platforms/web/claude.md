## Platform: Web (React + TypeScript)

- Components are function components with hooks. No class components.
- Keep components small and presentational; push data-fetching and side effects to
  hooks or the framework's data layer.
- Type props explicitly. Prefer discriminated unions over boolean flags for variants.
- Accessibility is not optional: semantic elements, labels on inputs, keyboard paths,
  visible focus. Assume this ships to real users.
- No inline styles for anything reusable; follow the repo's styling system.
- Handle loading, empty, and error states for every async view — not just the happy path.
