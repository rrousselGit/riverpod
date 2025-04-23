/// {@template riverpod_annotation.dependencies}
/// An annotation to be specified on non-provider objects that use scoped providers.
///
/// This is equivalent to `@Riverpod(dependencies: [])`, but for non-provider objects.
/// This is most commonly used on `Consumer`s, but can be used on anything,
/// including functions.
///
/// The sole purpose of this annotation is to notify the linter
/// that an object uses a scoped provider.
/// It then enables the linter to warn in case this object is used in a place
/// where the scoped provider is not overridden.
///
/// ## Usage example:
///
/// Consider the following scoped provider:
/// ```dart
/// @Riverpod(dependencies: [])
/// String selectedBookID(Ref ref)  => throw UnimplementedError();
/// ```
///
/// Since this provider is scoped, we should specify `@Dependencies` on any object
/// that uses it.
/// For instance, a `Consumer`:
///
/// ```dart
/// @Dependencies([selectedBookID])
/// class BookView extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final selectedBookID = ref.watch(selectedBookIDProvider);
///     return Text(selectedBookID);
///   }
/// }
/// ```
///
/// By doing so, using `BooKView` now requires either:
/// - overriding `selectedBookIDProvider` in a `ProviderScope` that is an ancestor
///   of `BookView`:
///   ```dart
///   ProviderScope(
///     overrides: [
///       selectedBookIDProvider.overrideWithValue('myBookID'),
///     ],
///     child: BookView(),
///   ),
///   ```
/// - or using `BookView` in a widget that also specifies `@Dependencies([selectedBookID])`:
///   ```dart
///   @Dependencies([selectedBookID])
///   class MyWidget extends StatelessWidget {
///     @override
///     Widget build(BuildContext context) {
///       return BookView();
///     }
///   }
///   ```
///
/// Failing to do so will result in a linter warning.
///
/// **Note**: When using a `StatefulWidget` (or variant),
/// there is no need to specify `@Dependencies` on the `State` class.
/// Specifying it on the `StatefulWidget` is enough.
/// {@endtemplate}
class Dependencies {
  /// {@macro riverpod_annotation.dependencies}
  const Dependencies(this.dependencies);

  /// {@macro riverpod_annotation.dependencies}
  final List<Object> dependencies;
}
