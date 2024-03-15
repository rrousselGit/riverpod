// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avoid_build_context_in_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef FnRef = Ref<int>;

@ProviderFor(fn)
const fnProvider = FnFamily._();

final class FnProvider extends $FunctionalProvider<int, int>
    with $Provider<int, FnRef> {
  const FnProvider._(
      {required FnFamily super.from,
      required (
        BuildContext, {
        BuildContext context2,
      })
          super.argument,
      int Function(
        FnRef ref,
        BuildContext context1, {
        required BuildContext context2,
      })? create})
      : _createCb = create,
        super(
          name: r'fnProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    FnRef ref,
    BuildContext context1, {
    required BuildContext context2,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$fnHash();

  @override
  String toString() {
    return r'fnProvider'
        ''
        '$argument';
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  FnProvider $copyWithCreate(
    int Function(
      FnRef ref,
    ) create,
  ) {
    return FnProvider._(
        argument: argument as (
          BuildContext, {
          BuildContext context2,
        }),
        from: from! as FnFamily,
        create: (
          ref,
          BuildContext context1, {
          required BuildContext context2,
        }) =>
            create(ref));
  }

  @override
  int create(FnRef ref) {
    final _$cb = _createCb ?? fn;
    final argument = this.argument as (
      BuildContext, {
      BuildContext context2,
    });
    return _$cb(
      ref,
      argument.$1,
      context2: argument.context2,
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

String _$fnHash() => r'7b8d0cf179067c80b8553b3232fd886fac83f387';

final class FnFamily extends Family {
  const FnFamily._()
      : super(
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
  String debugGetCreateSourceHash() => _$fnHash();

  @override
  String toString() => r'fnProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      FnRef ref,
      (
        BuildContext, {
        BuildContext context2,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer, provider) {
        provider as FnProvider;

        final argument = provider.argument as (
          BuildContext, {
          BuildContext context2,
        });

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
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
          super.argument,
      super.runNotifierBuildOverride,
      MyNotifier Function()? create})
      : _createCb = create,
        super(
          name: r'myNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MyNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$myNotifierHash();

  @override
  String toString() {
    return r'myNotifierProvider'
        ''
        '$argument';
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
  MyNotifier create() => _createCb?.call() ?? MyNotifier();

  @$internal
  @override
  MyNotifierProvider $copyWithCreate(
    MyNotifier Function() create,
  ) {
    return MyNotifierProvider._(
        argument: argument as (
          BuildContext, {
          BuildContext context2,
        }),
        from: from! as MyNotifierFamily,
        create: create);
  }

  @$internal
  @override
  MyNotifierProvider $copyWithBuild(
    int Function(
      Ref<int>,
      MyNotifier,
    ) build,
  ) {
    return MyNotifierProvider._(
        argument: argument as (
          BuildContext, {
          BuildContext context2,
        }),
        from: from! as MyNotifierFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<MyNotifier, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

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

final class MyNotifierFamily extends Family {
  const MyNotifierFamily._()
      : super(
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
  String debugGetCreateSourceHash() => _$myNotifierHash();

  @override
  String toString() => r'myNotifierProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    MyNotifier Function(
      (
        BuildContext, {
        BuildContext context2,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer, provider) {
        provider as MyNotifierProvider;

        final argument = provider.argument as (
          BuildContext, {
          BuildContext context2,
        });

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function(
            Ref<int> ref,
            MyNotifier notifier,
            (
              BuildContext, {
              BuildContext context2,
            }) argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer, provider) {
        provider as MyNotifierProvider;

        final argument = provider.argument as (
          BuildContext, {
          BuildContext context2,
        });

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$MyNotifier extends $Notifier<int> {
  late final _$args = ref.$arg as (
    BuildContext, {
    BuildContext context2,
  });
  // expect_lint: avoid_build_context_in_providers
  BuildContext get context1 =>
      _$args.$1; // expect_lint: avoid_build_context_in_providers
  BuildContext get context2 => _$args.context2;

  int build(
    BuildContext context1, {
    required BuildContext context2,
  });
  @$internal
  @override
  int runBuild() => build(
        _$args.$1,
        context2: _$args.context2,
      );
}

@ProviderFor(Regresion2959)
const regresion2959Provider = Regresion2959Provider._();

final class Regresion2959Provider
    extends $NotifierProvider<Regresion2959, void> {
  const Regresion2959Provider._(
      {super.runNotifierBuildOverride, Regresion2959 Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'regresion2959Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Regresion2959 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$regresion2959Hash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<void>(value),
    );
  }

  @$internal
  @override
  Regresion2959 create() => _createCb?.call() ?? Regresion2959();

  @$internal
  @override
  Regresion2959Provider $copyWithCreate(
    Regresion2959 Function() create,
  ) {
    return Regresion2959Provider._(create: create);
  }

  @$internal
  @override
  Regresion2959Provider $copyWithBuild(
    void Function(
      Ref<void>,
      Regresion2959,
    ) build,
  ) {
    return Regresion2959Provider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Regresion2959, void> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$regresion2959Hash() => r'bcf9a829ce75026a78569de680451d157c7d90a2';

abstract class _$Regresion2959 extends $Notifier<void> {
  void build();
  @$internal
  @override
  void runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
