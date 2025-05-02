This list is a set of important objects to interact
with "providers".

Some key objects are:
- [AsyncValue][], to allow the UI to change its rendering based on the status
  of a provider
- [ProviderContainer][]/[ProviderScope][]: The entrypoint of Riverpod, and also
  where you can pass various configurations (such as scoping, observers, ...)
- [Ref][]/[WidgetRef][], to read/listen to providers
- [ConsumerWidget][], [Consumer][], etc...
  Those are widgets to allow the UI to obtain a [WidgetRef][]
