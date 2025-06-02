part of '../framework.dart';

/// An object used by [ProviderContainer]/`ProviderScope` to override the behavior
/// of a provider/family for part of the application.
///
/// Do not extend or implement.
@publicInCodegen
@publicInMisc
sealed class Override {}

sealed class _ProviderOverride implements Override {}

extension on _ProviderOverride {
  /// The provider that is overridden.
  ProviderBase<Object?, Object?> get origin {
    final that = this;
    return switch (that) {
      ProviderBase() => that,
      $ProviderOverride() => that.origin,
    };
  }

  /// The new provider behavior.
  ProviderBase<Object?, Object?> get providerOverride {
    final that = this;
    return switch (that) {
      ProviderBase() => that,
      $ProviderOverride() => that.providerOverride,
    };
  }
}

sealed class _FamilyOverride implements Override {}

extension on _FamilyOverride {
  /// The provider that is overridden.
  Family get from {
    final that = this;
    return switch (that) {
      Family() => that,
      $FamilyOverride() => that.from,
    };
  }
}

/// An object used by [ProviderContainer] to override the behavior of a provider
/// for a part of the application.
///
/// Do not use.
///
/// See also:
///
/// - [ProviderContainer], which uses this object.
/// - `overrideWithValue`, which creates a [$ProviderOverride].
@publicInCodegen
class $ProviderOverride implements _ProviderOverride {
  /// Override a provider
  $ProviderOverride({
    required this.origin,
    required this.providerOverride,
  });

  /// The provider that is overridden.
  final ProviderBase<Object?, Object?> origin;

  /// The new provider behavior.
  final ProviderBase<Object?, Object?> providerOverride;

  @mustBeOverridden
  @override
  String toString() {
    switch (providerOverride) {
      case $ValueProvider(:final _value):
        return '$origin.overrideWithValue($_value)';
      default:
        return '$origin.overrideWith(...)';
    }
  }
}

/// When a provider is automatically scoped due to specifying `dependencies`.
@internal
class TransitiveProviderOverride implements $ProviderOverride {
  TransitiveProviderOverride(this.origin);

  @override
  final ProviderBase<Object?, Object?> origin;

  @override
  ProviderBase<Object?, Object?> get providerOverride => origin;

  @override
  String toString() => '$origin';
}

/// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
/// to override the behavior of a "family" for part of the application.
@internal
@publicInCodegen
abstract class $FamilyOverride implements _FamilyOverride {
  /// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
  /// to override the behavior of a "family" for part of the application.
  factory $FamilyOverride({
    required ProviderElement Function($ProviderPointer pointer) createElement,
    required Family from,
  }) = _FamilyOverrideImpl;

  /// The family that was overridden.
  Family get from;

  /// The overridden [ProviderBase.$createElement].
  ProviderElement createElement($ProviderPointer pointer);

  @mustBeOverridden
  @override
  String toString();
}

@internal
class TransitiveFamilyOverride implements $FamilyOverride {
  TransitiveFamilyOverride(this.from);

  @override
  final Family from;

  @override
  ProviderElement createElement($ProviderPointer pointer) {
    return pointer.origin.$createElement(pointer);
  }

  @override
  String toString() => '$from';
}

/// An [Override] for families
class _FamilyOverrideImpl implements $FamilyOverride {
  /// An [Override] for families
  // ignore: library_private_types_in_public_api
  _FamilyOverrideImpl({
    required ProviderElement Function($ProviderPointer pointer) createElement,
    required this.from,
  }) : _createElement = createElement;

  @override
  final Family from;

  final ProviderElement Function($ProviderPointer pointer) _createElement;

  @override
  ProviderElement createElement($ProviderPointer pointer) {
    return _createElement(pointer);
  }

  @mustBeOverridden
  @override
  String toString() => '$from.overrideWith(...)';
}
