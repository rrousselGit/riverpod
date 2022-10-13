# Roadmap

## Linter:

- Don't create providers inside `build` (https://github.com/rrousselGit/riverpod/issues/144#issuecomment-695361486)
- don't mutate other providers inside "create" (https://github.com/rrousselGit/riverpod/issues/144#issuecomment-695764973)
- wrap with `Consumer`
- No circular dependencies
- warn about `ref.watch(autoDispose)` after an await (https://github.com/rrousselGit/riverpod/issues/243)
- warn watch(autoDispose) in non-autoDispose provider
- `always_specify_name`
- `name_match_variable`
- extract widget as class for rebuild optimization

## Devtool:

- "what caused a widget to rebuild?"
- entire app state for the root `ProviderContainer`
- highlight state changes
- Show the number of widgets that rebuilt in the same frame than the state change
- editable state (through Freezed/copyWith/state_notifier)
- time travel
- lock further changes
