// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'same_name_types.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(functional)
final functionalProvider = FunctionalFamily._();

final class FunctionalProvider
    extends $FunctionalProvider<b.Model, b.Model, b.Model>
    with $Provider<b.Model> {
  FunctionalProvider._({
    required FunctionalFamily super.from,
    required (b.Model, {a.Model? other}) super.argument,
  }) : super(
         retry: null,
         name: r'functionalProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$functionalHash();

  @override
  String toString() {
    return r'functionalProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<b.Model> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  b.Model create(Ref ref) {
    final argument = this.argument as (b.Model, {a.Model? other});
    return functional(ref, argument.$1, other: argument.other);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(b.Model value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<b.Model>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FunctionalProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$functionalHash() => r'472f309dd4d52434eb5c79fb446960dc4442768e';

final class FunctionalFamily extends $Family
    with $FunctionalFamilyOverride<b.Model, (b.Model, {a.Model? other})> {
  FunctionalFamily._()
    : super(
        retry: null,
        name: r'functionalProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FunctionalProvider call(b.Model model, {a.Model? other}) =>
      FunctionalProvider._(argument: (model, other: other), from: this);

  @override
  String toString() => r'functionalProvider';
}

@ProviderFor(generic)
final genericProvider = GenericFamily._();

final class GenericProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<b.Model>>,
          List<b.Model>,
          FutureOr<List<b.Model>>
        >
    with $FutureModifier<List<b.Model>>, $FutureProvider<List<b.Model>> {
  GenericProvider._({
    required GenericFamily super.from,
    required Map<a.Model, b.Model> super.argument,
  }) : super(
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
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<b.Model>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<b.Model>> create(Ref ref) {
    final argument = this.argument as Map<a.Model, b.Model>;
    return generic(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GenericProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$genericHash() => r'5324504d4fb4eb9e73bb49a92681da24716394df';

final class GenericFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<b.Model>>,
          Map<a.Model, b.Model>
        > {
  GenericFamily._()
    : super(
        retry: null,
        name: r'genericProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GenericProvider call(Map<a.Model, b.Model> models) =>
      GenericProvider._(argument: models, from: this);

  @override
  String toString() => r'genericProvider';
}

@ProviderFor(unprefixed)
final unprefixedProvider = UnprefixedFamily._();

final class UnprefixedProvider
    extends $FunctionalProvider<a.Model, a.Model, a.Model>
    with $Provider<a.Model> {
  UnprefixedProvider._({
    required UnprefixedFamily super.from,
    required a.Model super.argument,
  }) : super(
         retry: null,
         name: r'unprefixedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unprefixedHash();

  @override
  String toString() {
    return r'unprefixedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<a.Model> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  a.Model create(Ref ref) {
    final argument = this.argument as a.Model;
    return unprefixed(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(a.Model value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<a.Model>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UnprefixedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unprefixedHash() => r'3e0f9f56f4d927be6a208986e87b3c79e2212ebe';

final class UnprefixedFamily extends $Family
    with $FunctionalFamilyOverride<a.Model, a.Model> {
  UnprefixedFamily._()
    : super(
        retry: null,
        name: r'unprefixedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UnprefixedProvider call(a.Model model) =>
      UnprefixedProvider._(argument: model, from: this);

  @override
  String toString() => r'unprefixedProvider';
}

@ProviderFor(ClassBased)
final classBasedProvider = ClassBasedFamily._();

final class ClassBasedProvider extends $NotifierProvider<ClassBased, a.Model> {
  ClassBasedProvider._({
    required ClassBasedFamily super.from,
    required (a.Model, {b.Model other}) super.argument,
  }) : super(
         retry: null,
         name: r'classBasedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$classBasedHash();

  @override
  String toString() {
    return r'classBasedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ClassBased create() => ClassBased();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(a.Model value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<a.Model>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClassBasedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$classBasedHash() => r'6345de46b5bbbb45bd945407b424cc4207e2251f';

final class ClassBasedFamily extends $Family
    with
        $ClassFamilyOverride<
          ClassBased,
          a.Model,
          a.Model,
          a.Model,
          (a.Model, {b.Model other})
        > {
  ClassBasedFamily._()
    : super(
        retry: null,
        name: r'classBasedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClassBasedProvider call(a.Model model, {required b.Model other}) =>
      ClassBasedProvider._(argument: (model, other: other), from: this);

  @override
  String toString() => r'classBasedProvider';
}

abstract class _$ClassBased extends $Notifier<a.Model> {
  late final _$args = ref.$arg as (a.Model, {b.Model other});
  a.Model get model => _$args.$1;
  b.Model get other => _$args.other;

  a.Model build(a.Model model, {required b.Model other});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<a.Model, a.Model>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<a.Model, a.Model>,
              a.Model,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(_$args.$1, other: _$args.other),
    );
  }
}
