// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ActivityRef = Ref<AsyncValue<Activity>>;

@ProviderFor(activity)
const activityProvider = ActivityProvider._();

final class ActivityProvider extends $FunctionalProvider<AsyncValue<Activity>,
        FutureOr<Activity>, ActivityRef>
    with $FutureModifier<Activity>, $FutureProvider<Activity, ActivityRef> {
  const ActivityProvider._(
      {FutureOr<Activity> Function(
        ActivityRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'activityProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<Activity> Function(
    ActivityRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$activityHash();

  @$internal
  @override
  $FutureProviderElement<Activity> $createElement(
          ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  ActivityProvider $copyWithCreate(
    FutureOr<Activity> Function(
      ActivityRef ref,
    ) create,
  ) {
    return ActivityProvider._(create: create);
  }

  @override
  FutureOr<Activity> create(ActivityRef ref) {
    final _$cb = _createCb ?? activity;
    return _$cb(ref);
  }
}

String _$activityHash() => r'2f9496c5d70de9314c67e5c48ac44d8b149bc471';

@ProviderFor(ActivityNotifier2)
const activityNotifier2Provider = ActivityNotifier2Family._();

final class ActivityNotifier2Provider
    extends $AsyncNotifierProvider<ActivityNotifier2, Activity> {
  const ActivityNotifier2Provider._(
      {required ActivityNotifier2Family super.from,
      required String super.argument,
      super.runNotifierBuildOverride,
      ActivityNotifier2 Function()? create})
      : _createCb = create,
        super(
          name: r'activityNotifier2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ActivityNotifier2 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$activityNotifier2Hash();

  @override
  String toString() {
    return r'activityNotifier2Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActivityNotifier2 create() => _createCb?.call() ?? ActivityNotifier2();

  @$internal
  @override
  ActivityNotifier2Provider $copyWithCreate(
    ActivityNotifier2 Function() create,
  ) {
    return ActivityNotifier2Provider._(
        argument: argument as String,
        from: from! as ActivityNotifier2Family,
        create: create);
  }

  @$internal
  @override
  ActivityNotifier2Provider $copyWithBuild(
    FutureOr<Activity> Function(
      Ref<AsyncValue<Activity>>,
      ActivityNotifier2,
    ) build,
  ) {
    return ActivityNotifier2Provider._(
        argument: argument as String,
        from: from! as ActivityNotifier2Family,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<ActivityNotifier2, Activity> $createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is ActivityNotifier2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityNotifier2Hash() => r'9e67c655d53a9f98c3b012a0534421385dde0339';

final class ActivityNotifier2Family extends Family {
  const ActivityNotifier2Family._()
      : super(
          name: r'activityNotifier2Provider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ActivityNotifier2Provider call(
    String activityType,
  ) =>
      ActivityNotifier2Provider._(argument: activityType, from: this);

  @override
  String debugGetCreateSourceHash() => _$activityNotifier2Hash();

  @override
  String toString() => r'activityNotifier2Provider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    ActivityNotifier2 Function(
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as ActivityNotifier2Provider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<Activity> Function(Ref<AsyncValue<Activity>> ref,
            ActivityNotifier2 notifier, String argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as ActivityNotifier2Provider;

        final argument = provider.argument as String;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$ActivityNotifier2 extends $AsyncNotifier<Activity> {
  late final _$args =
      (ref as $AsyncNotifierProviderElement).origin.argument as String;
  String get activityType => _$args;

  FutureOr<Activity> build(
    String activityType,
  );
  @$internal
  @override
  FutureOr<Activity> runBuild() => build(
        _$args,
      );
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
