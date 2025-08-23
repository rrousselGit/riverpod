// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(functional)
const functionalProvider = FunctionalFamily._();

final class FunctionalProvider
    extends $FunctionalProvider<(int,), (int,), (int,)> with $Provider<(int,)> {
  const FunctionalProvider._(
      {required FunctionalFamily super.from, required (String,) super.argument})
      : super(
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
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<(int,)> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  (int,) create(Ref ref) {
    final argument = this.argument as (String,);
    return functional(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((int,) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(int,)>(value),
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

String _$functionalHash() => r'01ea47cfc83f18c7ca3e2043a52ad62e033c6f83';

final class FunctionalFamily extends $Family
    with $FunctionalFamilyOverride<(int,), (String,)> {
  const FunctionalFamily._()
      : super(
          retry: null,
          name: r'functionalProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FunctionalProvider call(
    (String,) arg,
  ) =>
      FunctionalProvider._(argument: arg, from: this);

  @override
  String toString() => r'functionalProvider';
}

@ProviderFor(Class)
const classProvider = ClassFamily._();

final class ClassProvider extends $NotifierProvider<Class, (String,)> {
  const ClassProvider._(
      {required ClassFamily super.from, required (String,) super.argument})
      : super(
          retry: null,
          name: r'classProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$classHash();

  @override
  String toString() {
    return r'classProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Class create() => Class();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((String,) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(String,)>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClassProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$classHash() => r'a5d0c8e9f1a0e7bb342a9c37877022f2cfcaa540';

final class ClassFamily extends $Family
    with
        $ClassFamilyOverride<Class, (String,), (String,), (String,),
            (String,)> {
  const ClassFamily._()
      : super(
          retry: null,
          name: r'classProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ClassProvider call(
    (String,) arg,
  ) =>
      ClassProvider._(argument: arg, from: this);

  @override
  String toString() => r'classProvider';
}

abstract class _$Class extends $Notifier<(String,)> {
  late final _$args = ref.$arg as (String,);
  (String,) get arg => _$args;

  (String,) build(
    (String,) arg,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<(String,), (String,)>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<(String,), (String,)>, (String,), Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(functionalAsync)
const functionalAsyncProvider = FunctionalAsyncFamily._();

final class FunctionalAsyncProvider
    extends $FunctionalProvider<AsyncValue<(int,)>, (int,), FutureOr<(int,)>>
    with $FutureModifier<(int,)>, $FutureProvider<(int,)> {
  const FunctionalAsyncProvider._(
      {required FunctionalAsyncFamily super.from,
      required (String,) super.argument})
      : super(
          retry: null,
          name: r'functionalAsyncProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$functionalAsyncHash();

  @override
  String toString() {
    return r'functionalAsyncProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<(int,)> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<(int,)> create(Ref ref) {
    final argument = this.argument as (String,);
    return functionalAsync(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FunctionalAsyncProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$functionalAsyncHash() => r'c72d5e6353ef133c853d61197c22c6965c890b17';

final class FunctionalAsyncFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<(int,)>, (String,)> {
  const FunctionalAsyncFamily._()
      : super(
          retry: null,
          name: r'functionalAsyncProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FunctionalAsyncProvider call(
    (String,) arg,
  ) =>
      FunctionalAsyncProvider._(argument: arg, from: this);

  @override
  String toString() => r'functionalAsyncProvider';
}

@ProviderFor(ClassAsync)
const classAsyncProvider = ClassAsyncFamily._();

final class ClassAsyncProvider
    extends $AsyncNotifierProvider<ClassAsync, (String,)> {
  const ClassAsyncProvider._(
      {required ClassAsyncFamily super.from, required (String,) super.argument})
      : super(
          retry: null,
          name: r'classAsyncProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$classAsyncHash();

  @override
  String toString() {
    return r'classAsyncProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClassAsync create() => ClassAsync();

  @override
  bool operator ==(Object other) {
    return other is ClassAsyncProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$classAsyncHash() => r'1393285270bcc6cf7f5352ceb632bb5e30b6bafd';

final class ClassAsyncFamily extends $Family
    with
        $ClassFamilyOverride<ClassAsync, AsyncValue<(String,)>, (String,),
            FutureOr<(String,)>, (String,)> {
  const ClassAsyncFamily._()
      : super(
          retry: null,
          name: r'classAsyncProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ClassAsyncProvider call(
    (String,) arg,
  ) =>
      ClassAsyncProvider._(argument: arg, from: this);

  @override
  String toString() => r'classAsyncProvider';
}

abstract class _$ClassAsync extends $AsyncNotifier<(String,)> {
  late final _$args = ref.$arg as (String,);
  (String,) get arg => _$args;

  FutureOr<(String,)> build(
    (String,) arg,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<(String,)>, (String,)>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<(String,)>, (String,)>,
        AsyncValue<(String,)>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(functionalStream)
const functionalStreamProvider = FunctionalStreamFamily._();

final class FunctionalStreamProvider
    extends $FunctionalProvider<AsyncValue<(int,)>, (int,), Stream<(int,)>>
    with $FutureModifier<(int,)>, $StreamProvider<(int,)> {
  const FunctionalStreamProvider._(
      {required FunctionalStreamFamily super.from,
      required (String,) super.argument})
      : super(
          retry: null,
          name: r'functionalStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$functionalStreamHash();

  @override
  String toString() {
    return r'functionalStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<(int,)> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<(int,)> create(Ref ref) {
    final argument = this.argument as (String,);
    return functionalStream(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FunctionalStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$functionalStreamHash() => r'cdc799595d2f16a31fbf39a55949cc60aa6b4dc5';

final class FunctionalStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<(int,)>, (String,)> {
  const FunctionalStreamFamily._()
      : super(
          retry: null,
          name: r'functionalStreamProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FunctionalStreamProvider call(
    (String,) arg,
  ) =>
      FunctionalStreamProvider._(argument: arg, from: this);

  @override
  String toString() => r'functionalStreamProvider';
}

@ProviderFor(ClassStream)
const classStreamProvider = ClassStreamFamily._();

final class ClassStreamProvider
    extends $StreamNotifierProvider<ClassStream, (String,)> {
  const ClassStreamProvider._(
      {required ClassStreamFamily super.from,
      required (String,) super.argument})
      : super(
          retry: null,
          name: r'classStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$classStreamHash();

  @override
  String toString() {
    return r'classStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClassStream create() => ClassStream();

  @override
  bool operator ==(Object other) {
    return other is ClassStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$classStreamHash() => r'37a8d75c2c0ccbd4b01fbe179cab10a1439c6aff';

final class ClassStreamFamily extends $Family
    with
        $ClassFamilyOverride<ClassStream, AsyncValue<(String,)>, (String,),
            Stream<(String,)>, (String,)> {
  const ClassStreamFamily._()
      : super(
          retry: null,
          name: r'classStreamProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ClassStreamProvider call(
    (String,) arg,
  ) =>
      ClassStreamProvider._(argument: arg, from: this);

  @override
  String toString() => r'classStreamProvider';
}

abstract class _$ClassStream extends $StreamNotifier<(String,)> {
  late final _$args = ref.$arg as (String,);
  (String,) get arg => _$args;

  Stream<(String,)> build(
    (String,) arg,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<(String,)>, (String,)>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<(String,)>, (String,)>,
        AsyncValue<(String,)>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
