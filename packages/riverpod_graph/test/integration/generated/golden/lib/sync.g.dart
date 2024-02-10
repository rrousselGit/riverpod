// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A public generated provider.
typedef PublicRef = Ref<String>;

/// A public generated provider.
@ProviderFor(public)
const publicProvider = PublicProvider._();

/// A public generated provider.
final class PublicProvider
    extends $FunctionalProvider<String, String, PublicRef>
    with $Provider<String, PublicRef> {
  /// A public generated provider.
  const PublicProvider._(
      {String Function(
        PublicRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'publicProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    PublicRef ref,
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  PublicProvider $copyWithCreate(
    String Function(
      PublicRef ref,
    ) create,
  ) {
    return PublicProvider._(create: create);
  }

  @override
  String create(PublicRef ref) {
    final _$cb = _createCb ?? public;
    return _$cb(ref);
  }
}

String _$publicHash() => r'138be35943899793ab085e711fe3f3d22696a3ba';

/// A generated provider with a '$' in its name.
typedef Supports$inNamesRef = Ref<String>;

/// A generated provider with a '$' in its name.
@ProviderFor(supports$inNames)
const supports$inNamesProvider = Supports$inNamesProvider._();

/// A generated provider with a '$' in its name.
final class Supports$inNamesProvider
    extends $FunctionalProvider<String, String, Supports$inNamesRef>
    with $Provider<String, Supports$inNamesRef> {
  /// A generated provider with a '$' in its name.
  const Supports$inNamesProvider._(
      {String Function(
        Supports$inNamesRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'supports$inNamesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Supports$inNamesRef ref,
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  Supports$inNamesProvider $copyWithCreate(
    String Function(
      Supports$inNamesRef ref,
    ) create,
  ) {
    return Supports$inNamesProvider._(create: create);
  }

  @override
  String create(Supports$inNamesRef ref) {
    final _$cb = _createCb ?? supports$inNames;
    return _$cb(ref);
  }
}

String _$supports$inNamesHash() => r'baacdb7b92917860b02aba1fa7010c7056da4a67';

/// A generated family provider.
typedef FamilyRef = Ref<String>;

/// A generated family provider.
@ProviderFor(family)
const familyProvider = FamilyFamily._();

/// A generated family provider.
final class FamilyProvider
    extends $FunctionalProvider<String, String, FamilyRef>
    with $Provider<String, FamilyRef> {
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
        FamilyRef ref,
        int first, {
        String? second,
        required double third,
        bool forth,
        List<String>? fifth,
      })? create})
      : _createCb = create,
        super(
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    FamilyRef ref,
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  FamilyProvider $copyWithCreate(
    String Function(
      FamilyRef ref,
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
  String create(FamilyRef ref) {
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

String _$familyHash() => r'ebf082969854dcc358b9870a2e5e9b922423e59b';

/// A generated family provider.
final class FamilyFamily extends Family {
  const FamilyFamily._()
      : super(
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
      FamilyRef ref,
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
      createElement: (container, provider) {
        provider as FamilyProvider;

        final argument = provider.argument as (
          int, {
          String? second,
          double third,
          bool forth,
          List<String>? fifth,
        });

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .createElement(container);
      },
    );
  }
}

typedef _PrivateRef = Ref<String>;

@ProviderFor(_private)
const _privateProvider = _PrivateProvider._();

final class _PrivateProvider
    extends $FunctionalProvider<String, String, _PrivateRef>
    with $Provider<String, _PrivateRef> {
  const _PrivateProvider._(
      {String Function(
        _PrivateRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'_privateProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    _PrivateRef ref,
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  _PrivateProvider $copyWithCreate(
    String Function(
      _PrivateRef ref,
    ) create,
  ) {
    return _PrivateProvider._(create: create);
  }

  @override
  String create(_PrivateRef ref) {
    final _$cb = _createCb ?? _private;
    return _$cb(ref);
  }
}

String _$privateHash() => r'9a87ed0765ad8448525fa1290b34760c79e7402b';

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
      Ref<String>,
      PublicClass,
    ) build,
  ) {
    return PublicClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<PublicClass, String> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$publicClassHash() => r'c27eae39f455b986e570abb84f1471de7445ef3b';

abstract class _$PublicClass extends $Notifier<String> {
  String build();
  @$internal
  @override
  String runBuild() => build();
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
      Ref<String>,
      _PrivateClass,
    ) build,
  ) {
    return _PrivateClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<_PrivateClass, String> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$privateClassHash() => r'3b08af72c6d4f24aed264efcf181572525b75603';

abstract class _$PrivateClass extends $Notifier<String> {
  String build();
  @$internal
  @override
  String runBuild() => build();
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
      Ref<String>,
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
  $NotifierProviderElement<FamilyClass, String> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

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
      createElement: (container, provider) {
        provider as FamilyClassProvider;

        final argument = provider.argument as (
          int, {
          String? second,
          double third,
          bool forth,
          List<String>? fifth,
        });

        return provider
            .$copyWithCreate(() => create(argument))
            .createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    String Function(
            Ref<String> ref,
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
      createElement: (container, provider) {
        provider as FamilyClassProvider;

        final argument = provider.argument as (
          int, {
          String? second,
          double third,
          bool forth,
          List<String>? fifth,
        });

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .createElement(container);
      },
    );
  }
}

abstract class _$FamilyClass extends $Notifier<String> {
  late final _$args = (ref as $NotifierProviderElement).origin.argument as (
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
  String runBuild() => build(
        _$args.$1,
        second: _$args.second,
        third: _$args.third,
        forth: _$args.forth,
        fifth: _$args.fifth,
      );
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
      Ref<String>,
      Supports$InClassName,
    ) build,
  ) {
    return Supports$InClassNameProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Supports$InClassName, String> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$supports$InClassNameHash() =>
    r'dd23b01994664e5a2c22ba3a61f3b23d2128861b';

abstract class _$Supports$InClassName extends $Notifier<String> {
  String build();
  @$internal
  @override
  String runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
