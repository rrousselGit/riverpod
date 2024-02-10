// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ActivityRef = Ref<AsyncValue<Activity>>;

@ProviderFor(activity)
const activityProvider = ActivityFamily._();

final class ActivityProvider extends $FunctionalProvider<AsyncValue<Activity>,
        FutureOr<Activity>, ActivityRef>
    with $FutureModifier<Activity>, $FutureProvider<Activity, ActivityRef> {
  const ActivityProvider._(
      {required ActivityFamily super.from,
      required String super.argument,
      FutureOr<Activity> Function(
        ActivityRef ref,
        String activityType,
      )? create})
      : _createCb = create,
        super(
          name: r'activityProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<Activity> Function(
    ActivityRef ref,
    String activityType,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$activityHash();

  @override
  String toString() {
    return r'activityProvider'
        ''
        '($argument)';
  }

  @override
  $FutureProviderElement<Activity> createElement(ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  ActivityProvider $copyWithCreate(
    FutureOr<Activity> Function(
      ActivityRef ref,
    ) create,
  ) {
    return ActivityProvider._(
        argument: argument as String,
        from: from! as ActivityFamily,
        create: (
          ref,
          String activityType,
        ) =>
            create(ref));
  }

  @override
  FutureOr<Activity> create(ActivityRef ref) {
    final fn = _createCb ?? activity;
    final argument = this.argument as String;
    return fn(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityHash() => r'cb76e67cd45f1823d3ed497a235be53819ce2eaf';

final class ActivityFamily extends Family {
  const ActivityFamily._()
      : super(
          name: r'activityProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ActivityProvider call(
    String activityType,
  ) =>
      ActivityProvider._(argument: activityType, from: this);

  @override
  String debugGetCreateSourceHash() => _$activityHash();

  @override
  String toString() => r'activityProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    FutureOr<Activity> Function(
      ActivityRef ref,
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as ActivityProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .createElement(container);
      },
    );
  }
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
