// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A public generated provider.
@ProviderFor(public)
const publicProvider = PublicProvider._();

/// A public generated provider.
final class PublicProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// A public generated provider.
  const PublicProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'publicProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$publicHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return public(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$publicHash() => r'94bee36125844f9fe521363bb228632b9f3bfbc7';

/// A generated provider with a '$' in its name.
@ProviderFor(supports$inNames)
const supports$inNamesProvider = Supports$inNamesProvider._();

/// A generated provider with a '$' in its name.
final class Supports$inNamesProvider
    extends $FunctionalProvider<String, String, String> with $Provider<String> {
  /// A generated provider with a '$' in its name.
  const Supports$inNamesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'supports$inNamesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$supports$inNamesHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return supports$inNames(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$supports$inNamesHash() => r'a883450ddca90a227631fe54d1d9ae305bc558d9';

/// A generated family provider.
@ProviderFor(family)
const familyProvider = FamilyFamily._();

/// A generated family provider.
final class FamilyProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// A generated family provider.
  const FamilyProvider._(
      {required FamilyFamily super.from,
      required (
        int, {
        String? second,
        double third,
        bool forth,
        List<String>? fifth,
      })
          super.argument})
      : super(
          retry: null,
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$familyHash();

  @override
  String toString() {
    return r'familyProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as (
      int, {
      String? second,
      double third,
      bool forth,
      List<String>? fifth,
    });
    return family(
      ref,
      argument.$1,
      second: argument.second,
      third: argument.third,
      forth: argument.forth,
      fifth: argument.fifth,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyHash() => r'062561e0cad8585939dc9adc23de6452be2c9788';

/// A generated family provider.
final class FamilyFamily extends $Family
    with
        $FunctionalFamilyOverride<
            String,
            (
              int, {
              String? second,
              double third,
              bool forth,
              List<String>? fifth,
            })> {
  const FamilyFamily._()
      : super(
          retry: null,
          name: r'familyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// A generated family provider.
  FamilyProvider call(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  }) =>
      FamilyProvider._(argument: (
        first,
        second: second,
        third: third,
        forth: forth,
        fifth: fifth,
      ), from: this);

  @override
  String toString() => r'familyProvider';
}

@ProviderFor(_private)
const _privateProvider = _PrivateProvider._();

final class _PrivateProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const _PrivateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_privateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$privateHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return _private(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$privateHash() => r'4f7b825ffa8a674f01dc8453cb480060a6a7bf5f';

/// A generated public provider from a class
@ProviderFor(PublicClass)
const publicClassProvider = PublicClassProvider._();

/// A generated public provider from a class
final class PublicClassProvider extends $NotifierProvider<PublicClass, String> {
  /// A generated public provider from a class
  const PublicClassProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'publicClassProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$publicClassHash();

  @$internal
  @override
  PublicClass create() => PublicClass();

  @$internal
  @override
  $NotifierProviderElement<PublicClass, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$publicClassHash() => r'c27eae39f455b986e570abb84f1471de7445ef3b';

abstract class _$PublicClass extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(_PrivateClass)
const _privateClassProvider = _PrivateClassProvider._();

final class _PrivateClassProvider
    extends $NotifierProvider<_PrivateClass, String> {
  const _PrivateClassProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_privateClassProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$privateClassHash();

  @$internal
  @override
  _PrivateClass create() => _PrivateClass();

  @$internal
  @override
  $NotifierProviderElement<_PrivateClass, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$privateClassHash() => r'3b08af72c6d4f24aed264efcf181572525b75603';

abstract class _$PrivateClass extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// A generated family provider from a class.
@ProviderFor(FamilyClass)
const familyClassProvider = FamilyClassFamily._();

/// A generated family provider from a class.
final class FamilyClassProvider extends $NotifierProvider<FamilyClass, String> {
  /// A generated family provider from a class.
  const FamilyClassProvider._(
      {required FamilyClassFamily super.from,
      required (
        int, {
        String? second,
        double third,
        bool forth,
        List<String>? fifth,
      })
          super.argument})
      : super(
          retry: null,
          name: r'familyClassProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$familyClassHash();

  @override
  String toString() {
    return r'familyClassProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  FamilyClass create() => FamilyClass();

  @$internal
  @override
  $NotifierProviderElement<FamilyClass, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyClassProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyClassHash() => r'721bdd2f1ca0d7cee1a0ae476d7bfe93f9ce6875';

/// A generated family provider from a class.
final class FamilyClassFamily extends $Family
    with
        $ClassFamilyOverride<
            FamilyClass,
            String,
            String,
            String,
            (
              int, {
              String? second,
              double third,
              bool forth,
              List<String>? fifth,
            })> {
  const FamilyClassFamily._()
      : super(
          retry: null,
          name: r'familyClassProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// A generated family provider from a class.
  FamilyClassProvider call(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  }) =>
      FamilyClassProvider._(argument: (
        first,
        second: second,
        third: third,
        forth: forth,
        fifth: fifth,
      ), from: this);

  @override
  String toString() => r'familyClassProvider';
}

abstract class _$FamilyClass extends $Notifier<String> {
  late final _$args = ref.$arg as (
    int, {
    String? second,
    double third,
    bool forth,
    List<String>? fifth,
  });
  int get first => _$args.$1;
  String? get second => _$args.second;
  double get third => _$args.third;
  bool get forth => _$args.forth;
  List<String>? get fifth => _$args.fifth;

  String build(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      second: _$args.second,
      third: _$args.third,
      forth: _$args.forth,
      fifth: _$args.fifth,
    );
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// A generated provider from a class with a '$' in its name.
@ProviderFor(Supports$InClassName)
const supports$InClassNameProvider = Supports$InClassNameProvider._();

/// A generated provider from a class with a '$' in its name.
final class Supports$InClassNameProvider
    extends $NotifierProvider<Supports$InClassName, String> {
  /// A generated provider from a class with a '$' in its name.
  const Supports$InClassNameProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'supports$InClassNameProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$supports$InClassNameHash();

  @$internal
  @override
  Supports$InClassName create() => Supports$InClassName();

  @$internal
  @override
  $NotifierProviderElement<Supports$InClassName, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$supports$InClassNameHash() =>
    r'dd23b01994664e5a2c22ba3a61f3b23d2128861b';

abstract class _$Supports$InClassName extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
