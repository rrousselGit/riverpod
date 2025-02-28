// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
      activity: json['activity'] as String,
      type: json['type'] as String,
      participants: (json['participants'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
      'activity': instance.activity,
      'type': instance.type,
      'participants': instance.participants,
      'price': instance.price,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(activity)
const activityProvider = ActivityProvider._();

final class ActivityProvider
    extends $FunctionalProvider<AsyncValue<Activity>, FutureOr<Activity>>
    with $FutureModifier<Activity>, $FutureProvider<Activity> {
  const ActivityProvider._(
      {FutureOr<Activity> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'activityProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<Activity> Function(
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return ActivityProvider._(create: create);
  }

  @override
  FutureOr<Activity> create(Ref ref) {
    final _$cb = _createCb ?? activity;
    return _$cb(ref);
  }
}

String _$activityHash() => r'609ac1c1d8008d8109ea5869c7aa88013032917c';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
