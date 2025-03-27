part of '../framework.dart';

/// An object used by [ProviderContainer]/`ProviderScope` to override the behavior
/// of a provider/family for part of the application.
///
/// Do not extend or implement.
abstract class Override {}

/// An implementation detail for the override mechanism of providers
@internal
typedef SetupOverride = void Function({
  required ProviderBase<Object?> origin,
  required ProviderBase<Object?> override,
});

/// An object used by [ProviderContainer] to override the behavior of a provider
/// for a part of the application.
///
/// Do not implement/extend this class.
///
/// See also:
///
/// - [ProviderContainer], which uses this object.
/// - `overrideWithValue`, which creates a [ProviderOverride].
@internal
class ProviderOverride implements Override {
  /// Override a provider
  ProviderOverride({
    required ProviderBase<Object?> origin,
    required ProviderBase<Object?> override,
  })  : _origin = origin,
        _override = override;

  /// The provider that is overridden.
  final ProviderBase<Object?> _origin;

  /// The new provider behavior.
  final ProviderBase<Object?> _override;
}

/// Setup how a family is overridden
@internal
typedef SetupFamilyOverride<Arg> = void Function(
  Arg argument,
  void Function({
    required ProviderBase<Object?> origin,
    required ProviderBase<Object?> override,
  }),
);

/// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
/// to override the behavior of a "family" for part of the application.
@internal
abstract class FamilyOverride<@Deprecated('Will be removed in 3.0.0') State>
    implements Override {
  /// The family that was overridden.
  // ignore: deprecated_member_use_from_same_package
  Family<State> get overriddenFamily;

  /// Obtains the new behavior for a provider associated to the overridden family.
  @visibleForOverriding
  // ignore: deprecated_member_use_from_same_package
  ProviderBase<State> getProviderOverride(ProviderBase<State> provider);
}

/// An [Override] for families
@internal
class FamilyOverrideImpl<State, Arg, FamilyProvider extends ProviderBase<State>>
    implements FamilyOverride<State> {
  /// An [Override] for families
  // ignore: library_private_types_in_public_api
  FamilyOverrideImpl(this.overriddenFamily, this._newCreate);

  final FamilyProvider Function(Arg arg) _newCreate;

  @override
  // ignore: library_private_types_in_public_api
  final _FamilyMixin<State, Arg, FamilyProvider> overriddenFamily;

  @visibleForOverriding
  @override
  ProviderBase<State> getProviderOverride(ProviderBase<State> provider) {
    final arg = provider.argument as Arg;
    return _newCreate(arg);
  }
}
