// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier_extends.notifier_extends-0.fix.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyNotifier)
final myProvider = MyNotifierProvider._();

final class MyNotifierProvider extends $NotifierProvider<MyNotifier, int> {
  MyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myNotifierHash();

  @$internal
  @override
  MyNotifier create() => MyNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$myNotifierHash() => r'58f5439a3b1036ba7804f63a5a6ebe0114125039';

abstract class _$MyNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(_PrivateClass)
final _privateClassProvider = _PrivateClassProvider._();

final class _PrivateClassProvider
    extends $NotifierProvider<_PrivateClass, String> {
  _PrivateClassProvider._()
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
  String debugGetCreateSourceHash() => _$_privateClassHash();

  @$internal
  @override
  _PrivateClass create() => _PrivateClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$_privateClassHash() => r'ba68a29a609566bb8bc0792391f842762356e124';

abstract class _$PrivateClass extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(Generics)
final genericsProvider = GenericsFamily._();

final class GenericsProvider<FirstT extends num, SecondT>
    extends $NotifierProvider<Generics<FirstT, SecondT>, int> {
  GenericsProvider._({required GenericsFamily super.from})
    : super(
        argument: null,
        retry: null,
        name: r'genericsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genericsHash();

  @override
  String toString() {
    return r'genericsProvider'
        '<${FirstT}, ${SecondT}>'
        '()';
  }

  @$internal
  @override
  Generics<FirstT, SecondT> create() => Generics<FirstT, SecondT>();

  $R _captureGenerics<$R>($R Function<FirstT extends num, SecondT>() cb) {
    return cb<FirstT, SecondT>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
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

String _$genericsHash() => r'e4bcfbaacabd977958663110d60b35ee5d04bdb8';

final class GenericsFamily extends $Family {
  GenericsFamily._()
    : super(
        retry: null,
        name: r'genericsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GenericsProvider<FirstT, SecondT> call<FirstT extends num, SecondT>() =>
      GenericsProvider<FirstT, SecondT>._(from: this);

  @override
  String toString() => r'genericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Generics<FirstT, SecondT> Function<FirstT extends num, SecondT>() create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as GenericsProvider;
      return provider._captureGenerics(<FirstT extends num, SecondT>() {
        provider as GenericsProvider<FirstT, SecondT>;
        return provider
            .$view(create: create<FirstT, SecondT>)
            .$createElement(pointer);
      });
    },
  );

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function<FirstT extends num, SecondT>(
      Ref ref,
      Generics<FirstT, SecondT> notifier,
    )
    build,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as GenericsProvider;
      return provider._captureGenerics(<FirstT extends num, SecondT>() {
        provider as GenericsProvider<FirstT, SecondT>;
        return provider
            .$view(runNotifierBuildOverride: build<FirstT, SecondT>)
            .$createElement(pointer);
      });
    },
  );
}

abstract class _$Generics<FirstT extends num, SecondT> extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(NoGenerics)
final noGenericsProvider = NoGenericsFamily._();

final class NoGenericsProvider<FirstT extends num, SecondT>
    extends $NotifierProvider<NoGenerics<FirstT, SecondT>, int> {
  NoGenericsProvider._({required NoGenericsFamily super.from})
    : super(
        argument: null,
        retry: null,
        name: r'noGenericsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noGenericsHash();

  @override
  String toString() {
    return r'noGenericsProvider'
        '<${FirstT}, ${SecondT}>'
        '()';
  }

  @$internal
  @override
  NoGenerics<FirstT, SecondT> create() => NoGenerics<FirstT, SecondT>();

  $R _captureGenerics<$R>($R Function<FirstT extends num, SecondT>() cb) {
    return cb<FirstT, SecondT>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
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

String _$noGenericsHash() => r'967351ae04a89275ec4ff854dc315cbdec1d1803';

final class NoGenericsFamily extends $Family {
  NoGenericsFamily._()
    : super(
        retry: null,
        name: r'noGenericsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NoGenericsProvider<FirstT, SecondT> call<FirstT extends num, SecondT>() =>
      NoGenericsProvider<FirstT, SecondT>._(from: this);

  @override
  String toString() => r'noGenericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    NoGenerics<FirstT, SecondT> Function<FirstT extends num, SecondT>() create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as NoGenericsProvider;
      return provider._captureGenerics(<FirstT extends num, SecondT>() {
        provider as NoGenericsProvider<FirstT, SecondT>;
        return provider
            .$view(create: create<FirstT, SecondT>)
            .$createElement(pointer);
      });
    },
  );

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function<FirstT extends num, SecondT>(
      Ref ref,
      NoGenerics<FirstT, SecondT> notifier,
    )
    build,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as NoGenericsProvider;
      return provider._captureGenerics(<FirstT extends num, SecondT>() {
        provider as NoGenericsProvider<FirstT, SecondT>;
        return provider
            .$view(runNotifierBuildOverride: build<FirstT, SecondT>)
            .$createElement(pointer);
      });
    },
  );
}

abstract class _$NoGenerics<FirstT extends num, SecondT>
    extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(MissingGenerics)
final missingGenericsProvider = MissingGenericsFamily._();

final class MissingGenericsProvider<FirstT, SecondT>
    extends $NotifierProvider<MissingGenerics<FirstT, SecondT>, int> {
  MissingGenericsProvider._({required MissingGenericsFamily super.from})
    : super(
        argument: null,
        retry: null,
        name: r'missingGenericsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$missingGenericsHash();

  @override
  String toString() {
    return r'missingGenericsProvider'
        '<${FirstT}, ${SecondT}>'
        '()';
  }

  @$internal
  @override
  MissingGenerics<FirstT, SecondT> create() =>
      MissingGenerics<FirstT, SecondT>();

  $R _captureGenerics<$R>($R Function<FirstT, SecondT>() cb) {
    return cb<FirstT, SecondT>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
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

String _$missingGenericsHash() => r'b5a92c5f59289c48b5a52c36e07bc65698905738';

final class MissingGenericsFamily extends $Family {
  MissingGenericsFamily._()
    : super(
        retry: null,
        name: r'missingGenericsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MissingGenericsProvider<FirstT, SecondT> call<FirstT, SecondT>() =>
      MissingGenericsProvider<FirstT, SecondT>._(from: this);

  @override
  String toString() => r'missingGenericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    MissingGenerics<FirstT, SecondT> Function<FirstT, SecondT>() create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as MissingGenericsProvider;
      return provider._captureGenerics(<FirstT, SecondT>() {
        provider as MissingGenericsProvider<FirstT, SecondT>;
        return provider
            .$view(create: create<FirstT, SecondT>)
            .$createElement(pointer);
      });
    },
  );

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function<FirstT, SecondT>(
      Ref ref,
      MissingGenerics<FirstT, SecondT> notifier,
    )
    build,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as MissingGenericsProvider;
      return provider._captureGenerics(<FirstT, SecondT>() {
        provider as MissingGenericsProvider<FirstT, SecondT>;
        return provider
            .$view(runNotifierBuildOverride: build<FirstT, SecondT>)
            .$createElement(pointer);
      });
    },
  );
}

abstract class _$MissingGenerics<FirstT, SecondT> extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(WrongOrder)
final wrongOrderProvider = WrongOrderFamily._();

final class WrongOrderProvider<FirstT, SecondT>
    extends $NotifierProvider<WrongOrder<FirstT, SecondT>, int> {
  WrongOrderProvider._({required WrongOrderFamily super.from})
    : super(
        argument: null,
        retry: null,
        name: r'wrongOrderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wrongOrderHash();

  @override
  String toString() {
    return r'wrongOrderProvider'
        '<${FirstT}, ${SecondT}>'
        '()';
  }

  @$internal
  @override
  WrongOrder<FirstT, SecondT> create() => WrongOrder<FirstT, SecondT>();

  $R _captureGenerics<$R>($R Function<FirstT, SecondT>() cb) {
    return cb<FirstT, SecondT>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
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

String _$wrongOrderHash() => r'973b8e7d2e4ae6c15be96a924eb4715b7b7fd8b9';

final class WrongOrderFamily extends $Family {
  WrongOrderFamily._()
    : super(
        retry: null,
        name: r'wrongOrderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WrongOrderProvider<FirstT, SecondT> call<FirstT, SecondT>() =>
      WrongOrderProvider<FirstT, SecondT>._(from: this);

  @override
  String toString() => r'wrongOrderProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    WrongOrder<FirstT, SecondT> Function<FirstT, SecondT>() create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as WrongOrderProvider;
      return provider._captureGenerics(<FirstT, SecondT>() {
        provider as WrongOrderProvider<FirstT, SecondT>;
        return provider
            .$view(create: create<FirstT, SecondT>)
            .$createElement(pointer);
      });
    },
  );

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function<FirstT, SecondT>(Ref ref, WrongOrder<FirstT, SecondT> notifier)
    build,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as WrongOrderProvider;
      return provider._captureGenerics(<FirstT, SecondT>() {
        provider as WrongOrderProvider<FirstT, SecondT>;
        return provider
            .$view(runNotifierBuildOverride: build<FirstT, SecondT>)
            .$createElement(pointer);
      });
    },
  );
}

abstract class _$WrongOrder<FirstT, SecondT> extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
