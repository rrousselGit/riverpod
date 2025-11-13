// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assist4.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Some comment

@ProviderFor(Example)
final exampleProvider = ExampleProvider._();

/// Some comment
final class ExampleProvider extends $NotifierProvider<Example, int> {
  /// Some comment
  ExampleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exampleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @$internal
  @override
  Example create() => Example();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$exampleHash() => r'081776126bafed3e1583bba9c1fadef798215ad7';

/// Some comment

abstract class _$Example extends $Notifier<int> {
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

/// Some comment

@ProviderFor(exampleFamily)
final exampleFamilyProvider = ExampleFamilyFamily._();

/// Some comment

final class ExampleFamilyProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Some comment
  ExampleFamilyProvider._({
    required ExampleFamilyFamily super.from,
    required ({int a, String b}) super.argument,
  }) : super(
         retry: null,
         name: r'exampleFamilyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exampleFamilyHash();

  @override
  String toString() {
    return r'exampleFamilyProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as ({int a, String b});
    return exampleFamily(ref, a: argument.a, b: argument.b);
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
    return other is ExampleFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exampleFamilyHash() => r'70dfc6f4b2d7d251edbc3a66c3ac0f2c56aebf8b';

/// Some comment

final class ExampleFamilyFamily extends $Family
    with $FunctionalFamilyOverride<int, ({int a, String b})> {
  ExampleFamilyFamily._()
    : super(
        retry: null,
        name: r'exampleFamilyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Some comment

  ExampleFamilyProvider call({required int a, String b = '42'}) =>
      ExampleFamilyProvider._(argument: (a: a, b: b), from: this);

  @override
  String toString() => r'exampleFamilyProvider';
}

@ProviderFor(Generic)
final genericProvider = GenericFamily._();

final class GenericProvider<A, B>
    extends $NotifierProvider<Generic<A, B>, int> {
  GenericProvider._({required GenericFamily super.from})
    : super(
        argument: null,
        retry: null,
        name: r'genericProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genericHash();

  @override
  String toString() {
    return r'genericProvider'
        '<${A}, ${B}>'
        '()';
  }

  @$internal
  @override
  Generic<A, B> create() => Generic<A, B>();

  $R _captureGenerics<$R>($R Function<A, B>() cb) {
    return cb<A, B>();
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
    return other is GenericProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$genericHash() => r'0a3792d7b59723aebd92715eef2c74d2f267cbd2';

final class GenericFamily extends $Family {
  GenericFamily._()
    : super(
        retry: null,
        name: r'genericProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GenericProvider<A, B> call<A, B>() => GenericProvider<A, B>._(from: this);

  @override
  String toString() => r'genericProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(Generic<A, B> Function<A, B>() create) =>
      $FamilyOverride(
        from: this,
        createElement: (pointer) {
          final provider = pointer.origin as GenericProvider;
          return provider._captureGenerics(<A, B>() {
            provider as GenericProvider<A, B>;
            return provider.$view(create: create<A, B>).$createElement(pointer);
          });
        },
      );

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function<A, B>(Ref ref, Generic<A, B> notifier) build,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as GenericProvider;
      return provider._captureGenerics(<A, B>() {
        provider as GenericProvider<A, B>;
        return provider
            .$view(runNotifierBuildOverride: build<A, B>)
            .$createElement(pointer);
      });
    },
  );
}

abstract class _$Generic<A, B> extends $Notifier<int> {
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
