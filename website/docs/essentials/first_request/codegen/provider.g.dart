// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// This will create a provider named `activityProvider`
/// which will cache the result of this function.
// {@endtemplate}
typedef ActivityRef = Ref<AsyncValue<Activity>>;

/// This will create a provider named `activityProvider`
/// which will cache the result of this function.
// {@endtemplate}
@ProviderFor(activity)
const activityProvider = ActivityProvider._();

/// This will create a provider named `activityProvider`
/// which will cache the result of this function.
// {@endtemplate}
final class ActivityProvider
    extends $FunctionalProvider<AsyncValue<Activity>, FutureOr<Activity>>
    with $FutureModifier<Activity>, $FutureProvider<Activity, ActivityRef> {
  /// This will create a provider named `activityProvider`
  /// which will cache the result of this function.
// {@endtemplate}
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
  $FutureProviderElement<Activity> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

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

String _$activityHash() => r'636cd5510e09cbfc46f31b74a70d9e98c89e95a4';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
