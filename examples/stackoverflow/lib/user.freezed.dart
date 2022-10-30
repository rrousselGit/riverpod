// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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
      _$UserCopyWithImpl<$Res>;
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
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object? reputation = freezed,
    Object? userId = freezed,
    Object? badgeCounts = freezed,
    Object? displayName = freezed,
    Object? profileImage = freezed,
    Object? link = freezed,
  }) {
    return _then(_value.copyWith(
      reputation: reputation == freezed
          ? _value.reputation
          : reputation // ignore: cast_nullable_to_non_nullable
              as int,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      badgeCounts: badgeCounts == freezed
          ? _value.badgeCounts
          : badgeCounts // ignore: cast_nullable_to_non_nullable
              as BadgeCount?,
      displayName: displayName == freezed
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: profileImage == freezed
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String,
      link: link == freezed
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  $BadgeCountCopyWith<$Res>? get badgeCounts {
    if (_value.badgeCounts == null) {
      return null;
    }

    return $BadgeCountCopyWith<$Res>(_value.badgeCounts!, (value) {
      return _then(_value.copyWith(badgeCounts: value));
    });
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
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
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, (v) => _then(v as _$_User));

  @override
  _$_User get _value => super._value as _$_User;

  @override
  $Res call({
    Object? reputation = freezed,
    Object? userId = freezed,
    Object? badgeCounts = freezed,
    Object? displayName = freezed,
    Object? profileImage = freezed,
    Object? link = freezed,
  }) {
    return _then(_$_User(
      reputation: reputation == freezed
          ? _value.reputation
          : reputation // ignore: cast_nullable_to_non_nullable
              as int,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      badgeCounts: badgeCounts == freezed
          ? _value.badgeCounts
          : badgeCounts // ignore: cast_nullable_to_non_nullable
              as BadgeCount?,
      displayName: displayName == freezed
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: profileImage == freezed
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String,
      link: link == freezed
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
            const DeepCollectionEquality()
                .equals(other.reputation, reputation) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            const DeepCollectionEquality()
                .equals(other.badgeCounts, badgeCounts) &&
            const DeepCollectionEquality()
                .equals(other.displayName, displayName) &&
            const DeepCollectionEquality()
                .equals(other.profileImage, profileImage) &&
            const DeepCollectionEquality().equals(other.link, link));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(reputation),
      const DeepCollectionEquality().hash(userId),
      const DeepCollectionEquality().hash(badgeCounts),
      const DeepCollectionEquality().hash(displayName),
      const DeepCollectionEquality().hash(profileImage),
      const DeepCollectionEquality().hash(link));

  @JsonKey(ignore: true)
  @override
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
      _$BadgeCountCopyWithImpl<$Res>;
  $Res call({int bronze, int silver, int gold});
}

/// @nodoc
class _$BadgeCountCopyWithImpl<$Res> implements $BadgeCountCopyWith<$Res> {
  _$BadgeCountCopyWithImpl(this._value, this._then);

  final BadgeCount _value;
  // ignore: unused_field
  final $Res Function(BadgeCount) _then;

  @override
  $Res call({
    Object? bronze = freezed,
    Object? silver = freezed,
    Object? gold = freezed,
  }) {
    return _then(_value.copyWith(
      bronze: bronze == freezed
          ? _value.bronze
          : bronze // ignore: cast_nullable_to_non_nullable
              as int,
      silver: silver == freezed
          ? _value.silver
          : silver // ignore: cast_nullable_to_non_nullable
              as int,
      gold: gold == freezed
          ? _value.gold
          : gold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$_BadgeCountCopyWith<$Res>
    implements $BadgeCountCopyWith<$Res> {
  factory _$$_BadgeCountCopyWith(
          _$_BadgeCount value, $Res Function(_$_BadgeCount) then) =
      __$$_BadgeCountCopyWithImpl<$Res>;
  @override
  $Res call({int bronze, int silver, int gold});
}

/// @nodoc
class __$$_BadgeCountCopyWithImpl<$Res> extends _$BadgeCountCopyWithImpl<$Res>
    implements _$$_BadgeCountCopyWith<$Res> {
  __$$_BadgeCountCopyWithImpl(
      _$_BadgeCount _value, $Res Function(_$_BadgeCount) _then)
      : super(_value, (v) => _then(v as _$_BadgeCount));

  @override
  _$_BadgeCount get _value => super._value as _$_BadgeCount;

  @override
  $Res call({
    Object? bronze = freezed,
    Object? silver = freezed,
    Object? gold = freezed,
  }) {
    return _then(_$_BadgeCount(
      bronze: bronze == freezed
          ? _value.bronze
          : bronze // ignore: cast_nullable_to_non_nullable
              as int,
      silver: silver == freezed
          ? _value.silver
          : silver // ignore: cast_nullable_to_non_nullable
              as int,
      gold: gold == freezed
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
            const DeepCollectionEquality().equals(other.bronze, bronze) &&
            const DeepCollectionEquality().equals(other.silver, silver) &&
            const DeepCollectionEquality().equals(other.gold, gold));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(bronze),
      const DeepCollectionEquality().hash(silver),
      const DeepCollectionEquality().hash(gold));

  @JsonKey(ignore: true)
  @override
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
