// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protected_notifier_properties.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(A)
const aProvider = AProvider._();

final class AProvider extends $NotifierProvider<A, int> {
  const AProvider._({super.runNotifierBuildOverride, A Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'aProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final A Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$aHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  A create() => _createCb?.call() ?? A();

  @$internal
  @override
  AProvider $copyWithCreate(
    A Function() create,
  ) {
    return AProvider._(create: create);
  }

  @$internal
  @override
  AProvider $copyWithBuild(
    int Function(
      Ref<int>,
      A,
    ) build,
  ) {
    return AProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<A, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$aHash() => r'9bf449b010f4dd5800e78f9f5b8a431b1a79c8b7';

abstract class _$A extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(A2)
const a2Provider = A2Provider._();

final class A2Provider extends $NotifierProvider<A2, int> {
  const A2Provider._({super.runNotifierBuildOverride, A2 Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'a2Provider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final A2 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$a2Hash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  A2 create() => _createCb?.call() ?? A2();

  @$internal
  @override
  A2Provider $copyWithCreate(
    A2 Function() create,
  ) {
    return A2Provider._(create: create);
  }

  @$internal
  @override
  A2Provider $copyWithBuild(
    int Function(
      Ref<int>,
      A2,
    ) build,
  ) {
    return A2Provider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<A2, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$a2Hash() => r'898d46cbcec03233c7b8b0754810a6903226aa2e';

abstract class _$A2 extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(A3)
const a3Provider = A3Family._();

final class A3Provider extends $NotifierProvider<A3, int> {
  const A3Provider._(
      {required A3Family super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      A3 Function()? create})
      : _createCb = create,
        super(
          name: r'a3Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final A3 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$a3Hash();

  @override
  String toString() {
    return r'a3Provider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  A3 create() => _createCb?.call() ?? A3();

  @$internal
  @override
  A3Provider $copyWithCreate(
    A3 Function() create,
  ) {
    return A3Provider._(
        argument: argument as int, from: from! as A3Family, create: create);
  }

  @$internal
  @override
  A3Provider $copyWithBuild(
    int Function(
      Ref<int>,
      A3,
    ) build,
  ) {
    return A3Provider._(
        argument: argument as int,
        from: from! as A3Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<A3, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

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
  String debugGetCreateSourceHash() => _$a3Hash();

  @override
  String toString() => r'a3Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    A3 Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as A3Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function(Ref<int> ref, A3 notifier, int argument) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as A3Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$A3 extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  int build(
    int param,
  );
  @$internal
  @override
  int runBuild() => build(
        _$args,
      );
}

@ProviderFor(A4)
const a4Provider = A4Family._();

final class A4Provider extends $NotifierProvider<A4, int> {
  const A4Provider._(
      {required A4Family super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      A4 Function()? create})
      : _createCb = create,
        super(
          name: r'a4Provider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final A4 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$a4Hash();

  @override
  String toString() {
    return r'a4Provider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  A4 create() => _createCb?.call() ?? A4();

  @$internal
  @override
  A4Provider $copyWithCreate(
    A4 Function() create,
  ) {
    return A4Provider._(
        argument: argument as int, from: from! as A4Family, create: create);
  }

  @$internal
  @override
  A4Provider $copyWithBuild(
    int Function(
      Ref<int>,
      A4,
    ) build,
  ) {
    return A4Provider._(
        argument: argument as int,
        from: from! as A4Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<A4, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

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
  String debugGetCreateSourceHash() => _$a4Hash();

  @override
  String toString() => r'a4Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    A4 Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as A4Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function(Ref<int> ref, A4 notifier, int argument) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as A4Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$A4 extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  int build(
    int param,
  );
  @$internal
  @override
  int runBuild() => build(
        _$args,
      );
}

@ProviderFor(A5)
const a5Provider = A5Family._();

final class A5Provider extends $AsyncNotifierProvider<A5, int> {
  const A5Provider._(
      {required A5Family super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      A5 Function()? create})
      : _createCb = create,
        super(
          name: r'a5Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final A5 Function()? _createCb;

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
  A5 create() => _createCb?.call() ?? A5();

  @$internal
  @override
  A5Provider $copyWithCreate(
    A5 Function() create,
  ) {
    return A5Provider._(
        argument: argument as int, from: from! as A5Family, create: create);
  }

  @$internal
  @override
  A5Provider $copyWithBuild(
    FutureOr<int> Function(
      Ref<AsyncValue<int>>,
      A5,
    ) build,
  ) {
    return A5Provider._(
        argument: argument as int,
        from: from! as A5Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<A5, int> $createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);

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
  String debugGetCreateSourceHash() => _$a5Hash();

  @override
  String toString() => r'a5Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    A5 Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as A5Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<int> Function(Ref<AsyncValue<int>> ref, A5 notifier, int argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as A5Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$A5 extends $AsyncNotifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  FutureOr<int> build(
    int param,
  );
  @$internal
  @override
  FutureOr<int> runBuild() => build(
        _$args,
      );
}

@ProviderFor(A6)
const a6Provider = A6Family._();

final class A6Provider extends $AsyncNotifierProvider<A6, int> {
  const A6Provider._(
      {required A6Family super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      A6 Function()? create})
      : _createCb = create,
        super(
          name: r'a6Provider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final A6 Function()? _createCb;

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
  A6 create() => _createCb?.call() ?? A6();

  @$internal
  @override
  A6Provider $copyWithCreate(
    A6 Function() create,
  ) {
    return A6Provider._(
        argument: argument as int, from: from! as A6Family, create: create);
  }

  @$internal
  @override
  A6Provider $copyWithBuild(
    FutureOr<int> Function(
      Ref<AsyncValue<int>>,
      A6,
    ) build,
  ) {
    return A6Provider._(
        argument: argument as int,
        from: from! as A6Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<A6, int> $createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);

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
  String debugGetCreateSourceHash() => _$a6Hash();

  @override
  String toString() => r'a6Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    A6 Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as A6Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<int> Function(Ref<AsyncValue<int>> ref, A6 notifier, int argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as A6Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$A6 extends $AsyncNotifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  FutureOr<int> build(
    int param,
  );
  @$internal
  @override
  FutureOr<int> runBuild() => build(
        _$args,
      );
}

@ProviderFor(A7)
const a7Provider = A7Family._();

final class A7Provider extends $StreamNotifierProvider<A7, int> {
  const A7Provider._(
      {required A7Family super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      A7 Function()? create})
      : _createCb = create,
        super(
          name: r'a7Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final A7 Function()? _createCb;

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
  A7 create() => _createCb?.call() ?? A7();

  @$internal
  @override
  A7Provider $copyWithCreate(
    A7 Function() create,
  ) {
    return A7Provider._(
        argument: argument as int, from: from! as A7Family, create: create);
  }

  @$internal
  @override
  A7Provider $copyWithBuild(
    Stream<int> Function(
      Ref<AsyncValue<int>>,
      A7,
    ) build,
  ) {
    return A7Provider._(
        argument: argument as int,
        from: from! as A7Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $StreamNotifierProviderElement<A7, int> $createElement(
          ProviderContainer container) =>
      $StreamNotifierProviderElement(this, container);

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
  String debugGetCreateSourceHash() => _$a7Hash();

  @override
  String toString() => r'a7Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    A7 Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as A7Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    Stream<int> Function(Ref<AsyncValue<int>> ref, A7 notifier, int argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as A7Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$A7 extends $StreamNotifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  Stream<int> build(
    int param,
  );
  @$internal
  @override
  Stream<int> runBuild() => build(
        _$args,
      );
}

@ProviderFor(A8)
const a8Provider = A8Family._();

final class A8Provider extends $StreamNotifierProvider<A8, int> {
  const A8Provider._(
      {required A8Family super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      A8 Function()? create})
      : _createCb = create,
        super(
          name: r'a8Provider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final A8 Function()? _createCb;

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
  A8 create() => _createCb?.call() ?? A8();

  @$internal
  @override
  A8Provider $copyWithCreate(
    A8 Function() create,
  ) {
    return A8Provider._(
        argument: argument as int, from: from! as A8Family, create: create);
  }

  @$internal
  @override
  A8Provider $copyWithBuild(
    Stream<int> Function(
      Ref<AsyncValue<int>>,
      A8,
    ) build,
  ) {
    return A8Provider._(
        argument: argument as int,
        from: from! as A8Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $StreamNotifierProviderElement<A8, int> $createElement(
          ProviderContainer container) =>
      $StreamNotifierProviderElement(this, container);

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
  String debugGetCreateSourceHash() => _$a8Hash();

  @override
  String toString() => r'a8Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    A8 Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as A8Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    Stream<int> Function(Ref<AsyncValue<int>> ref, A8 notifier, int argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as A8Provider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$A8 extends $StreamNotifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  Stream<int> build(
    int param,
  );
  @$internal
  @override
  Stream<int> runBuild() => build(
        _$args,
      );
}

@ProviderFor(B)
const bProvider = BProvider._();

final class BProvider extends $NotifierProvider<B, int> {
  const BProvider._({super.runNotifierBuildOverride, B Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'bProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final B Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$bHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  B create() => _createCb?.call() ?? B();

  @$internal
  @override
  BProvider $copyWithCreate(
    B Function() create,
  ) {
    return BProvider._(create: create);
  }

  @$internal
  @override
  BProvider $copyWithBuild(
    int Function(
      Ref<int>,
      B,
    ) build,
  ) {
    return BProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<B, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$bHash() => r'44288285e9c28f846d609ba892520f577ecf7867';

abstract class _$B extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(B2)
const b2Provider = B2Provider._();

final class B2Provider extends $NotifierProvider<B2, int> {
  const B2Provider._({super.runNotifierBuildOverride, B2 Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'b2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final B2 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$b2Hash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  B2 create() => _createCb?.call() ?? B2();

  @$internal
  @override
  B2Provider $copyWithCreate(
    B2 Function() create,
  ) {
    return B2Provider._(create: create);
  }

  @$internal
  @override
  B2Provider $copyWithBuild(
    int Function(
      Ref<int>,
      B2,
    ) build,
  ) {
    return B2Provider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<B2, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$b2Hash() => r'292925c285c6975ed6585d541c5a9ae18977d73c';

abstract class _$B2 extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
