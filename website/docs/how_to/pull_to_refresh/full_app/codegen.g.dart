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

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activity)
const activityProvider = ActivityProvider._();

final class ActivityProvider
    extends
        $FunctionalProvider<AsyncValue<Activity>, Activity, FutureOr<Activity>>
    with $FutureModifier<Activity>, $FutureProvider<Activity> {
  const ActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityHash();

  @$internal
  @override
  $FutureProviderElement<Activity> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Activity> create(Ref ref) {
    return activity(ref);
  }
}

String _$activityHash() => r'609ac1c1d8008d8109ea5869c7aa88013032917c';
