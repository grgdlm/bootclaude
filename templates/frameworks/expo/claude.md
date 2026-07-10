### Framework: Expo (React Native)

- Use Expo Router (file-based) if present. Prefer Expo SDK modules over bare native
  libraries so the managed workflow keeps working.
- Only `EXPO_PUBLIC_*` env vars reach the app bundle; anything sensitive stays server-side.
- Before adding a library that needs native code, check it's config-plugin compatible;
  otherwise it forces a prebuild/bare workflow — flag that trade-off explicitly.
- Test on both platforms via Expo Go / dev client; don't assume iOS behavior on Android.
- Dev: `npx expo start` · Prebuild (only if unavoidable): `npx expo prebuild`.
