part of '../framework.dart';

/// An object used by [ProviderContainer]/`ProviderScope` to override the behavior
/// of a provider/family for part of the application.
///
/// Do not extend or implement.
sealed class Override {}

sealed class _ProviderOverride implements Override {}

extension on _ProviderOverride {
  /// The provider that is overridden.
  ProviderBase<Object?> get origin {
    final that = this;
    return switch (that) {
      ProviderBase() => that,
      ProviderOverride() => that.origin,
    };
  }

  /// The new provider behavior.
  ProviderBase<Object?> get providerOverride {
    final that = this;
    return switch (that) {
      ProviderBase() => that,
      ProviderOverride() => that.providerOverride,
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
      FamilyOverride() => that.from,
    };
  }
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
class ProviderOverride implements _ProviderOverride {
  /// Override a provider
  ProviderOverride({
    required this.origin,
    required this.providerOverride,
  });

  /// The provider that is overridden.
  final ProviderBase<Object?> origin;

  /// The new provider behavior.
  final ProviderBase<Object?> providerOverride;

  @mustBeOverridden
  @override
  String toString() {
    return '$origin.overrideWith($providerOverride)';
  }
}

/// When a provider is automatically scoped due to specifying `dependencies`.
@internal
class TransitiveProviderOverride implements ProviderOverride {
  TransitiveProviderOverride(this.origin);

  @override
  final ProviderBase<Object?> origin;

  @override
  ProviderBase<Object?> get providerOverride => origin;
}

/// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
/// to override the behavior of a "family" for part of the application.
@internal
abstract class FamilyOverride implements _FamilyOverride {
  factory FamilyOverride({
    required ProviderElementBase<Object?> Function(
      ProviderContainer container,
      ProviderBase<Object?> provider,
    ) createElement,
    required Family from,
  }) = _FamilyOverrideImpl;

  /// The family that was overridden.
  // TODO make all fields private
  Family get from;

  /// The overridden [ProviderBase.createElement].
  ProviderElementBase<Object?> createElement(
    ProviderContainer container,
    ProviderBase<Object?> provider,
  );

  @mustBeOverridden
  @override
  String toString();
}

@internal
class TransitiveFamilyOverride implements FamilyOverride {
  TransitiveFamilyOverride(this.from);

  @override
  final Family from;

  @override
  ProviderElementBase<Object?> createElement(
    ProviderContainer container,
    ProviderBase<Object?> provider,
  ) {
    return provider.createElement(container);
  }
}

/// An [Override] for families
class _FamilyOverrideImpl implements FamilyOverride {
  /// An [Override] for families
  // ignore: library_private_types_in_public_api
  _FamilyOverrideImpl({
    required ProviderElementBase<Object?> Function(
      ProviderContainer container,
      ProviderBase<Object?> provider,
    ) createElement,
    required this.from,
  }) : _createElement = createElement;

  @override
  final Family from;

  final ProviderElementBase<Object?> Function(
    ProviderContainer container,
    ProviderBase<Object?> provider,
  ) _createElement;

  @override
  ProviderElementBase<Object?> createElement(
    ProviderContainer container,
    ProviderBase<Object?> provider,
  ) {
    return _createElement(container, provider);
  }
}
