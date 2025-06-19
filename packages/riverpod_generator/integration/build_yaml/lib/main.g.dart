// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(count)
const myCountPod = CountProvider._();

final class CountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const CountProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myCountPod',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return count(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$countHash() => r'a31bb5cbb0ddb2466df2cc62a306709ea24fae12';

@ProviderFor(countFuture)
const myCountFuturePod = CountFutureProvider._();

final class CountFutureProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  const CountFutureProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myCountFuturePod',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countFutureHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return countFuture(ref);
  }
}

String _$countFutureHash() => r'c292214b486fdd9ec98a61e277812f29fc4b5802';

@ProviderFor(countStream)
const myCountStreamPod = CountStreamProvider._();

final class CountStreamProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  const CountStreamProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myCountStreamPod',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countStreamHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return countStream(ref);
  }
}

String _$countStreamHash() => r'472c06085fb994619f54de368f047b7cc8466872';

@ProviderFor(CountNotifier)
const myCountNotifierPod = CountNotifierProvider._();

final class CountNotifierProvider
    extends $NotifierProvider<CountNotifier, int> {
  const CountNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myCountNotifierPod',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countNotifierHash();

  @$internal
  @override
  CountNotifier create() => CountNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$countNotifierHash() => r'a8dd7a66ee0002b8af657245c4affaa206fd99ec';

abstract class _$CountNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CountAsyncNotifier)
const myCountAsyncNotifierPod = CountAsyncNotifierProvider._();

final class CountAsyncNotifierProvider
    extends $AsyncNotifierProvider<CountAsyncNotifier, int> {
  const CountAsyncNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myCountAsyncNotifierPod',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countAsyncNotifierHash();

  @$internal
  @override
  CountAsyncNotifier create() => CountAsyncNotifier();
}

String _$countAsyncNotifierHash() =>
    r'2a7049d864bf396e44a5937b4001efb4774a5f29';

abstract class _$CountAsyncNotifier extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<int>, int>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CountStreamNotifier)
const myCountStreamNotifierPod = CountStreamNotifierProvider._();

final class CountStreamNotifierProvider
    extends $StreamNotifierProvider<CountStreamNotifier, int> {
  const CountStreamNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myCountStreamNotifierPod',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countStreamNotifierHash();

  @$internal
  @override
  CountStreamNotifier create() => CountStreamNotifier();
}

String _$countStreamNotifierHash() =>
    r'61d2cd311c4808f8d7e8b2d67f5c7b85337666c6';

abstract class _$CountStreamNotifier extends $StreamNotifier<int> {
  Stream<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<int>, int>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(count2)
const myFamilyCount2ProviderFamily = Count2Family._();

final class Count2Provider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const Count2Provider._(
      {required Count2Family super.from, required int super.argument})
      : super(
          retry: null,
          name: r'myFamilyCount2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$count2Hash();

  @override
  String toString() {
    return r'myFamilyCount2ProviderFamily'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as int;
    return count2(
      ref,
      argument,
    );
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
    return other is Count2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$count2Hash() => r'4146ae486161f9d444b4d80ec846199b13eeaae2';

final class Count2Family extends $Family
    with $FunctionalFamilyOverride<int, int> {
  const Count2Family._()
      : super(
          retry: null,
          name: r'myFamilyCount2ProviderFamily',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  Count2Provider call(
    int a,
  ) =>
      Count2Provider._(argument: a, from: this);

  @override
  String toString() => r'myFamilyCount2ProviderFamily';
}

@ProviderFor(countFuture2)
const myFamilyCountFuture2ProviderFamily = CountFuture2Family._();

final class CountFuture2Provider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  const CountFuture2Provider._(
      {required CountFuture2Family super.from, required int super.argument})
      : super(
          retry: null,
          name: r'myFamilyCountFuture2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countFuture2Hash();

  @override
  String toString() {
    return r'myFamilyCountFuture2ProviderFamily'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as int;
    return countFuture2(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CountFuture2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$countFuture2Hash() => r'6acaa58de0116853fd831efb4ac1a8047205f12b';

final class CountFuture2Family extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, int> {
  const CountFuture2Family._()
      : super(
          retry: null,
          name: r'myFamilyCountFuture2ProviderFamily',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CountFuture2Provider call(
    int a,
  ) =>
      CountFuture2Provider._(argument: a, from: this);

  @override
  String toString() => r'myFamilyCountFuture2ProviderFamily';
}

@ProviderFor(countStream2)
const myFamilyCountStream2ProviderFamily = CountStream2Family._();

final class CountStream2Provider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  const CountStream2Provider._(
      {required CountStream2Family super.from, required int super.argument})
      : super(
          retry: null,
          name: r'myFamilyCountStream2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countStream2Hash();

  @override
  String toString() {
    return r'myFamilyCountStream2ProviderFamily'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as int;
    return countStream2(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CountStream2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$countStream2Hash() => r'96c9a0935240f1727986800c1fe6dea974b9accc';

final class CountStream2Family extends $Family
    with $FunctionalFamilyOverride<Stream<int>, int> {
  const CountStream2Family._()
      : super(
          retry: null,
          name: r'myFamilyCountStream2ProviderFamily',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CountStream2Provider call(
    int a,
  ) =>
      CountStream2Provider._(argument: a, from: this);

  @override
  String toString() => r'myFamilyCountStream2ProviderFamily';
}

@ProviderFor(CountNotifier2)
const myFamilyCountNotifier2ProviderFamily = CountNotifier2Family._();

final class CountNotifier2Provider
    extends $NotifierProvider<CountNotifier2, int> {
  const CountNotifier2Provider._(
      {required CountNotifier2Family super.from, required int super.argument})
      : super(
          retry: null,
          name: r'myFamilyCountNotifier2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countNotifier2Hash();

  @override
  String toString() {
    return r'myFamilyCountNotifier2ProviderFamily'
        ''
        '($argument)';
  }

  @$internal
  @override
  CountNotifier2 create() => CountNotifier2();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CountNotifier2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$countNotifier2Hash() => r'ef12bb4f94add336804ae43bcdbcd8e9b0bec420';

final class CountNotifier2Family extends $Family
    with $ClassFamilyOverride<CountNotifier2, int, int, int, int> {
  const CountNotifier2Family._()
      : super(
          retry: null,
          name: r'myFamilyCountNotifier2ProviderFamily',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CountNotifier2Provider call(
    int a,
  ) =>
      CountNotifier2Provider._(argument: a, from: this);

  @override
  String toString() => r'myFamilyCountNotifier2ProviderFamily';
}

abstract class _$CountNotifier2 extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get a => _$args;

  int build(
    int a,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CountAsyncNotifier2)
const myFamilyCountAsyncNotifier2ProviderFamily = CountAsyncNotifier2Family._();

final class CountAsyncNotifier2Provider
    extends $AsyncNotifierProvider<CountAsyncNotifier2, int> {
  const CountAsyncNotifier2Provider._(
      {required CountAsyncNotifier2Family super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'myFamilyCountAsyncNotifier2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countAsyncNotifier2Hash();

  @override
  String toString() {
    return r'myFamilyCountAsyncNotifier2ProviderFamily'
        ''
        '($argument)';
  }

  @$internal
  @override
  CountAsyncNotifier2 create() => CountAsyncNotifier2();

  @override
  bool operator ==(Object other) {
    return other is CountAsyncNotifier2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$countAsyncNotifier2Hash() =>
    r'e4bd4d858edbb47fa0d7581f3cfa72e13c914d3d';

final class CountAsyncNotifier2Family extends $Family
    with
        $ClassFamilyOverride<CountAsyncNotifier2, AsyncValue<int>, int,
            FutureOr<int>, int> {
  const CountAsyncNotifier2Family._()
      : super(
          retry: null,
          name: r'myFamilyCountAsyncNotifier2ProviderFamily',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CountAsyncNotifier2Provider call(
    int a,
  ) =>
      CountAsyncNotifier2Provider._(argument: a, from: this);

  @override
  String toString() => r'myFamilyCountAsyncNotifier2ProviderFamily';
}

abstract class _$CountAsyncNotifier2 extends $AsyncNotifier<int> {
  late final _$args = ref.$arg as int;
  int get a => _$args;

  FutureOr<int> build(
    int a,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<int>, int>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CountStreamNotifier2)
const myFamilyCountStreamNotifier2ProviderFamily =
    CountStreamNotifier2Family._();

final class CountStreamNotifier2Provider
    extends $StreamNotifierProvider<CountStreamNotifier2, int> {
  const CountStreamNotifier2Provider._(
      {required CountStreamNotifier2Family super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'myFamilyCountStreamNotifier2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countStreamNotifier2Hash();

  @override
  String toString() {
    return r'myFamilyCountStreamNotifier2ProviderFamily'
        ''
        '($argument)';
  }

  @$internal
  @override
  CountStreamNotifier2 create() => CountStreamNotifier2();

  @override
  bool operator ==(Object other) {
    return other is CountStreamNotifier2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$countStreamNotifier2Hash() =>
    r'13be1b7aa32801b33c68f2a228851d2fb6a4a9ee';

final class CountStreamNotifier2Family extends $Family
    with
        $ClassFamilyOverride<CountStreamNotifier2, AsyncValue<int>, int,
            Stream<int>, int> {
  const CountStreamNotifier2Family._()
      : super(
          retry: null,
          name: r'myFamilyCountStreamNotifier2ProviderFamily',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CountStreamNotifier2Provider call(
    int a,
  ) =>
      CountStreamNotifier2Provider._(argument: a, from: this);

  @override
  String toString() => r'myFamilyCountStreamNotifier2ProviderFamily';
}

abstract class _$CountStreamNotifier2 extends $StreamNotifier<int> {
  late final _$args = ref.$arg as int;
  int get a => _$args;

  Stream<int> build(
    int a,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<int>, int>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
