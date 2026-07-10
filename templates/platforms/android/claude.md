## Platform: Android (Kotlin / Jetpack Compose)

- Kotlin-first, Compose-first unless the repo is Views/XML. Follow Kotlin coding
  conventions and idiomatic Kotlin (expression bodies, `val` over `var`, scope functions
  used judiciously).
- Concurrency via coroutines + `Flow`. Never block the main dispatcher; do IO on
  `Dispatchers.IO`. Expose state as `StateFlow`, collect with lifecycle awareness.
- Compose: hoist state, keep composables side-effect-free, use `remember`/`derivedStateOf`
  correctly, pass stable/immutable params to avoid recomposition, `LazyColumn` for lists.
- Respect lifecycle: no leaks from `Context`, cancel work in `onCleared`, use ViewModel
  for surviving config changes.
- Null-safety: avoid `!!`; model absence with nullable types or sealed results.
- Errors surface as sealed `Result`/UI state, not swallowed exceptions.
