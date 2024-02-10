// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// 그러면 `activityProvider`라는 이름의 provider가 생성됩니다.
/// 이 함수의 결과를 캐시하는 공급자를 생성합니다.
typedef ActivityRef = Ref<AsyncValue<Activity>>;

/// 그러면 `activityProvider`라는 이름의 provider가 생성됩니다.
/// 이 함수의 결과를 캐시하는 공급자를 생성합니다.
@ProviderFor(activity)
const activityProvider = ActivityProvider._();

/// 그러면 `activityProvider`라는 이름의 provider가 생성됩니다.
/// 이 함수의 결과를 캐시하는 공급자를 생성합니다.
final class ActivityProvider extends $FunctionalProvider<AsyncValue<Activity>,
        FutureOr<Activity>, ActivityRef>
    with $FutureModifier<Activity>, $FutureProvider<Activity, ActivityRef> {
  /// 그러면 `activityProvider`라는 이름의 provider가 생성됩니다.
  /// 이 함수의 결과를 캐시하는 공급자를 생성합니다.
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

String _$activityHash() => r'636cd5510e09cbfc46f31b74a70d9e98c89e95a4';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
