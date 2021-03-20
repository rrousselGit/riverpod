import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'framework.dart';
import 'internals.dart';

/// Adds `context.read`
extension BuildContextX on BuildContext {
  /// Reads a provider without listening to it.
  ///
  /// **AVOID** calling [read] inside build if the value is used only for events:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   // counter is used only for the onPressed of RaisedButton
  ///   final counter = context.read(counterProvider);
  ///
  ///   return RaisedButton(
  ///     onPressed: () => counter.increment(),
  ///   );
  /// }
  /// ```
  ///
  /// While this code is not bugged in itself, this is an anti-pattern.
  /// It could easily lead to bugs in the future after refactoring the widget
  /// to use `counter` for other things, but forget to change [read] into [Consumer]/`useProvider`.
  ///
  /// **CONSIDER** calling [read] inside event handlers:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return RaisedButton(
  ///     onPressed: () {
  ///       // as performant as the previous solution, but resilient to refactoring
  ///       context.read(counterProvider).increment(),
  ///     },
  ///   );
  /// }
  /// ```
  ///
  /// This has the same efficiency as the previous anti-pattern, but does not
  /// suffer from the drawback of being brittle.
  ///
  /// **AVOID** using [read] for creating widgets with a value that never changes
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   // using read because we only use a value that never changes.
  ///   final model = context.read(modelProvider);
  ///
  ///   return Text('${model.valueThatNeverChanges}');
  /// }
  /// ```
  ///
  /// While the idea of not rebuilding the widget if unnecessary is good,
  /// this should not be done with [read].
  /// Relying on [read] for optimisations is very brittle and dependent
  /// on an implementation detail.
  ///
  /// **CONSIDER** using [Provider] or `select` for filtering unwanted rebuilds:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   // Using select to listen only to the value that used
  ///   final valueThatNeverChanges = useProvider(modelProvider.select((model) {
  ///     return model.valueThatNeverChanges;
  ///   }));
  ///
  ///   return Text('$valueThatNeverChanges');
  /// }
  /// ```
  ///
  /// While more verbose than [read], using [Provider]/`select` is a lot safer.
  /// It does not rely on implementation details on `Model`, and it makes
  /// impossible to have a bug where our UI does not refresh.
  T read<T>(ProviderBase<Object?, T> provider) {
    return ProviderScope.containerOf(this, listen: false).read(provider);
  }

  /// Forces a provider to re-evaluate its state immediately, and return the created value.
  ///
  /// This method is useful for features like "pull to refresh" or "retry on error",
  /// to restart a specific provider.
  ///
  /// For example, a pull-to-refresh may be implemented by combining
  /// [FutureProvider] and a [RefreshIndicator]:
  ///
  /// ```dart
  /// final productsProvider = FutureProvider((ref) async {
  ///   final response = await httpClient.get('https://host.com/products');
  ///   return Products.fromJson(response.data);
  /// });
  ///
  /// class Example extends ConsumerWidget {
  ///   @override
  ///   Widget build(BuildContext context, ScopedReader watch) {
  ///     final Products products = watch(productsProvider);
  ///
  ///     return RefreshIndicator(
  ///       onRefresh: () => context.refresh(productsProvider),
  ///       child: ListView(
  ///         children: [
  ///           for (final product in products.items) ProductItem(product: product),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  Created refresh<Created>(RootProvider<Created, Object> provider) {
    return ProviderScope.containerOf(this, listen: false).refresh(provider);
  }
}
