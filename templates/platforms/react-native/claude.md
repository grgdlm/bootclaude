## Platform: React Native

- Shared React + TS rules apply. But this is NOT the web: no DOM, no `div`/`span`,
  use `View`/`Text`/`Pressable`. Every string must live inside a `<Text>`.
- Style via `StyleSheet.create`; respect safe-area insets; design for notches and
  both platforms. Test assumptions on iOS and Android — they diverge.
- Keep the JS thread free: heavy work off-render, use `FlatList`/`FlashList` for long
  lists (never `.map` into a `ScrollView`), memoize row renderers.
- Native modules and permissions differ per platform — guard with `Platform.select`.
- Avoid bridge chatter in hot paths; prefer reanimated/native-driver animations.
