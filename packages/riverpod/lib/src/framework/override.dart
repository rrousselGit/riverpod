part of '../framework.dart';

/// An object used by [ProviderContainer]/`ProviderScope` to override the behavior
/// of a provider/family for part of the application.
///
/// Do not extend or implement.
sealed class Override {
  @mustBeOverridden
  @override
  String toString();
}

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
sealed class ProviderOverride implements Override {
  factory ProviderOverride({
    required ProviderBase<Object?> origin,
    required ProviderBase<Object?> providerOverride,
  }) = _ProviderOverrideBase;
}

class _ProviderOverrideBase implements ProviderOverride {
  /// Override a provider
  _ProviderOverrideBase({
    required this.origin,
    required this.providerOverride,
  });

  /// The provider that is overridden.
  final ProviderBase<Object?> origin;

  /// The new provider behavior.
  final ProviderBase<Object?> providerOverride;
}

/// When a provider is automatically scoped due to specifying `dependencies`.
@internal
class TransitiveProviderOverride implements _ProviderOverrideBase {
  TransitiveProviderOverride(this.origin);

  @override
  final ProviderBase<Object?> origin;

  @override
  ProviderBase<Object?> get providerOverride => origin;
}

extension on ProviderOverride {
  /// The provider that is overridden.
  ProviderBase<Object?> get origin {
    final that = this;
    return switch (that) {
      ProviderBase() => that,
      _ProviderOverrideBase() => that.origin,
    };
  }

  /// The new provider behavior.
  ProviderBase<Object?> get providerOverride {
    final that = this;
    return switch (that) {
      ProviderBase() => that,
      _ProviderOverrideBase() => that.providerOverride,
    };
  }
}

/// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
/// to override the behavior of a "family" for part of the application.
@internal
abstract class FamilyOverride implements Override {
  /// The family that was overridden.
  // TODO make all fields private
  Family get from;

  /// Obtains the new behavior for a provider associated to the overridden family.
  @visibleForOverriding
  ProviderBase<Object?> getProviderOverride(ProviderBase<Object?> provider);
}

@internal
class TransitiveFamilyOverride implements FamilyOverride {
  TransitiveFamilyOverride(this.from);

  @override
  final Family from;

  @override
  ProviderBase<Object?> getProviderOverride(ProviderBase<Object?> provider) {
    return provider;
  }
}

/// An [Override] for families
@internal
class FamilyOverrideImpl<State, Arg, FamilyProvider extends ProviderBase<State>>
    implements FamilyOverride {
  /// An [Override] for families
  // ignore: library_private_types_in_public_api
  FamilyOverrideImpl(this.from, this._newCreate);

  final FamilyProvider Function(Arg arg) _newCreate;

  @override
  // ignore: library_private_types_in_public_api
  final _FamilyMixin<State, Arg, FamilyProvider> from;

  @visibleForOverriding
  @override
  ProviderBase<Object?> getProviderOverride(ProviderBase<Object?> provider) {
    final arg = provider.argument as Arg;
    return _newCreate(arg);
  }
}
