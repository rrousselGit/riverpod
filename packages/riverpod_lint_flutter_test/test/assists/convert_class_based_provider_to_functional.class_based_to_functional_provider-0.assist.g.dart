// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_class_based_provider_to_functional.class_based_to_functional_provider-0.assist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Some comment

@ProviderFor(example)
final exampleProvider = ExampleProvider._();

/// Some comment

final class ExampleProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return example(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$exampleHash() => r'67898608b444d39a000852f647ca6d3326740c98';

/// Some comment

@ProviderFor(ExampleFamily)
final exampleFamilyProvider = ExampleFamilyFamily._();

/// Some comment
final class ExampleFamilyProvider
    extends $NotifierProvider<ExampleFamily, int> {
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
  ExampleFamily create() => ExampleFamily();

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

String _$exampleFamilyHash() => r'37d4a4fd66999562cd92051f91266270d5a1e5ea';

/// Some comment

final class ExampleFamilyFamily extends $Family
    with
        $ClassFamilyOverride<
          ExampleFamily,
          int,
          int,
          int,
          ({int a, String b})
        > {
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

/// Some comment

abstract class _$ExampleFamily extends $Notifier<int> {
  late final _$args = ref.$arg as ({int a, String b});
  int get a => _$args.a;
  String get b => _$args.b;

  int build({required int a, String b = '42'});
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
    element.handleCreate(ref, () => build(a: _$args.a, b: _$args.b));
  }
}

@ProviderFor(Generic)
final genericProvider = GenericFamily._();

final class GenericProvider<FirstT, SecondT>
    extends $NotifierProvider<Generic<FirstT, SecondT>, int> {
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
        '<${FirstT}, ${SecondT}>'
        '()';
  }

  @$internal
  @override
  Generic<FirstT, SecondT> create() => Generic<FirstT, SecondT>();

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
    return other is GenericProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$genericHash() => r'12e53af45495abae2504a8e9aed4ec354813c2ff';

final class GenericFamily extends $Family {
  GenericFamily._()
    : super(
        retry: null,
        name: r'genericProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GenericProvider<FirstT, SecondT> call<FirstT, SecondT>() =>
      GenericProvider<FirstT, SecondT>._(from: this);

  @override
  String toString() => r'genericProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Generic<FirstT, SecondT> Function<FirstT, SecondT>() create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as GenericProvider;
      return provider._captureGenerics(<FirstT, SecondT>() {
        provider as GenericProvider<FirstT, SecondT>;
        return provider
            .$view(create: create<FirstT, SecondT>)
            .$createElement(pointer);
      });
    },
  );

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function<FirstT, SecondT>(Ref ref, Generic<FirstT, SecondT> notifier)
    build,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as GenericProvider;
      return provider._captureGenerics(<FirstT, SecondT>() {
        provider as GenericProvider<FirstT, SecondT>;
        return provider
            .$view(runNotifierBuildOverride: build<FirstT, SecondT>)
            .$createElement(pointer);
      });
    },
  );
}

abstract class _$Generic<FirstT, SecondT> extends $Notifier<int> {
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
