// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      reputation: json['reputation'] as int,
      userId: json['user_id'] as int,
      badgeCounts: json['badge_counts'] == null
          ? null
          : BadgeCount.fromJson(
              (json['badge_counts'] as Map<String, dynamic>).map(
              (k, e) => MapEntry(k, e as Object),
            )),
      displayName: json['display_name'] as String,
      profileImage: json['profile_image'] as String,
      link: json['link'] as String,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'reputation': instance.reputation,
      'user_id': instance.userId,
      'badge_counts': instance.badgeCounts,
      'display_name': instance.displayName,
      'profile_image': instance.profileImage,
      'link': instance.link,
    };

_$_BadgeCount _$$_BadgeCountFromJson(Map<String, dynamic> json) =>
    _$_BadgeCount(
      bronze: json['bronze'] as int,
      silver: json['silver'] as int,
      gold: json['gold'] as int,
    );

Map<String, dynamic> _$$_BadgeCountToJson(_$_BadgeCount instance) =>
    <String, dynamic>{
      'bronze': instance.bronze,
      'silver': instance.silver,
      'gold': instance.gold,
    };
