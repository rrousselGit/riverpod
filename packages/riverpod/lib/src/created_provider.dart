import 'framework.dart';

import 'provider.dart';

/// {@template riverpod.createdprovider}
/// A provider that listens to the value created by another provider.
///
/// For example, when listening to a `FutureProvider<int>`, this exposes
/// the `Future<int>` instead of the typical `AsyncValue<int>`.
/// {@endtemplate}
class CreatedProvider<T> extends Provider<T> {
  /// {@macro riverpod.createdprovider}
  CreatedProvider(
    RootProvider<T, Object> provider, {
    String name,
  }) : super((ref) {
          ref.watch(provider);
          // ignore: invalid_use_of_visible_for_testing_member
          final targetElement = ref.container.readProviderElement(provider);

          return targetElement.state.createdValue;
        }, name: name);
}

/// {@macro riverpod.createdprovider}
class AutoDisposeCreatedProvider<T> extends AutoDisposeProvider<T> {
  /// {@macro riverpod.createdprovider}
  AutoDisposeCreatedProvider(
    RootProvider<T, Object> provider, {
    String name,
  }) : super((ref) {
          ref.watch(provider);
          // ignore: invalid_use_of_visible_for_testing_member
          final targetElement = ref.container.readProviderElement(provider);

          return targetElement.state.createdValue;
        }, name: name);
}
