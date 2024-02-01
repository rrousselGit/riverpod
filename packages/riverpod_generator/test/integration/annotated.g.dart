// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotated.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$functionalHash() => r'69e260b1de8ba28cbeb8e24d628933366cde6b8b';

/// See also [functional].
@ProviderFor(functional)
@Deprecated('Deprecation message')
@visibleForTesting
@protected
final functionalProvider = Provider<String>.internal(
  functional,
  name: r'functionalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$functionalHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FunctionalRef = Ref<String>;
String _$familyHash() => r'd70685b83be840bfd9e79c11fb84c905d19d6e10';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [family].
@ProviderFor(family)
@Deprecated('Deprecation message')
@visibleForTesting
@protected
const familyProvider = FamilyFamily();

/// See also [family].
final class FamilyFamily extends Family {
  /// See also [family].
  const FamilyFamily()
      : super(
          name: r'familyProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [family].
  FamilyProvider call(
    int id,
  ) {
    return FamilyProvider(
      id,
    );
  }

  @override
  String toString() => 'familyProvider';
}

/// See also [family].
final class FamilyProvider extends Provider<String> {
  /// See also [family].
  FamilyProvider(
    int id,
  ) : this._internal(
          (ref) => family(
            ref as FamilyRef,
            id,
          ),
          argument: (id,),
        );

  FamilyProvider._internal(
    super.create, {
    required (int,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$familyHash,
          from: familyProvider,
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _FamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _FamilyProviderElement(this, container);
  }

  @internal
  @override
  FamilyProvider copyWithCreate(
    String Function(FamilyRef ref) create,
  ) {
    return FamilyProvider._internal(
      (ref) => create(ref as FamilyRef),
      argument: argument as (int,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'familyProvider$argument';
}

mixin FamilyRef on Ref<String> {
  /// The parameter `id` of this provider.
  int get id;
}

class _FamilyProviderElement extends ProviderElement<String> with FamilyRef {
  _FamilyProviderElement(super.provider, super.container);

  @override
  int get id => (origin as FamilyProvider).id;
}

String _$notCopiedFunctionalHash() =>
    r'30587ee9ceb75d5c8562015ad4a67ec0b107c1f6';

/// See also [notCopiedFunctional].
@ProviderFor(notCopiedFunctional)
final notCopiedFunctionalProvider = Provider<String>.internal(
  notCopiedFunctional,
  name: r'notCopiedFunctionalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notCopiedFunctionalHash,
  from: null,
  argument: null,
  isAutoDispose: true,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotCopiedFunctionalRef = Ref<String>;
String _$notCopiedFamilyHash() => r'6ef06ce6ebd73b476870bbe1af41c4f3fbe8ddb1';

/// See also [notCopiedFamily].
@ProviderFor(notCopiedFamily)
const notCopiedFamilyProvider = NotCopiedFamilyFamily();

/// See also [notCopiedFamily].
final class NotCopiedFamilyFamily extends Family {
  /// See also [notCopiedFamily].
  const NotCopiedFamilyFamily()
      : super(
          name: r'notCopiedFamilyProvider',
          dependencies: _dependencies,
          allTransitiveDependencies: _allTransitiveDependencies,
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notCopiedFamilyHash,
          isAutoDispose: true,
        );

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  /// See also [notCopiedFamily].
  NotCopiedFamilyProvider call(
    int id,
  ) {
    return NotCopiedFamilyProvider(
      id,
    );
  }

  @override
  String toString() => 'notCopiedFamilyProvider';
}

/// See also [notCopiedFamily].
final class NotCopiedFamilyProvider extends Provider<String> {
  /// See also [notCopiedFamily].
  NotCopiedFamilyProvider(
    int id,
  ) : this._internal(
          (ref) => notCopiedFamily(
            ref as NotCopiedFamilyRef,
            id,
          ),
          argument: (id,),
        );

  NotCopiedFamilyProvider._internal(
    super.create, {
    required (int,) super.argument,
  }) : super.internal(
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notCopiedFamilyHash,
          from: notCopiedFamilyProvider,
          name: r'notCopiedFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  _NotCopiedFamilyProviderElement createElement(
    ProviderContainer container,
  ) {
    return _NotCopiedFamilyProviderElement(this, container);
  }

  @internal
  @override
  NotCopiedFamilyProvider copyWithCreate(
    String Function(NotCopiedFamilyRef ref) create,
  ) {
    return NotCopiedFamilyProvider._internal(
      (ref) => create(ref as NotCopiedFamilyRef),
      argument: argument as (int,),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NotCopiedFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode => Object.hash(argument, runtimeType);

  @override
  String toString() => 'notCopiedFamilyProvider$argument';
}

mixin NotCopiedFamilyRef on Ref<String> {
  /// The parameter `id` of this provider.
  int get id;
}

class _NotCopiedFamilyProviderElement extends ProviderElement<String>
    with NotCopiedFamilyRef {
  _NotCopiedFamilyProviderElement(super.provider, super.container);

  @override
  int get id => (origin as NotCopiedFamilyProvider).id;
}

String _$classBasedHash() => r'f40d1a032ee264aafd7686a985cdf1937f2dc108';

/// See also [ClassBased].
@ProviderFor(ClassBased)
@Deprecated('Deprecation message')
@visibleForTesting
@protected
final classBasedProvider = NotifierProvider<ClassBased, String>.internal(
  ClassBased.new,
  name: r'classBasedProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$classBasedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ClassBased = Notifier<String>;
String _$notCopiedClassBasedHash() =>
    r'd2aefd08a78e3bb4c02000d4931a3bf15c01b495';

/// See also [NotCopiedClassBased].
@ProviderFor(NotCopiedClassBased)
final notCopiedClassBasedProvider =
    NotifierProvider<NotCopiedClassBased, String>.internal(
  NotCopiedClassBased.new,
  name: r'notCopiedClassBasedProvider',
  from: null,
  argument: null,
  isAutoDispose: true,
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notCopiedClassBasedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotCopiedClassBased = Notifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
