// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family_and_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(BugsEncounteredNotifier)
const bugsEncounteredNotifierProvider = BugsEncounteredNotifierFamily._();

final class BugsEncounteredNotifierProvider
    extends $AsyncNotifierProvider<BugsEncounteredNotifier, int> {
  const BugsEncounteredNotifierProvider._(
      {required BugsEncounteredNotifierFamily super.from,
      required String super.argument,
      super.runNotifierBuildOverride,
      BugsEncounteredNotifier Function()? create})
      : _createCb = create,
        super(
          name: r'bugsEncounteredNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final BugsEncounteredNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$bugsEncounteredNotifierHash();

  @override
  String toString() {
    return r'bugsEncounteredNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BugsEncounteredNotifier create() =>
      _createCb?.call() ?? BugsEncounteredNotifier();

  @$internal
  @override
  BugsEncounteredNotifierProvider $copyWithCreate(
    BugsEncounteredNotifier Function() create,
  ) {
    return BugsEncounteredNotifierProvider._(
        argument: argument as String,
        from: from! as BugsEncounteredNotifierFamily,
        create: create);
  }

  @$internal
  @override
  BugsEncounteredNotifierProvider $copyWithBuild(
    FutureOr<int> Function(
      Ref<AsyncValue<int>>,
      BugsEncounteredNotifier,
    ) build,
  ) {
    return BugsEncounteredNotifierProvider._(
        argument: argument as String,
        from: from! as BugsEncounteredNotifierFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<BugsEncounteredNotifier, int> $createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is BugsEncounteredNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bugsEncounteredNotifierHash() =>
    r'c76e924f84db91c57d226896b062d9f4e8ab79e5';

final class BugsEncounteredNotifierFamily extends Family {
  const BugsEncounteredNotifierFamily._()
      : super(
          name: r'bugsEncounteredNotifierProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  BugsEncounteredNotifierProvider call(
    String featureId,
  ) =>
      BugsEncounteredNotifierProvider._(argument: featureId, from: this);

  @override
  String debugGetCreateSourceHash() => _$bugsEncounteredNotifierHash();

  @override
  String toString() => r'bugsEncounteredNotifierProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    BugsEncounteredNotifier Function(
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as BugsEncounteredNotifierProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<int> Function(Ref<AsyncValue<int>> ref,
            BugsEncounteredNotifier notifier, String argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as BugsEncounteredNotifierProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$BugsEncounteredNotifier extends $AsyncNotifier<int> {
  late final _$args =
      (ref as $AsyncNotifierProviderElement).origin.argument as String;
  String get featureId => _$args;

  FutureOr<int> build(
    String featureId,
  );
  @$internal
  @override
  FutureOr<int> runBuild() => build(
        _$args,
      );
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
