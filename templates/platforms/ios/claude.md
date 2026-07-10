## Platform: iOS (Swift / SwiftUI)

- Swift-first, SwiftUI-first unless the repo is UIKit. Follow Swift API Design Guidelines
  (clear call sites, `lowerCamelCase`, no Hungarian notation).
- Prefer value types (`struct`, `enum`) and immutability; use `class` only for identity
  or reference semantics you actually need.
- Concurrency: use `async/await` and actors; never block the main thread. UI updates on
  `@MainActor`. Avoid `DispatchQueue` unless bridging older APIs.
- SwiftUI: small composable views, state ownership via `@State`/`@Binding`/`@Observable`
  chosen deliberately; avoid massive body expressions.
- Handle optionals safely — no force-unwraps (`!`) outside tests/prototyping.
- Errors are typed and thrown, not swallowed. Use `Result`/`throws`, not silent `nil`.
