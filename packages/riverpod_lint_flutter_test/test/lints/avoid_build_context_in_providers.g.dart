// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avoid_build_context_in_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fn)
final fnProvider = FnFamily._();

final class FnProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  FnProvider._({
    required FnFamily super.from,
    required (BuildContext, {BuildContext context2}) super.argument,
  }) : super(
         retry: null,
         name: r'fnProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fnHash();

  @override
  String toString() {
    return r'fnProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as (BuildContext, {BuildContext context2});
    return fn(ref, argument.$1, context2: argument.context2);
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
    return other is FnProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fnHash() => r'8a726da6104b38a55782e44062757e6771b19de3';

final class FnFamily extends $Family
    with
        $FunctionalFamilyOverride<
          int,
          (BuildContext, {BuildContext context2})
        > {
  FnFamily._()
    : super(
        retry: null,
        name: r'fnProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FnProvider call(BuildContext context1, {required BuildContext context2}) =>
      FnProvider._(argument: (context1, context2: context2), from: this);

  @override
  String toString() => r'fnProvider';
}

@ProviderFor(MyNotifier)
final myProvider = MyNotifierFamily._();

final class MyNotifierProvider extends $NotifierProvider<MyNotifier, int> {
  MyNotifierProvider._({
    required MyNotifierFamily super.from,
    required (BuildContext, {BuildContext context2}) super.argument,
  }) : super(
         retry: null,
         name: r'myProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$myNotifierHash();

  @override
  String toString() {
    return r'myProvider'
        ''
        '$argument';
  }

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

  @override
  bool operator ==(Object other) {
    return other is MyNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$myNotifierHash() => r'04a0cf33dbda80e3fa80748fe46546b1c968da22';

final class MyNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          MyNotifier,
          int,
          int,
          int,
          (BuildContext, {BuildContext context2})
        > {
  MyNotifierFamily._()
    : super(
        retry: null,
        name: r'myProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MyNotifierProvider call(
    BuildContext context1, {
    required BuildContext context2,
  }) => MyNotifierProvider._(
    argument: (context1, context2: context2),
    from: this,
  );

  @override
  String toString() => r'myProvider';
}

abstract class _$MyNotifier extends $Notifier<int> {
  late final _$args = ref.$arg as (BuildContext, {BuildContext context2});
  BuildContext get context1 =>
      _$args.$1; // expect_lint: avoid_build_context_in_providers
  BuildContext get context2 => _$args.context2;

  int build(BuildContext context1, {required BuildContext context2});
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
    element.handleCreate(
      ref,
      () => build(_$args.$1, context2: _$args.context2),
    );
  }
}

@ProviderFor(Regression2959)
final regression2959Provider = Regression2959Provider._();

final class Regression2959Provider
    extends $NotifierProvider<Regression2959, void> {
  Regression2959Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'regression2959Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$regression2959Hash();

  @$internal
  @override
  Regression2959 create() => Regression2959();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$regression2959Hash() => r'e58855125577a855d642da1ef85f35178ad95afd';

abstract class _$Regression2959 extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
