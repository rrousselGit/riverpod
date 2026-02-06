// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_class_based_provider_to_functional.class_based_to_functional_provider-2.assist.dart';

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

@ProviderFor(generic)
final genericProvider = GenericFamily._();

final class GenericProvider<FirstT, SecondT>
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return generic<FirstT, SecondT>(ref);
  }

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

String _$genericHash() => r'e9a2abb8b6762a93383a1367db765fd9e2aad1a7';

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
  Override overrideWith(int Function<FirstT, SecondT>(Ref ref) create) =>
      $FamilyOverride(
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
}
