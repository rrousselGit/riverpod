// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avoid_build_context_in_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(fn)
const fnProvider = FnFamily._();

final class FnProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const FnProvider._(
      {required FnFamily super.from,
      required (
        BuildContext, {
        BuildContext context2,
      })
          super.argument})
      : super(
          retry: null,
          name: r'fnProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
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
    final argument = this.argument as (
      BuildContext, {
      BuildContext context2,
    });
    return fn(
      ref,
      argument.$1,
      context2: argument.context2,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
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
            (
              BuildContext, {
              BuildContext context2,
            })> {
  const FnFamily._()
      : super(
          retry: null,
          name: r'fnProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FnProvider call(
    BuildContext context1, {
    required BuildContext context2,
  }) =>
      FnProvider._(argument: (
        context1,
        context2: context2,
      ), from: this);

  @override
  String toString() => r'fnProvider';
}

@ProviderFor(MyNotifier)
const myNotifierProvider = MyNotifierFamily._();

final class MyNotifierProvider extends $NotifierProvider<MyNotifier, int> {
  const MyNotifierProvider._(
      {required MyNotifierFamily super.from,
      required (
        BuildContext, {
        BuildContext context2,
      })
          super.argument})
      : super(
          retry: null,
          name: r'myNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myNotifierHash();

  @override
  String toString() {
    return r'myNotifierProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MyNotifier create() => MyNotifier();

  @$internal
  @override
  $NotifierProviderElement<MyNotifier, int> $createElement(
          $ProviderPointer pointer) =>
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
            (
              BuildContext, {
              BuildContext context2,
            })> {
  const MyNotifierFamily._()
      : super(
          retry: null,
          name: r'myNotifierProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  MyNotifierProvider call(
    BuildContext context1, {
    required BuildContext context2,
  }) =>
      MyNotifierProvider._(argument: (
        context1,
        context2: context2,
      ), from: this);

  @override
  String toString() => r'myNotifierProvider';
}

abstract class _$MyNotifier extends $Notifier<int> {
  late final _$args = ref.$arg as (
    BuildContext, {
    BuildContext context2,
  });
  BuildContext get context1 =>
      _$args.$1; // expect_lint: avoid_build_context_in_providers
  BuildContext get context2 => _$args.context2;

  int build(
    BuildContext context1, {
    required BuildContext context2,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      context2: _$args.context2,
    );
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Regression2959)
const regression2959Provider = Regression2959Provider._();

final class Regression2959Provider
    extends $NotifierProvider<Regression2959, void> {
  const Regression2959Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'regression2959Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$regression2959Hash();

  @$internal
  @override
  Regression2959 create() => Regression2959();

  @$internal
  @override
  $NotifierProviderElement<Regression2959, void> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<void>(value),
    );
  }
}

String _$regression2959Hash() => r'e58855125577a855d642da1ef85f35178ad95afd';

abstract class _$Regression2959 extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<void>, void, Object?, Object?>;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
