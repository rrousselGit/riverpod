part of '../framework.dart';

typedef ScopedReader = T Function<T>(ProviderBase<Object, T> provider);

typedef ScopedCreate<T> = T Function(ScopedReader watch);

/// {@template riverpod.scopedprovider}
/// A provider that may behave differently for a specific part of the application.
///
/// A common use-case for [ScopedProvider] is to avoid having to pass the argument
/// of a [Provider.family] in the widget tree.
///
/// More specifically, we may have a `ListView` that wants to render of list of
/// products. But for both performance and simplicity, we do not want to pass
/// the product id/index to the item's constructor.
///
/// In that situation, we could use [ScopedProvider], in combination with `ProviderScope`,
/// to allow our items to access the id/index, without receiving it from its
/// constructor.
///
/// For this, we first need to define our [ScopedProvider] like any other provider:
///
/// ```dart
/// final currentProductIndex = ScopedProvider<int>((_) => throw UnimplementedError());
/// ```
///
/// **Note**:
/// We made our [ScopedProvider] throw by default, as our list items by design
/// requires an index to be specified.
/// Another possibility would be to return `null` and have the item handle the
/// `null` scenario.
///
/// Then, inside our `ListView`, we will use `ProviderScope` to override the
/// value exposed by [ScopedProvider]:
///
/// ```dart
/// ListView.builder(
///   itemBuilder: (context, index) {
///     return ProviderScope(
///       overrides: [
///         currentProductIndex.overrideWithValue(index),
///       ],
///       child: const ProductItem(),
///     );
///   }
/// )
/// ```
///
/// This code means that for the first item in our `ListView`, `currentProductIndex`
/// will return `0`; whereas for the second item, it will return `1`, ...
///
/// Finally, we can read the item index inside our `ProductItem`:
///
/// ```dart
/// class ProductItem extends HookWidget {
///   const ProductItem({Key key}): super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     final index = useProvider(currentProductIndex);
///     // do something with the index
///
///   }
/// }
/// ```
///
/// Now, our `ProductItem` was able to obtain the product index it is associated with.
/// The interesting aspect of such code is that `ProductItem` was
/// instantiated using the `const` keyword, but still renders dynamic content.
///
/// What this means is, even if `ListView` rebuilds, our `ProductItem` will
/// not rebuild unless what it uses changed.
/// {@endtemplate}
class ScopedProvider<Listened> extends ProviderBase<Listened, Listened> {
  /// {@macro riverpod.scopedprovider}
  ScopedProvider(
    ScopedCreate<Listened> create, {
    String name,
  }) : super(
          (ref) => create((ref as _ScopedProviderElement).watch),
          name,
        );

  @override
  _ScopedProviderElement<Listened> createElement() {
    return _ScopedProviderElement<Listened>(this);
  }

  @override
  _ScopedProviderState<Listened> createState() {
    return _ScopedProviderState<Listened>();
  }

  /// Overrides the behavior of a provider with a value.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithValue(Listened value) {
    return ProviderOverride(
      ValueProvider<Object, Listened>((ref) => value, value),
      this,
    );
  }

  /// Overrides a [ScopedProvider] with a different behavior
  ///
  ///
  Override overrideAs(ScopedCreate<Listened> create) {
    return ProviderOverride(
      ScopedProvider<Listened>(create),
      this,
    );
  }
}

class _ScopedProviderElement<T> extends AutoDisposeProviderElement<T, T> {
  _ScopedProviderElement(ScopedProvider<T> provider) : super(provider);

  @override
  void update(ProviderBase<T, T> newProvider) {
    super.update(newProvider);
    markMustRecomputeState();
  }
}

class _ScopedProviderState<T> extends ProviderStateBase<T, T> {
  @override
  void valueChanged({T previous}) {
    if (createdValue != exposedValue) {
      exposedValue = createdValue;
    }
  }
}
