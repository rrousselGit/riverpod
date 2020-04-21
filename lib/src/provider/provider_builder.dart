part of 'provider.dart';

mixin _Noop {}

/// Combines multiple provider into a [Provider].
/// 
/// This is an optional work-around to a language limitation on type
/// inference.
/// 
/// It is used as such:
/// 
/// ```dart
/// final useSomething = Provider((_) => Something());
/// final useSomethingElse = Provider((_) => SomethingElse());
/// 
/// final useAnotherThing = ProviderBuilder<AnotherThing>()
///   .add(useSomething)
///   .add(useSomethingElse)
///   .build((state, something, somethingElse) {
///     return AnotherThing(
///       something: something.value,
///       somethingElse: somethingElse.value,
///     );
///   });
/// ```
/// 
/// which is strictly equivalent to:
/// 
/// ```dart
/// final useSomething = Provider((_) => Something());
/// final useSomethingElse = Provider((_) => SomethingElse());
/// 
/// final useAnotherThing = Provider2<Immutable<Something>, Immutable<SomethingElse, AnotherThing>(
///   useSomething,
///   useSomethingElse,
///   (state, something, somethingElse) {
///     return AnotherThing(
///       something: something.value,
///       somethingElse: somethingElse.value,
///     );
///   },
/// );
/// ```
/// 
/// Note that the `Immutable<...>` on the second snippet is because the
/// combined providers are [Provider]s.
/// Different kinds of provider may make use different wrapper objects.
class ProviderBuilder<Res> = Combiner<Res, Provider> with _Noop;

/// An implementation detail of [ProviderBuilder].
extension ProviderBuilder1X<A, Res> on Combiner1<A, Res, Provider> {
  Provider1<A, Res> build(Create1<A, Res, ProviderState<Res>> cb) {
    return Provider1(first, cb);
  }
}
