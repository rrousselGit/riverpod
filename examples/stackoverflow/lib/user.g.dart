// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  reputation: (json['reputation'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  badgeCounts: json['badge_counts'] == null
      ? null
      : BadgeCount.fromJson(
          (json['badge_counts'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, e as Object),
          ),
        ),
  displayName: json['display_name'] as String,
  profileImage: json['profile_image'] as String,
  link: json['link'] as String,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'reputation': instance.reputation,
  'user_id': instance.userId,
  'badge_counts': instance.badgeCounts,
  'display_name': instance.displayName,
  'profile_image': instance.profileImage,
  'link': instance.link,
};

_BadgeCount _$BadgeCountFromJson(Map<String, dynamic> json) => _BadgeCount(
  bronze: (json['bronze'] as num).toInt(),
  silver: (json['silver'] as num).toInt(),
  gold: (json['gold'] as num).toInt(),
);

Map<String, dynamic> _$BadgeCountToJson(_BadgeCount instance) =>
    <String, dynamic>{
      'bronze': instance.bronze,
      'silver': instance.silver,
      'gold': instance.gold,
    };
