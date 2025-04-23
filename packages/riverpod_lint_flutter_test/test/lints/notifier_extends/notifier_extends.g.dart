// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier_extends.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(MyNotifier)
const myNotifierProvider = MyNotifierProvider._();

final class MyNotifierProvider extends $NotifierProvider<MyNotifier, int> {
  const MyNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myNotifierHash();

  @$internal
  @override
  MyNotifier create() => MyNotifier();

  @$internal
  @override
  $NotifierProviderElement<MyNotifier, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$myNotifierHash() => r'58f5439a3b1036ba7804f63a5a6ebe0114125039';

abstract class _$MyNotifier extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
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
          allTransitiveDependencies: null,
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
      providerOverride: $ValueProvider<String>(value),
    );
  }
}

String _$privateClassHash() => r'ba68a29a609566bb8bc0792391f842762356e124';

abstract class _$PrivateClass extends $Notifier<String> {
  String build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Generics)
const genericsProvider = GenericsFamily._();

final class GenericsProvider<A extends num, B>
    extends $NotifierProvider<Generics<A, B>, int> {
  const GenericsProvider._({required GenericsFamily super.from})
      : super(
          argument: null,
          retry: null,
          name: r'genericsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$genericsHash();

  @override
  String toString() {
    return r'genericsProvider'
        '<${A}, ${B}>'
        '()';
  }

  @$internal
  @override
  Generics<A, B> create() => Generics<A, B>();

  @$internal
  @override
  $NotifierProviderElement<Generics<A, B>, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  $R _captureGenerics<$R>($R Function<A extends num, B>() cb) {
    return cb<A, B>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenericsProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$genericsHash() => r'0a1bf00e0610ccb1fb5615460e1bc4afb2555f69';

final class GenericsFamily extends Family {
  const GenericsFamily._()
      : super(
          retry: null,
          name: r'genericsProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GenericsProvider<A, B> call<A extends num, B>() =>
      GenericsProvider<A, B>._(from: this);

  @override
  String toString() => r'genericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(Generics<A, B> Function<A extends num, B>() create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericsProvider;
            return provider._captureGenerics(<A extends num, B>() {
              provider as GenericsProvider<A, B>;
              return provider
                  .$view(create: create<A, B>)
                  .$createElement(pointer);
            });
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          int Function<A extends num, B>(Ref ref, Generics<A, B> notifier)
              build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericsProvider;
            return provider._captureGenerics(<A extends num, B>() {
              provider as GenericsProvider<A, B>;
              return provider
                  .$view(runNotifierBuildOverride: build<A, B>)
                  .$createElement(pointer);
            });
          });
}

abstract class _$Generics<A extends num, B> extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(NoGenerics)
const noGenericsProvider = NoGenericsFamily._();

final class NoGenericsProvider<A extends num, B>
    extends $NotifierProvider<NoGenerics<A, B>, int> {
  const NoGenericsProvider._({required NoGenericsFamily super.from})
      : super(
          argument: null,
          retry: null,
          name: r'noGenericsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$noGenericsHash();

  @override
  String toString() {
    return r'noGenericsProvider'
        '<${A}, ${B}>'
        '()';
  }

  @$internal
  @override
  NoGenerics<A, B> create() => NoGenerics<A, B>();

  @$internal
  @override
  $NotifierProviderElement<NoGenerics<A, B>, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  $R _captureGenerics<$R>($R Function<A extends num, B>() cb) {
    return cb<A, B>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NoGenericsProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$noGenericsHash() => r'30d5d20092f43cb17ede1f619773757df7cecb30';

final class NoGenericsFamily extends Family {
  const NoGenericsFamily._()
      : super(
          retry: null,
          name: r'noGenericsProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  NoGenericsProvider<A, B> call<A extends num, B>() =>
      NoGenericsProvider<A, B>._(from: this);

  @override
  String toString() => r'noGenericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(NoGenerics<A, B> Function<A extends num, B>() create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as NoGenericsProvider;
            return provider._captureGenerics(<A extends num, B>() {
              provider as NoGenericsProvider<A, B>;
              return provider
                  .$view(create: create<A, B>)
                  .$createElement(pointer);
            });
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          int Function<A extends num, B>(Ref ref, NoGenerics<A, B> notifier)
              build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as NoGenericsProvider;
            return provider._captureGenerics(<A extends num, B>() {
              provider as NoGenericsProvider<A, B>;
              return provider
                  .$view(runNotifierBuildOverride: build<A, B>)
                  .$createElement(pointer);
            });
          });
}

abstract class _$NoGenerics<A extends num, B> extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MissingGenerics)
const missingGenericsProvider = MissingGenericsFamily._();

final class MissingGenericsProvider<A, B>
    extends $NotifierProvider<MissingGenerics<A, B>, int> {
  const MissingGenericsProvider._({required MissingGenericsFamily super.from})
      : super(
          argument: null,
          retry: null,
          name: r'missingGenericsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$missingGenericsHash();

  @override
  String toString() {
    return r'missingGenericsProvider'
        '<${A}, ${B}>'
        '()';
  }

  @$internal
  @override
  MissingGenerics<A, B> create() => MissingGenerics<A, B>();

  @$internal
  @override
  $NotifierProviderElement<MissingGenerics<A, B>, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  $R _captureGenerics<$R>($R Function<A, B>() cb) {
    return cb<A, B>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MissingGenericsProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$missingGenericsHash() => r'b611c76d5fb87fdde78b5fc017912e0569762c23';

final class MissingGenericsFamily extends Family {
  const MissingGenericsFamily._()
      : super(
          retry: null,
          name: r'missingGenericsProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  MissingGenericsProvider<A, B> call<A, B>() =>
      MissingGenericsProvider<A, B>._(from: this);

  @override
  String toString() => r'missingGenericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(MissingGenerics<A, B> Function<A, B>() create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as MissingGenericsProvider;
            return provider._captureGenerics(<A, B>() {
              provider as MissingGenericsProvider<A, B>;
              return provider
                  .$view(create: create<A, B>)
                  .$createElement(pointer);
            });
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          int Function<A, B>(Ref ref, MissingGenerics<A, B> notifier) build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as MissingGenericsProvider;
            return provider._captureGenerics(<A, B>() {
              provider as MissingGenericsProvider<A, B>;
              return provider
                  .$view(runNotifierBuildOverride: build<A, B>)
                  .$createElement(pointer);
            });
          });
}

abstract class _$MissingGenerics<A, B> extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(WrongOrder)
const wrongOrderProvider = WrongOrderFamily._();

final class WrongOrderProvider<A, B>
    extends $NotifierProvider<WrongOrder<A, B>, int> {
  const WrongOrderProvider._({required WrongOrderFamily super.from})
      : super(
          argument: null,
          retry: null,
          name: r'wrongOrderProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$wrongOrderHash();

  @override
  String toString() {
    return r'wrongOrderProvider'
        '<${A}, ${B}>'
        '()';
  }

  @$internal
  @override
  WrongOrder<A, B> create() => WrongOrder<A, B>();

  @$internal
  @override
  $NotifierProviderElement<WrongOrder<A, B>, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  $R _captureGenerics<$R>($R Function<A, B>() cb) {
    return cb<A, B>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WrongOrderProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$wrongOrderHash() => r'7757670a2f67406ebc96c87edf088deb9cb248a1';

final class WrongOrderFamily extends Family {
  const WrongOrderFamily._()
      : super(
          retry: null,
          name: r'wrongOrderProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  WrongOrderProvider<A, B> call<A, B>() =>
      WrongOrderProvider<A, B>._(from: this);

  @override
  String toString() => r'wrongOrderProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(WrongOrder<A, B> Function<A, B>() create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as WrongOrderProvider;
            return provider._captureGenerics(<A, B>() {
              provider as WrongOrderProvider<A, B>;
              return provider
                  .$view(create: create<A, B>)
                  .$createElement(pointer);
            });
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          int Function<A, B>(Ref ref, WrongOrder<A, B> notifier) build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as WrongOrderProvider;
            return provider._captureGenerics(<A, B>() {
              provider as WrongOrderProvider<A, B>;
              return provider
                  .$view(runNotifierBuildOverride: build<A, B>)
                  .$createElement(pointer);
            });
          });
}

abstract class _$WrongOrder<A, B> extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
