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

### Introduction screen

- Insert a nested UncontrollerProviderScope
- Pass it a ProviderContainer that overrides the repositories & co to use a specific data-set


## riverpod.dev

- Filtering rebuilds
- "why is my state disposed with autoDisposed?" (read when unlistened)
- pre-fetch a provider
- Testing (without flutter, mocking FutureProvider)
- How it works
- The differences between hooks and not hooks
- fundamentals
  - ProviderScope
- talks and articles
- FAQ
  - My Consumer behaves differently inside overlays/transition
  - How to prefetch data _in the main_
- cookbooks:
  - migration from provider
  - list items + family, don't pass the id to the item and instead expose a "currentItem" provider
  - canceling http requests when leaving the screen
  - state hydration
  - configurations that change over time
- DO/DON'T
  - import lints
  - DO create a provider for states you want to read multiple times

## Linter:

- "unused_widget_parameter"
- "what caused a widget to rebuild?"
- Don't create providers inside `build` (https://github.com/rrousselGit/river_pod/issues/144#issuecomment-695361486)
- don't mutate other providers inside "create" (https://github.com/rrousselGit/river_pod/issues/144#issuecomment-695764973)
- wrap with `Consumer`
- No circular dependency
- warn about `ref.watch(autoDispose)` after an await (https://github.com/rrousselGit/river_pod/issues/243)
- warn watch(autoDispose) in non-autoDispose provider
- `always_specify_name`
- `name_match_variable`
- extract widget as class for rebuild optimization
- warn if public classes inside /src are not used but not exported

## Devtool:

- entire app state for the root `ProviderContainer`
- highlight state changes
- Show the number of widgets that rebuilt in the same frame than the state change
- editable state (through Freezed/copyWith/state_notifier)
- time travel
- lock further changes
