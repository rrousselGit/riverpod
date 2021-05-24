part of '../framework.dart';

/// A function that can both read a [ScopedProvider], normal providers and a `myProvider.select(..)`
typedef ScopedReader = T Function<T>(ProviderBase<T> provider);

/// The function that [ScopedProvider]s uses to create their state.
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
/// class ProductItem extends ConsumerWidget {
///   const ProductItem({Key? key}): super(key: key);
///
///   @override
///   Widget build(BuildContext context, WidgetReference ref) {
///     final index = ref.watch(currentProductIndex);
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
///
/// # ScopedProvider with no default behavior
///
/// A common use-case with ScopedProvider is to _not_ provide a default behavior,
/// and instead always override the provider inside a `ProviderScope`.
///
/// In this situation, what we can do is pass `null` instead of a function
/// to ScopedProvider:
///
/// ```dart
/// final example = ScopedProvider<int>(null);
/// ```
///
/// This is equivalent to:
///
/// ```dart
/// final example = ScopedProvider<int>((watch) => throw UnsupportedError('<some error message>'));
/// ```
/// {@endtemplate}
@sealed
class ScopedProvider<State> extends ProviderBase<State> {
  /// {@macro riverpod.scopedprovider}
  ScopedProvider(
    this._create, {
    String? name,
  }) : super(
          name,
        );

  final State Function(ScopedReader watch)? _create;

  @override
  State create(
    covariant _ScopedProviderElement<State> ref,
  ) {
    if (_create == null) {
      throw UnsupportedError(
        'No default behavior specified for ScopedProvider<$State>',
      );
    }

    return _create!(ref.watch);
  }

  @override
  bool recreateShouldNotify(State previousState, State newState) {
    return previousState != newState;
  }

  @override
  _ScopedProviderElement<State> createElement() {
    return _ScopedProviderElement<State>(this);
  }

  /// Overrides the behavior of a provider with a value.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithValue(State value) {
    return ProviderOverride(
      ValueProvider<State>((ref) => value, value),
      this,
    );
  }

  /// Overrides a [ScopedProvider] with a different behavior
  ///
  ///
  Override overrideAs(ScopedCreate<State> create) {
    return ProviderOverride(
      ScopedProvider<State>(create),
      this,
    );
  }
}

@sealed
class _ScopedProviderElement<T> extends AutoDisposeProviderElementBase<T> {
  _ScopedProviderElement(ScopedProvider<T> provider) : super(provider);

  @override
  void update(ProviderBase<T> newProvider) {
    super.update(newProvider);
    // TODO(rrousselGit) compare previous and new state
    // markMustRecomputeState();
  }
}
