/// Exports all the implementation classes of providers, such as `Provider` vs `AutoDisposeProvider`.
///
/// This is useful if you want to use the `always_specify_types` lint. Otherwise,
/// import `package:riverpod/riverpod.dart` instead, to avoid polluting the auto-complete.
@Deprecated('use `riverpod/riverpod.dart` instead')
library all;

export 'riverpod.dart';
