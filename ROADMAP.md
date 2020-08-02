# Roadmap

## Riverpod

## Examples

- synchronizing two lists with the same editable content
  (two todo lists, editing a todo in one list edits it in another list too)

### Marvel

- Write tests for everything
- publish it on the web
- handle errors (out of calls/day, no configurations)
- Added to riverpod.dev

## riverpod.dev

- Combining providers
- Filtering rebuilds
- pre-fetch a provider
- Testing (without flutter, mocking FutureProvider)
- How it works
- The differences between hooks and not hooks
- fundamentals
  - ProviderScope
- FAQ
  - My Consumer behaves differently inside overlays/transition
- cookbooks:
  - migration from provider
  - list items + family, don't pass the id to the item and instead expose a "currentItem" provider
  - canceling http requests when leaving the screen
  - state hydration
  - configurations that change over time

## Linter:

- No circular dependency
- Check that when a provider is overridden locally, all of its dependencies are too
- `provider.overrideAs(provider)` -> `provider`
- `always_specify_name`
- `name_match_variable`
- `providers_allow_specifying_name`
- extract widget as class for rebuild optimization
- warn if public classes inside /src are not used but not exported
- Don't `family(BuildContext)`

## Devtool:

- entire app state for the root `ProviderContainer`
- highlight state changes
- Show the number of widgets that rebuilt in the same frame than the state change
- editable state (through Freezed/copyWith/state_notifier)
- time travel
- lock further changes
