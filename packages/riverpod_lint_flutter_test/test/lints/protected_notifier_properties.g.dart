// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protected_notifier_properties.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(A)
const aProvider = AProvider._();

final class AProvider extends $NotifierProvider<A, int> {
  const AProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aHash();

  @$internal
  @override
  A create() => A();

  @$internal
  @override
  $NotifierProviderElement<A, int> $createElement($ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$aHash() => r'9bf449b010f4dd5800e78f9f5b8a431b1a79c8b7';

abstract class _$A extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(A2)
const a2Provider = A2Provider._();

final class A2Provider extends $NotifierProvider<A2, int> {
  const A2Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'a2Provider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$a2Hash();

  @$internal
  @override
  A2 create() => A2();

  @$internal
  @override
  $NotifierProviderElement<A2, int> $createElement($ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$a2Hash() => r'898d46cbcec03233c7b8b0754810a6903226aa2e';

abstract class _$A2 extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(A3)
const a3Provider = A3Family._();

final class A3Provider extends $NotifierProvider<A3, int> {
  const A3Provider._(
      {required A3Family super.from, required int super.argument})
      : super(
          retry: null,
          name: r'a3Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$a3Hash();

  @override
  String toString() {
    return r'a3Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  A3 create() => A3();

  @$internal
  @override
  $NotifierProviderElement<A3, int> $createElement($ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is A3Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$a3Hash() => r'2e21e9af8b67b5412611e0d23b862ead56deb8e1';

final class A3Family extends Family {
  const A3Family._()
      : super(
          retry: null,
          name: r'a3Provider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  A3Provider call(
    int param,
  ) =>
      A3Provider._(argument: param, from: this);

  @override
  String toString() => r'a3Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          A3 Function(
            int args,
          ) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as A3Provider;
            final argument = provider.argument as int;
            return provider
                .$view(create: () => create(argument))
                .$createElement(pointer);
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          int Function(Ref ref, A3 notifier, int argument) build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as A3Provider;
            final argument = provider.argument as int;
            return provider
                .$view(
                    runNotifierBuildOverride: (ref, notifier) =>
                        build(ref, notifier, argument))
                .$createElement(pointer);
          });
}

abstract class _$A3 extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  int build(
    int param,
  );
  @$internal
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(A4)
const a4Provider = A4Family._();

final class A4Provider extends $NotifierProvider<A4, int> {
  const A4Provider._(
      {required A4Family super.from, required int super.argument})
      : super(
          retry: null,
          name: r'a4Provider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$a4Hash();

  @override
  String toString() {
    return r'a4Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  A4 create() => A4();

  @$internal
  @override
  $NotifierProviderElement<A4, int> $createElement($ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is A4Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$a4Hash() => r'cdd9ad09099881cafe06d7b3095a8b06dbe7d876';

final class A4Family extends Family {
  const A4Family._()
      : super(
          retry: null,
          name: r'a4Provider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  A4Provider call(
    int param,
  ) =>
      A4Provider._(argument: param, from: this);

  @override
  String toString() => r'a4Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          A4 Function(
            int args,
          ) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as A4Provider;
            final argument = provider.argument as int;
            return provider
                .$view(create: () => create(argument))
                .$createElement(pointer);
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          int Function(Ref ref, A4 notifier, int argument) build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as A4Provider;
            final argument = provider.argument as int;
            return provider
                .$view(
                    runNotifierBuildOverride: (ref, notifier) =>
                        build(ref, notifier, argument))
                .$createElement(pointer);
          });
}

abstract class _$A4 extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  int build(
    int param,
  );
  @$internal
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(A5)
const a5Provider = A5Family._();

final class A5Provider extends $AsyncNotifierProvider<A5, int> {
  const A5Provider._(
      {required A5Family super.from, required int super.argument})
      : super(
          retry: null,
          name: r'a5Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$a5Hash();

  @override
  String toString() {
    return r'a5Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  A5 create() => A5();

  @$internal
  @override
  $AsyncNotifierProviderElement<A5, int> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is A5Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$a5Hash() => r'c83634c22b6a9149aa8787e45c3b7cd6c88b5958';

final class A5Family extends Family {
  const A5Family._()
      : super(
          retry: null,
          name: r'a5Provider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  A5Provider call(
    int param,
  ) =>
      A5Provider._(argument: param, from: this);

  @override
  String toString() => r'a5Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          A5 Function(
            int args,
          ) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as A5Provider;
            final argument = provider.argument as int;
            return provider
                .$view(create: () => create(argument))
                .$createElement(pointer);
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          FutureOr<int> Function(Ref ref, A5 notifier, int argument) build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as A5Provider;
            final argument = provider.argument as int;
            return provider
                .$view(
                    runNotifierBuildOverride: (ref, notifier) =>
                        build(ref, notifier, argument))
                .$createElement(pointer);
          });
}

abstract class _$A5 extends $AsyncNotifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  FutureOr<int> build(
    int param,
  );
  @$internal
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<int>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<AsyncValue<int>>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(A6)
const a6Provider = A6Family._();

final class A6Provider extends $AsyncNotifierProvider<A6, int> {
  const A6Provider._(
      {required A6Family super.from, required int super.argument})
      : super(
          retry: null,
          name: r'a6Provider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$a6Hash();

  @override
  String toString() {
    return r'a6Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  A6 create() => A6();

  @$internal
  @override
  $AsyncNotifierProviderElement<A6, int> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is A6Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$a6Hash() => r'fe641c72cacf3dd119eb77a34fe8fc71c5c30139';

final class A6Family extends Family {
  const A6Family._()
      : super(
          retry: null,
          name: r'a6Provider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  A6Provider call(
    int param,
  ) =>
      A6Provider._(argument: param, from: this);

  @override
  String toString() => r'a6Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          A6 Function(
            int args,
          ) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as A6Provider;
            final argument = provider.argument as int;
            return provider
                .$view(create: () => create(argument))
                .$createElement(pointer);
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          FutureOr<int> Function(Ref ref, A6 notifier, int argument) build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as A6Provider;
            final argument = provider.argument as int;
            return provider
                .$view(
                    runNotifierBuildOverride: (ref, notifier) =>
                        build(ref, notifier, argument))
                .$createElement(pointer);
          });
}

abstract class _$A6 extends $AsyncNotifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  FutureOr<int> build(
    int param,
  );
  @$internal
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<int>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<AsyncValue<int>>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(A7)
const a7Provider = A7Family._();

final class A7Provider extends $StreamNotifierProvider<A7, int> {
  const A7Provider._(
      {required A7Family super.from, required int super.argument})
      : super(
          retry: null,
          name: r'a7Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$a7Hash();

  @override
  String toString() {
    return r'a7Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  A7 create() => A7();

  @$internal
  @override
  $StreamNotifierProviderElement<A7, int> $createElement(
          $ProviderPointer pointer) =>
      $StreamNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is A7Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$a7Hash() => r'd3d9ab5090e21987d65522f14ebb70d0058fc56a';

final class A7Family extends Family {
  const A7Family._()
      : super(
          retry: null,
          name: r'a7Provider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  A7Provider call(
    int param,
  ) =>
      A7Provider._(argument: param, from: this);

  @override
  String toString() => r'a7Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          A7 Function(
            int args,
          ) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as A7Provider;
            final argument = provider.argument as int;
            return provider
                .$view(create: () => create(argument))
                .$createElement(pointer);
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          Stream<int> Function(Ref ref, A7 notifier, int argument) build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as A7Provider;
            final argument = provider.argument as int;
            return provider
                .$view(
                    runNotifierBuildOverride: (ref, notifier) =>
                        build(ref, notifier, argument))
                .$createElement(pointer);
          });
}

abstract class _$A7 extends $StreamNotifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  Stream<int> build(
    int param,
  );
  @$internal
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<int>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<AsyncValue<int>>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(A8)
const a8Provider = A8Family._();

final class A8Provider extends $StreamNotifierProvider<A8, int> {
  const A8Provider._(
      {required A8Family super.from, required int super.argument})
      : super(
          retry: null,
          name: r'a8Provider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$a8Hash();

  @override
  String toString() {
    return r'a8Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  A8 create() => A8();

  @$internal
  @override
  $StreamNotifierProviderElement<A8, int> $createElement(
          $ProviderPointer pointer) =>
      $StreamNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is A8Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$a8Hash() => r'54f4a841a283161bed3d444dcee53bf367958678';

final class A8Family extends Family {
  const A8Family._()
      : super(
          retry: null,
          name: r'a8Provider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  A8Provider call(
    int param,
  ) =>
      A8Provider._(argument: param, from: this);

  @override
  String toString() => r'a8Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          A8 Function(
            int args,
          ) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as A8Provider;
            final argument = provider.argument as int;
            return provider
                .$view(create: () => create(argument))
                .$createElement(pointer);
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          Stream<int> Function(Ref ref, A8 notifier, int argument) build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as A8Provider;
            final argument = provider.argument as int;
            return provider
                .$view(
                    runNotifierBuildOverride: (ref, notifier) =>
                        build(ref, notifier, argument))
                .$createElement(pointer);
          });
}

abstract class _$A8 extends $StreamNotifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  Stream<int> build(
    int param,
  );
  @$internal
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<int>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<AsyncValue<int>>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(B)
const bProvider = BProvider._();

final class BProvider extends $NotifierProvider<B, int> {
  const BProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'bProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$bHash();

  @$internal
  @override
  B create() => B();

  @$internal
  @override
  $NotifierProviderElement<B, int> $createElement($ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$bHash() => r'44288285e9c28f846d609ba892520f577ecf7867';

abstract class _$B extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(B2)
const b2Provider = B2Provider._();

final class B2Provider extends $NotifierProvider<B2, int> {
  const B2Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'b2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$b2Hash();

  @$internal
  @override
  B2 create() => B2();

  @$internal
  @override
  $NotifierProviderElement<B2, int> $createElement($ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$b2Hash() => r'292925c285c6975ed6585d541c5a9ae18977d73c';

abstract class _$B2 extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
