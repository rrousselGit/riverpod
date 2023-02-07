// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  int get reputation => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  BadgeCount? get badgeCounts => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get profileImage => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {int reputation,
      int userId,
      BadgeCount? badgeCounts,
      String displayName,
      String profileImage,
      String link});

  $BadgeCountCopyWith<$Res>? get badgeCounts;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reputation = null,
    Object? userId = null,
    Object? badgeCounts = freezed,
    Object? displayName = null,
    Object? profileImage = null,
    Object? link = null,
  }) {
    return _then(_value.copyWith(
      reputation: null == reputation
          ? _value.reputation
          : reputation // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      badgeCounts: freezed == badgeCounts
          ? _value.badgeCounts
          : badgeCounts // ignore: cast_nullable_to_non_nullable
              as BadgeCount?,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: null == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BadgeCountCopyWith<$Res>? get badgeCounts {
    if (_value.badgeCounts == null) {
      return null;
    }

    return $BadgeCountCopyWith<$Res>(_value.badgeCounts!, (value) {
      return _then(_value.copyWith(badgeCounts: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int reputation,
      int userId,
      BadgeCount? badgeCounts,
      String displayName,
      String profileImage,
      String link});

  @override
  $BadgeCountCopyWith<$Res>? get badgeCounts;
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$_User>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reputation = null,
    Object? userId = null,
    Object? badgeCounts = freezed,
    Object? displayName = null,
    Object? profileImage = null,
    Object? link = null,
  }) {
    return _then(_$_User(
      reputation: null == reputation
          ? _value.reputation
          : reputation // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      badgeCounts: freezed == badgeCounts
          ? _value.badgeCounts
          : badgeCounts // ignore: cast_nullable_to_non_nullable
              as BadgeCount?,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: null == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_User implements _User {
  _$_User(
      {required this.reputation,
      required this.userId,
      this.badgeCounts,
      required this.displayName,
      required this.profileImage,
      required this.link});

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final int reputation;
  @override
  final int userId;
  @override
  final BadgeCount? badgeCounts;
  @override
  final String displayName;
  @override
  final String profileImage;
  @override
  final String link;

  @override
  String toString() {
    return 'User(reputation: $reputation, userId: $userId, badgeCounts: $badgeCounts, displayName: $displayName, profileImage: $profileImage, link: $link)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            (identical(other.reputation, reputation) ||
                other.reputation == reputation) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.badgeCounts, badgeCounts) ||
                other.badgeCounts == badgeCounts) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.link, link) || other.link == link));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, reputation, userId, badgeCounts,
      displayName, profileImage, link);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(
      this,
    );
  }
}

abstract class _User implements User {
  factory _User(
      {required final int reputation,
      required final int userId,
      final BadgeCount? badgeCounts,
      required final String displayName,
      required final String profileImage,
      required final String link}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  int get reputation;
  @override
  int get userId;
  @override
  BadgeCount? get badgeCounts;
  @override
  String get displayName;
  @override
  String get profileImage;
  @override
  String get link;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}

BadgeCount _$BadgeCountFromJson(Map<String, dynamic> json) {
  return _BadgeCount.fromJson(json);
}

/// @nodoc
mixin _$BadgeCount {
  int get bronze => throw _privateConstructorUsedError;
  int get silver => throw _privateConstructorUsedError;
  int get gold => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BadgeCountCopyWith<BadgeCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeCountCopyWith<$Res> {
  factory $BadgeCountCopyWith(
          BadgeCount value, $Res Function(BadgeCount) then) =
      _$BadgeCountCopyWithImpl<$Res, BadgeCount>;
  @useResult
  $Res call({int bronze, int silver, int gold});
}

/// @nodoc
class _$BadgeCountCopyWithImpl<$Res, $Val extends BadgeCount>
    implements $BadgeCountCopyWith<$Res> {
  _$BadgeCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bronze = null,
    Object? silver = null,
    Object? gold = null,
  }) {
    return _then(_value.copyWith(
      bronze: null == bronze
          ? _value.bronze
          : bronze // ignore: cast_nullable_to_non_nullable
              as int,
      silver: null == silver
          ? _value.silver
          : silver // ignore: cast_nullable_to_non_nullable
              as int,
      gold: null == gold
          ? _value.gold
          : gold // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BadgeCountCopyWith<$Res>
    implements $BadgeCountCopyWith<$Res> {
  factory _$$_BadgeCountCopyWith(
          _$_BadgeCount value, $Res Function(_$_BadgeCount) then) =
      __$$_BadgeCountCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int bronze, int silver, int gold});
}

/// @nodoc
class __$$_BadgeCountCopyWithImpl<$Res>
    extends _$BadgeCountCopyWithImpl<$Res, _$_BadgeCount>
    implements _$$_BadgeCountCopyWith<$Res> {
  __$$_BadgeCountCopyWithImpl(
      _$_BadgeCount _value, $Res Function(_$_BadgeCount) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bronze = null,
    Object? silver = null,
    Object? gold = null,
  }) {
    return _then(_$_BadgeCount(
      bronze: null == bronze
          ? _value.bronze
          : bronze // ignore: cast_nullable_to_non_nullable
              as int,
      silver: null == silver
          ? _value.silver
          : silver // ignore: cast_nullable_to_non_nullable
              as int,
      gold: null == gold
          ? _value.gold
          : gold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BadgeCount implements _BadgeCount {
  _$_BadgeCount(
      {required this.bronze, required this.silver, required this.gold});

  factory _$_BadgeCount.fromJson(Map<String, dynamic> json) =>
      _$$_BadgeCountFromJson(json);

  @override
  final int bronze;
  @override
  final int silver;
  @override
  final int gold;

  @override
  String toString() {
    return 'BadgeCount(bronze: $bronze, silver: $silver, gold: $gold)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BadgeCount &&
            (identical(other.bronze, bronze) || other.bronze == bronze) &&
            (identical(other.silver, silver) || other.silver == silver) &&
            (identical(other.gold, gold) || other.gold == gold));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, bronze, silver, gold);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BadgeCountCopyWith<_$_BadgeCount> get copyWith =>
      __$$_BadgeCountCopyWithImpl<_$_BadgeCount>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BadgeCountToJson(
      this,
    );
  }
}

abstract class _BadgeCount implements BadgeCount {
  factory _BadgeCount(
      {required final int bronze,
      required final int silver,
      required final int gold}) = _$_BadgeCount;

  factory _BadgeCount.fromJson(Map<String, dynamic> json) =
      _$_BadgeCount.fromJson;

  @override
  int get bronze;
  @override
  int get silver;
  @override
  int get gold;
  @override
  @JsonKey(ignore: true)
  _$$_BadgeCountCopyWith<_$_BadgeCount> get copyWith =>
      throw _privateConstructorUsedError;
}
