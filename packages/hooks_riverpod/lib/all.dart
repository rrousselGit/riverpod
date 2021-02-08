/// Exports all the implementation classes of providers, such as `Provider` vs `AutoDisposeProvider`.
///
/// This is useful if you want to use the `always_specify_types` lint. Otherwise,
/// import `package:hooks_riverpod/riverpod.dart` instead, to avoid polluting the auto-complete.
@Deprecated('use `hooks_riverpod/hooks_riverpod.dart` instead')
library all;

export 'package:flutter_riverpod/flutter_riverpod.dart';

export 'hooks_riverpod.dart';
