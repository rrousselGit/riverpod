# 0.2.1

- `useProvider` no longer throws an `UnsupportedError` when the provider listened
  changes, and correctly listen to the new provider.

- `Computed` and `Consumer` now correctly unsubscribe to a provider when their
  function stops using a provider.

# 0.2.0

- `ref.read` is renamed as `ref.dependOn`
- Deprecated `ref.dependOn(streamProvider).stream` and `ref.dependOn(futureProvider).future`
  in favor of a universal `ref.dependOn(provider).value`.
- added `ref.read(provider)`, syntax sugar for `ref.dependOn(provider).value`.

# 0.1.0

Initial release