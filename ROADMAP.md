# Roadmap

## Riverpod

<!-- - evaluate time complexity for all operations -->
<!-- - evaluate space complexity -->
<!-- - think about state_notifier & Computed tree-shaking -->

- ref.dependOn(Provider).value -> ref.read(Provider)
- Consumer/Computed close sub when no-longer using a provider (new dep Map on re-compute, reading transfer from old map to new map, remaining ones are destroyed)
- future/changenotifier/...providers cannot return null
- Cannot add dependencies during dispatching
- FutureChangeNotifier
- FutureStateNotifier
- `AutoDispose`
- `overrideAs` AutoDispose
- CI
- Prevent modifying parents from children (widget -> provider)
- DateTime provider
- Make a common interface between ProviderDependency? (So that we can assign Provider to SetStateProvider)
- Should some asserts be changed to exceptions in release?
- Should some exceptions have a custom error?

## Examples

### Marvel

- Write tests for everything
- publish it on the web
- handle errors (out of calls/day, no configurations)
- Added to riverpod.dev

## riverpod.dev

- concepts

  - Provider

    - You can think of providers as streams.\
      But providers are readable synchronously and they have
      a built-in way to combine providers with other providers.

      Similarly, the behavior of a provider can be overridden,
      for testing purposes or objects depending on a provider
      more reusable.

- Combining providers
- Filtering rebuilds
- Testing (without flutter, mocking FutureProvider)
- How it works
- The differences between hooks and not hooks
- cookbook configurations that change over time
- state hydration

## Linter:

- When overriding `StateNotifierProvider` on a non-root `ProviderStateOwner`, warn if the `.value` wasn't overriden too.
- Check that when a provider is overridden locally, all of its dependencies are too
- `provider.overrideAs(provider)` -> `provider`
- `always_specify_name`
- `name_match_variable`
- `providers_allow_specifying_name`
- extract widget as class for rebuild optimization
- warn if public classes inside /src are not used but not exported
- Don't `family(BuildContext)`

## Devtool:

- entire app state for the root `ProviderStateOwner`
- highlight state changes
- Show the number of widgets that rebuilt in the same frame than the state change
- editable state (through Freezed/copyWith/state_notifier)
- time travel
- lock further changes
