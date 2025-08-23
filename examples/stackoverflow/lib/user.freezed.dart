// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 int get reputation; int get userId; BadgeCount? get badgeCounts; String get displayName; String get profileImage; String get link;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.reputation, reputation) || other.reputation == reputation)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.badgeCounts, badgeCounts) || other.badgeCounts == badgeCounts)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.link, link) || other.link == link));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reputation,userId,badgeCounts,displayName,profileImage,link);

@override
String toString() {
  return 'User(reputation: $reputation, userId: $userId, badgeCounts: $badgeCounts, displayName: $displayName, profileImage: $profileImage, link: $link)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 int reputation, int userId, BadgeCount? badgeCounts, String displayName, String profileImage, String link
});


$BadgeCountCopyWith<$Res>? get badgeCounts;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reputation = null,Object? userId = null,Object? badgeCounts = freezed,Object? displayName = null,Object? profileImage = null,Object? link = null,}) {
  return _then(_self.copyWith(
reputation: null == reputation ? _self.reputation : reputation // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,badgeCounts: freezed == badgeCounts ? _self.badgeCounts : badgeCounts // ignore: cast_nullable_to_non_nullable
as BadgeCount?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,profileImage: null == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BadgeCountCopyWith<$Res>? get badgeCounts {
    if (_self.badgeCounts == null) {
    return null;
  }

  return $BadgeCountCopyWith<$Res>(_self.badgeCounts!, (value) {
    return _then(_self.copyWith(badgeCounts: value));
  });
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int reputation,  int userId,  BadgeCount? badgeCounts,  String displayName,  String profileImage,  String link)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.reputation,_that.userId,_that.badgeCounts,_that.displayName,_that.profileImage,_that.link);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int reputation,  int userId,  BadgeCount? badgeCounts,  String displayName,  String profileImage,  String link)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.reputation,_that.userId,_that.badgeCounts,_that.displayName,_that.profileImage,_that.link);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int reputation,  int userId,  BadgeCount? badgeCounts,  String displayName,  String profileImage,  String link)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.reputation,_that.userId,_that.badgeCounts,_that.displayName,_that.profileImage,_that.link);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _User implements User {
   _User({required this.reputation, required this.userId, this.badgeCounts, required this.displayName, required this.profileImage, required this.link});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  int reputation;
@override final  int userId;
@override final  BadgeCount? badgeCounts;
@override final  String displayName;
@override final  String profileImage;
@override final  String link;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.reputation, reputation) || other.reputation == reputation)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.badgeCounts, badgeCounts) || other.badgeCounts == badgeCounts)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.link, link) || other.link == link));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reputation,userId,badgeCounts,displayName,profileImage,link);

@override
String toString() {
  return 'User(reputation: $reputation, userId: $userId, badgeCounts: $badgeCounts, displayName: $displayName, profileImage: $profileImage, link: $link)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 int reputation, int userId, BadgeCount? badgeCounts, String displayName, String profileImage, String link
});


@override $BadgeCountCopyWith<$Res>? get badgeCounts;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reputation = null,Object? userId = null,Object? badgeCounts = freezed,Object? displayName = null,Object? profileImage = null,Object? link = null,}) {
  return _then(_User(
reputation: null == reputation ? _self.reputation : reputation // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,badgeCounts: freezed == badgeCounts ? _self.badgeCounts : badgeCounts // ignore: cast_nullable_to_non_nullable
as BadgeCount?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,profileImage: null == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BadgeCountCopyWith<$Res>? get badgeCounts {
    if (_self.badgeCounts == null) {
    return null;
  }

  return $BadgeCountCopyWith<$Res>(_self.badgeCounts!, (value) {
    return _then(_self.copyWith(badgeCounts: value));
  });
}
}


/// @nodoc
mixin _$BadgeCount {

 int get bronze; int get silver; int get gold;
/// Create a copy of BadgeCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgeCountCopyWith<BadgeCount> get copyWith => _$BadgeCountCopyWithImpl<BadgeCount>(this as BadgeCount, _$identity);

  /// Serializes this BadgeCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadgeCount&&(identical(other.bronze, bronze) || other.bronze == bronze)&&(identical(other.silver, silver) || other.silver == silver)&&(identical(other.gold, gold) || other.gold == gold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bronze,silver,gold);

@override
String toString() {
  return 'BadgeCount(bronze: $bronze, silver: $silver, gold: $gold)';
}


}

/// @nodoc
abstract mixin class $BadgeCountCopyWith<$Res>  {
  factory $BadgeCountCopyWith(BadgeCount value, $Res Function(BadgeCount) _then) = _$BadgeCountCopyWithImpl;
@useResult
$Res call({
 int bronze, int silver, int gold
});




}
/// @nodoc
class _$BadgeCountCopyWithImpl<$Res>
    implements $BadgeCountCopyWith<$Res> {
  _$BadgeCountCopyWithImpl(this._self, this._then);

  final BadgeCount _self;
  final $Res Function(BadgeCount) _then;

/// Create a copy of BadgeCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bronze = null,Object? silver = null,Object? gold = null,}) {
  return _then(_self.copyWith(
bronze: null == bronze ? _self.bronze : bronze // ignore: cast_nullable_to_non_nullable
as int,silver: null == silver ? _self.silver : silver // ignore: cast_nullable_to_non_nullable
as int,gold: null == gold ? _self.gold : gold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BadgeCount].
extension BadgeCountPatterns on BadgeCount {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BadgeCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadgeCount() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BadgeCount value)  $default,){
final _that = this;
switch (_that) {
case _BadgeCount():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BadgeCount value)?  $default,){
final _that = this;
switch (_that) {
case _BadgeCount() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int bronze,  int silver,  int gold)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BadgeCount() when $default != null:
return $default(_that.bronze,_that.silver,_that.gold);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int bronze,  int silver,  int gold)  $default,) {final _that = this;
switch (_that) {
case _BadgeCount():
return $default(_that.bronze,_that.silver,_that.gold);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int bronze,  int silver,  int gold)?  $default,) {final _that = this;
switch (_that) {
case _BadgeCount() when $default != null:
return $default(_that.bronze,_that.silver,_that.gold);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BadgeCount implements BadgeCount {
   _BadgeCount({required this.bronze, required this.silver, required this.gold});
  factory _BadgeCount.fromJson(Map<String, dynamic> json) => _$BadgeCountFromJson(json);

@override final  int bronze;
@override final  int silver;
@override final  int gold;

/// Create a copy of BadgeCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgeCountCopyWith<_BadgeCount> get copyWith => __$BadgeCountCopyWithImpl<_BadgeCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BadgeCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadgeCount&&(identical(other.bronze, bronze) || other.bronze == bronze)&&(identical(other.silver, silver) || other.silver == silver)&&(identical(other.gold, gold) || other.gold == gold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bronze,silver,gold);

@override
String toString() {
  return 'BadgeCount(bronze: $bronze, silver: $silver, gold: $gold)';
}


}

/// @nodoc
abstract mixin class _$BadgeCountCopyWith<$Res> implements $BadgeCountCopyWith<$Res> {
  factory _$BadgeCountCopyWith(_BadgeCount value, $Res Function(_BadgeCount) _then) = __$BadgeCountCopyWithImpl;
@override @useResult
$Res call({
 int bronze, int silver, int gold
});




}
/// @nodoc
class __$BadgeCountCopyWithImpl<$Res>
    implements _$BadgeCountCopyWith<$Res> {
  __$BadgeCountCopyWithImpl(this._self, this._then);

  final _BadgeCount _self;
  final $Res Function(_BadgeCount) _then;

/// Create a copy of BadgeCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bronze = null,Object? silver = null,Object? gold = null,}) {
  return _then(_BadgeCount(
bronze: null == bronze ? _self.bronze : bronze // ignore: cast_nullable_to_non_nullable
as int,silver: null == silver ? _self.silver : silver // ignore: cast_nullable_to_non_nullable
as int,gold: null == gold ? _self.gold : gold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
