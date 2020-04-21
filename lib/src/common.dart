import 'package:meta/meta.dart';

import 'future_provider/future_provider.dart';
import 'provider/provider.dart';

/// A placeholder used by [Provider]/[ProviderX] and [FutureProvider].
///
/// It has no purpose other than working around language limitations on generic
/// parameters through extension methods.
/// See https://github.com/dart-lang/language/issues/620
class ImmutableValue<T> {
  const ImmutableValue(this.value);

  @visibleForTesting
  final T value;
}
