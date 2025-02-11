// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A public generated provider.
@ProviderFor(public)
const publicProvider = PublicProvider._();

/// A public generated provider.
final class PublicProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  /// A public generated provider.
  const PublicProvider._(
      {String Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'publicProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$publicHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  PublicProvider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return PublicProvider._(create: create);
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? public;
    return _$cb(ref);
  }
}

String _$publicHash() => r'94bee36125844f9fe521363bb228632b9f3bfbc7';

/// A generated provider with a '$' in its name.
@ProviderFor(supports$inNames)
const supports$inNamesProvider = Supports$inNamesProvider._();

/// A generated provider with a '$' in its name.
final class Supports$inNamesProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  /// A generated provider with a '$' in its name.
  const Supports$inNamesProvider._(
      {String Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'supports$inNamesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$supports$inNamesHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  Supports$inNamesProvider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return Supports$inNamesProvider._(create: create);
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? supports$inNames;
    return _$cb(ref);
  }
}

String _$supports$inNamesHash() => r'a883450ddca90a227631fe54d1d9ae305bc558d9';

/// A generated family provider.
@ProviderFor(family)
const familyProvider = FamilyFamily._();

/// A generated family provider.
final class FamilyProvider extends $FunctionalProvider<String, String>
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
          super.argument,
      String Function(
        Ref ref,
        int first, {
        String? second,
        required double third,
        bool forth,
        List<String>? fifth,
      })? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
    int first, {
    String? second,
    required double third,
    bool forth,
    List<String>? fifth,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$familyHash();

  @override
  String toString() {
    return r'familyProvider'
        ''
        '$argument';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  FamilyProvider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return FamilyProvider._(
        argument: argument as (
          int, {
          String? second,
          double third,
          bool forth,
          List<String>? fifth,
        }),
        from: from! as FamilyFamily,
        create: (
          ref,
          int first, {
          String? second,
          required double third,
          bool forth = true,
          List<String>? fifth,
        }) =>
            create(ref));
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? family;
    final argument = this.argument as (
      int, {
      String? second,
      double third,
      bool forth,
      List<String>? fifth,
    });
    return _$cb(
      ref,
      argument.$1,
      second: argument.second,
      third: argument.third,
      forth: argument.forth,
      fifth: argument.fifth,
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
final class FamilyFamily extends Family {
  const FamilyFamily._()
      : super(
          retry: null,
          name: r'familyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
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
  String debugGetCreateSourceHash() => _$familyHash();

  @override
  String toString() => r'familyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    String Function(
      Ref ref,
      (
        int, {
        String? second,
        double third,
        bool forth,
        List<String>? fifth,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyProvider;

        final argument = provider.argument as (
          int, {
          String? second,
          double third,
          bool forth,
          List<String>? fifth,
        });

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(_private)
const _privateProvider = _PrivateProvider._();

final class _PrivateProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const _PrivateProvider._(
      {String Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'_privateProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$privateHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  _PrivateProvider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return _PrivateProvider._(create: create);
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? _private;
    return _$cb(ref);
  }
}

String _$privateHash() => r'4f7b825ffa8a674f01dc8453cb480060a6a7bf5f';

/// A generated public provider from a class
@ProviderFor(PublicClass)
const publicClassProvider = PublicClassProvider._();

/// A generated public provider from a class
final class PublicClassProvider extends $NotifierProvider<PublicClass, String> {
  /// A generated public provider from a class
  const PublicClassProvider._(
      {super.runNotifierBuildOverride, PublicClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'publicClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final PublicClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$publicClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  PublicClass create() => _createCb?.call() ?? PublicClass();

  @$internal
  @override
  PublicClassProvider $copyWithCreate(
    PublicClass Function() create,
  ) {
    return PublicClassProvider._(create: create);
  }

  @$internal
  @override
  PublicClassProvider $copyWithBuild(
    String Function(
      Ref,
      PublicClass,
    ) build,
  ) {
    return PublicClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<PublicClass, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$publicClassHash() => r'c27eae39f455b986e570abb84f1471de7445ef3b';

abstract class _$PublicClass extends $Notifier<String> {
  String build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String>;
    final element = ref.element as $ClassProviderElement<NotifierBase<String>,
        String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(_PrivateClass)
const _privateClassProvider = _PrivateClassProvider._();

final class _PrivateClassProvider
    extends $NotifierProvider<_PrivateClass, String> {
  const _PrivateClassProvider._(
      {super.runNotifierBuildOverride, _PrivateClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'_privateClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final _PrivateClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$privateClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  _PrivateClass create() => _createCb?.call() ?? _PrivateClass();

  @$internal
  @override
  _PrivateClassProvider $copyWithCreate(
    _PrivateClass Function() create,
  ) {
    return _PrivateClassProvider._(create: create);
  }

  @$internal
  @override
  _PrivateClassProvider $copyWithBuild(
    String Function(
      Ref,
      _PrivateClass,
    ) build,
  ) {
    return _PrivateClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<_PrivateClass, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$privateClassHash() => r'3b08af72c6d4f24aed264efcf181572525b75603';

abstract class _$PrivateClass extends $Notifier<String> {
  String build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String>;
    final element = ref.element as $ClassProviderElement<NotifierBase<String>,
        String, Object?, Object?>;
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
          super.argument,
      super.runNotifierBuildOverride,
      FamilyClass Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'familyClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FamilyClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$familyClassHash();

  @override
  String toString() {
    return r'familyClassProvider'
        ''
        '$argument';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  FamilyClass create() => _createCb?.call() ?? FamilyClass();

  @$internal
  @override
  FamilyClassProvider $copyWithCreate(
    FamilyClass Function() create,
  ) {
    return FamilyClassProvider._(
        argument: argument as (
          int, {
          String? second,
          double third,
          bool forth,
          List<String>? fifth,
        }),
        from: from! as FamilyClassFamily,
        create: create);
  }

  @$internal
  @override
  FamilyClassProvider $copyWithBuild(
    String Function(
      Ref,
      FamilyClass,
    ) build,
  ) {
    return FamilyClassProvider._(
        argument: argument as (
          int, {
          String? second,
          double third,
          bool forth,
          List<String>? fifth,
        }),
        from: from! as FamilyClassFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<FamilyClass, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

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
final class FamilyClassFamily extends Family {
  const FamilyClassFamily._()
      : super(
          retry: null,
          name: r'familyClassProvider',
          dependencies: null,
          allTransitiveDependencies: null,
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
  String debugGetCreateSourceHash() => _$familyClassHash();

  @override
  String toString() => r'familyClassProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    FamilyClass Function(
      (
        int, {
        String? second,
        double third,
        bool forth,
        List<String>? fifth,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyClassProvider;

        final argument = provider.argument as (
          int, {
          String? second,
          double third,
          bool forth,
          List<String>? fifth,
        });

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    String Function(
            Ref ref,
            FamilyClass notifier,
            (
              int, {
              String? second,
              double third,
              bool forth,
              List<String>? fifth,
            }) argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyClassProvider;

        final argument = provider.argument as (
          int, {
          String? second,
          double third,
          bool forth,
          List<String>? fifth,
        });

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
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
  @$internal
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      second: _$args.second,
      third: _$args.third,
      forth: _$args.forth,
      fifth: _$args.fifth,
    );
    final ref = this.ref as $Ref<String>;
    final element = ref.element as $ClassProviderElement<NotifierBase<String>,
        String, Object?, Object?>;
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
  const Supports$InClassNameProvider._(
      {super.runNotifierBuildOverride, Supports$InClassName Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'supports$InClassNameProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Supports$InClassName Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$supports$InClassNameHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  Supports$InClassName create() => _createCb?.call() ?? Supports$InClassName();

  @$internal
  @override
  Supports$InClassNameProvider $copyWithCreate(
    Supports$InClassName Function() create,
  ) {
    return Supports$InClassNameProvider._(create: create);
  }

  @$internal
  @override
  Supports$InClassNameProvider $copyWithBuild(
    String Function(
      Ref,
      Supports$InClassName,
    ) build,
  ) {
    return Supports$InClassNameProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Supports$InClassName, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$supports$InClassNameHash() =>
    r'dd23b01994664e5a2c22ba3a61f3b23d2128861b';

abstract class _$Supports$InClassName extends $Notifier<String> {
  String build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String>;
    final element = ref.element as $ClassProviderElement<NotifierBase<String>,
        String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
