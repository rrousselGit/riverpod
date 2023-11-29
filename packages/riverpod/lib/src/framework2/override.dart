part of 'framework.dart';

@immutable
sealed class Override {
  const Override({required this.origin});

  @internal
  final Provider<Object?> origin;
}

@internal
final class OverrideWithValue<StateT> extends Override {
  const OverrideWithValue(this.value, {required super.origin});

  @internal
  final StateT value;
}

@internal
abstract class OverrideWithCreate<StateT> extends Override {
  const OverrideWithCreate({required super.origin});

  @internal
  StateT create(ProviderElement<StateT> ref);
}
