// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionsResponse {

 List<Question> get items; int get total;
/// Create a copy of QuestionsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionsResponseCopyWith<QuestionsResponse> get copyWith => _$QuestionsResponseCopyWithImpl<QuestionsResponse>(this as QuestionsResponse, _$identity);

  /// Serializes this QuestionsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionsResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total);

@override
String toString() {
  return 'QuestionsResponse(items: $items, total: $total)';
}


}

/// @nodoc
abstract mixin class $QuestionsResponseCopyWith<$Res>  {
  factory $QuestionsResponseCopyWith(QuestionsResponse value, $Res Function(QuestionsResponse) _then) = _$QuestionsResponseCopyWithImpl;
@useResult
$Res call({
 List<Question> items, int total
});




}
/// @nodoc
class _$QuestionsResponseCopyWithImpl<$Res>
    implements $QuestionsResponseCopyWith<$Res> {
  _$QuestionsResponseCopyWithImpl(this._self, this._then);

  final QuestionsResponse _self;
  final $Res Function(QuestionsResponse) _then;

/// Create a copy of QuestionsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Question>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionsResponse].
extension QuestionsResponsePatterns on QuestionsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionsResponse value)  $default,){
final _that = this;
switch (_that) {
case _QuestionsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Question> items,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionsResponse() when $default != null:
return $default(_that.items,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Question> items,  int total)  $default,) {final _that = this;
switch (_that) {
case _QuestionsResponse():
return $default(_that.items,_that.total);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Question> items,  int total)?  $default,) {final _that = this;
switch (_that) {
case _QuestionsResponse() when $default != null:
return $default(_that.items,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionsResponse implements QuestionsResponse {
   _QuestionsResponse({required final  List<Question> items, required this.total}): _items = items;
  factory _QuestionsResponse.fromJson(Map<String, dynamic> json) => _$QuestionsResponseFromJson(json);

 final  List<Question> _items;
@override List<Question> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int total;

/// Create a copy of QuestionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionsResponseCopyWith<_QuestionsResponse> get copyWith => __$QuestionsResponseCopyWithImpl<_QuestionsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionsResponse&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total);

@override
String toString() {
  return 'QuestionsResponse(items: $items, total: $total)';
}


}

/// @nodoc
abstract mixin class _$QuestionsResponseCopyWith<$Res> implements $QuestionsResponseCopyWith<$Res> {
  factory _$QuestionsResponseCopyWith(_QuestionsResponse value, $Res Function(_QuestionsResponse) _then) = __$QuestionsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Question> items, int total
});




}
/// @nodoc
class __$QuestionsResponseCopyWithImpl<$Res>
    implements _$QuestionsResponseCopyWith<$Res> {
  __$QuestionsResponseCopyWithImpl(this._self, this._then);

  final _QuestionsResponse _self;
  final $Res Function(_QuestionsResponse) _then;

/// Create a copy of QuestionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,}) {
  return _then(_QuestionsResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Question>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Question {

 List<String> get tags; int get viewCount; int get score; int? get bountyAmount; int? get acceptedAnswerId; User get owner; int get answerCount;@TimestampParser() DateTime get creationDate; int get questionId; String get link; String get title; String get body;
/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionCopyWith<Question> get copyWith => _$QuestionCopyWithImpl<Question>(this as Question, _$identity);

  /// Serializes this Question to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Question&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.score, score) || other.score == score)&&(identical(other.bountyAmount, bountyAmount) || other.bountyAmount == bountyAmount)&&(identical(other.acceptedAnswerId, acceptedAnswerId) || other.acceptedAnswerId == acceptedAnswerId)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.answerCount, answerCount) || other.answerCount == answerCount)&&(identical(other.creationDate, creationDate) || other.creationDate == creationDate)&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.link, link) || other.link == link)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tags),viewCount,score,bountyAmount,acceptedAnswerId,owner,answerCount,creationDate,questionId,link,title,body);

@override
String toString() {
  return 'Question(tags: $tags, viewCount: $viewCount, score: $score, bountyAmount: $bountyAmount, acceptedAnswerId: $acceptedAnswerId, owner: $owner, answerCount: $answerCount, creationDate: $creationDate, questionId: $questionId, link: $link, title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class $QuestionCopyWith<$Res>  {
  factory $QuestionCopyWith(Question value, $Res Function(Question) _then) = _$QuestionCopyWithImpl;
@useResult
$Res call({
 List<String> tags, int viewCount, int score, int? bountyAmount, int? acceptedAnswerId, User owner, int answerCount,@TimestampParser() DateTime creationDate, int questionId, String link, String title, String body
});


$UserCopyWith<$Res> get owner;

}
/// @nodoc
class _$QuestionCopyWithImpl<$Res>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._self, this._then);

  final Question _self;
  final $Res Function(Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tags = null,Object? viewCount = null,Object? score = null,Object? bountyAmount = freezed,Object? acceptedAnswerId = freezed,Object? owner = null,Object? answerCount = null,Object? creationDate = null,Object? questionId = null,Object? link = null,Object? title = null,Object? body = null,}) {
  return _then(_self.copyWith(
tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,bountyAmount: freezed == bountyAmount ? _self.bountyAmount : bountyAmount // ignore: cast_nullable_to_non_nullable
as int?,acceptedAnswerId: freezed == acceptedAnswerId ? _self.acceptedAnswerId : acceptedAnswerId // ignore: cast_nullable_to_non_nullable
as int?,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as User,answerCount: null == answerCount ? _self.answerCount : answerCount // ignore: cast_nullable_to_non_nullable
as int,creationDate: null == creationDate ? _self.creationDate : creationDate // ignore: cast_nullable_to_non_nullable
as DateTime,questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get owner {
  
  return $UserCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// Adds pattern-matching-related methods to [Question].
extension QuestionPatterns on Question {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Question value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Question() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Question value)  $default,){
final _that = this;
switch (_that) {
case _Question():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Question value)?  $default,){
final _that = this;
switch (_that) {
case _Question() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> tags,  int viewCount,  int score,  int? bountyAmount,  int? acceptedAnswerId,  User owner,  int answerCount, @TimestampParser()  DateTime creationDate,  int questionId,  String link,  String title,  String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.tags,_that.viewCount,_that.score,_that.bountyAmount,_that.acceptedAnswerId,_that.owner,_that.answerCount,_that.creationDate,_that.questionId,_that.link,_that.title,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> tags,  int viewCount,  int score,  int? bountyAmount,  int? acceptedAnswerId,  User owner,  int answerCount, @TimestampParser()  DateTime creationDate,  int questionId,  String link,  String title,  String body)  $default,) {final _that = this;
switch (_that) {
case _Question():
return $default(_that.tags,_that.viewCount,_that.score,_that.bountyAmount,_that.acceptedAnswerId,_that.owner,_that.answerCount,_that.creationDate,_that.questionId,_that.link,_that.title,_that.body);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> tags,  int viewCount,  int score,  int? bountyAmount,  int? acceptedAnswerId,  User owner,  int answerCount, @TimestampParser()  DateTime creationDate,  int questionId,  String link,  String title,  String body)?  $default,) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.tags,_that.viewCount,_that.score,_that.bountyAmount,_that.acceptedAnswerId,_that.owner,_that.answerCount,_that.creationDate,_that.questionId,_that.link,_that.title,_that.body);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Question implements Question {
   _Question({required final  List<String> tags, required this.viewCount, required this.score, this.bountyAmount, this.acceptedAnswerId, required this.owner, required this.answerCount, @TimestampParser() required this.creationDate, required this.questionId, required this.link, required this.title, required this.body}): _tags = tags;
  factory _Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  int viewCount;
@override final  int score;
@override final  int? bountyAmount;
@override final  int? acceptedAnswerId;
@override final  User owner;
@override final  int answerCount;
@override@TimestampParser() final  DateTime creationDate;
@override final  int questionId;
@override final  String link;
@override final  String title;
@override final  String body;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionCopyWith<_Question> get copyWith => __$QuestionCopyWithImpl<_Question>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Question&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.score, score) || other.score == score)&&(identical(other.bountyAmount, bountyAmount) || other.bountyAmount == bountyAmount)&&(identical(other.acceptedAnswerId, acceptedAnswerId) || other.acceptedAnswerId == acceptedAnswerId)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.answerCount, answerCount) || other.answerCount == answerCount)&&(identical(other.creationDate, creationDate) || other.creationDate == creationDate)&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.link, link) || other.link == link)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tags),viewCount,score,bountyAmount,acceptedAnswerId,owner,answerCount,creationDate,questionId,link,title,body);

@override
String toString() {
  return 'Question(tags: $tags, viewCount: $viewCount, score: $score, bountyAmount: $bountyAmount, acceptedAnswerId: $acceptedAnswerId, owner: $owner, answerCount: $answerCount, creationDate: $creationDate, questionId: $questionId, link: $link, title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class _$QuestionCopyWith<$Res> implements $QuestionCopyWith<$Res> {
  factory _$QuestionCopyWith(_Question value, $Res Function(_Question) _then) = __$QuestionCopyWithImpl;
@override @useResult
$Res call({
 List<String> tags, int viewCount, int score, int? bountyAmount, int? acceptedAnswerId, User owner, int answerCount,@TimestampParser() DateTime creationDate, int questionId, String link, String title, String body
});


@override $UserCopyWith<$Res> get owner;

}
/// @nodoc
class __$QuestionCopyWithImpl<$Res>
    implements _$QuestionCopyWith<$Res> {
  __$QuestionCopyWithImpl(this._self, this._then);

  final _Question _self;
  final $Res Function(_Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tags = null,Object? viewCount = null,Object? score = null,Object? bountyAmount = freezed,Object? acceptedAnswerId = freezed,Object? owner = null,Object? answerCount = null,Object? creationDate = null,Object? questionId = null,Object? link = null,Object? title = null,Object? body = null,}) {
  return _then(_Question(
tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,bountyAmount: freezed == bountyAmount ? _self.bountyAmount : bountyAmount // ignore: cast_nullable_to_non_nullable
as int?,acceptedAnswerId: freezed == acceptedAnswerId ? _self.acceptedAnswerId : acceptedAnswerId // ignore: cast_nullable_to_non_nullable
as int?,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as User,answerCount: null == answerCount ? _self.answerCount : answerCount // ignore: cast_nullable_to_non_nullable
as int,creationDate: null == creationDate ? _self.creationDate : creationDate // ignore: cast_nullable_to_non_nullable
as DateTime,questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get owner {
  
  return $UserCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}

/// @nodoc
mixin _$QuestionTheme {

 TextStyle get titleStyle; TextStyle get descriptionStyle;
/// Create a copy of QuestionTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionThemeCopyWith<QuestionTheme> get copyWith => _$QuestionThemeCopyWithImpl<QuestionTheme>(this as QuestionTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionTheme&&(identical(other.titleStyle, titleStyle) || other.titleStyle == titleStyle)&&(identical(other.descriptionStyle, descriptionStyle) || other.descriptionStyle == descriptionStyle));
}


@override
int get hashCode => Object.hash(runtimeType,titleStyle,descriptionStyle);

@override
String toString() {
  return 'QuestionTheme(titleStyle: $titleStyle, descriptionStyle: $descriptionStyle)';
}


}

/// @nodoc
abstract mixin class $QuestionThemeCopyWith<$Res>  {
  factory $QuestionThemeCopyWith(QuestionTheme value, $Res Function(QuestionTheme) _then) = _$QuestionThemeCopyWithImpl;
@useResult
$Res call({
 TextStyle titleStyle, TextStyle descriptionStyle
});




}
/// @nodoc
class _$QuestionThemeCopyWithImpl<$Res>
    implements $QuestionThemeCopyWith<$Res> {
  _$QuestionThemeCopyWithImpl(this._self, this._then);

  final QuestionTheme _self;
  final $Res Function(QuestionTheme) _then;

/// Create a copy of QuestionTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleStyle = null,Object? descriptionStyle = null,}) {
  return _then(_self.copyWith(
titleStyle: null == titleStyle ? _self.titleStyle : titleStyle // ignore: cast_nullable_to_non_nullable
as TextStyle,descriptionStyle: null == descriptionStyle ? _self.descriptionStyle : descriptionStyle // ignore: cast_nullable_to_non_nullable
as TextStyle,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionTheme].
extension QuestionThemePatterns on QuestionTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionTheme value)  $default,){
final _that = this;
switch (_that) {
case _QuestionTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionTheme value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TextStyle titleStyle,  TextStyle descriptionStyle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionTheme() when $default != null:
return $default(_that.titleStyle,_that.descriptionStyle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TextStyle titleStyle,  TextStyle descriptionStyle)  $default,) {final _that = this;
switch (_that) {
case _QuestionTheme():
return $default(_that.titleStyle,_that.descriptionStyle);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TextStyle titleStyle,  TextStyle descriptionStyle)?  $default,) {final _that = this;
switch (_that) {
case _QuestionTheme() when $default != null:
return $default(_that.titleStyle,_that.descriptionStyle);case _:
  return null;

}
}

}

/// @nodoc


class _QuestionTheme implements QuestionTheme {
  const _QuestionTheme({required this.titleStyle, required this.descriptionStyle});
  

@override final  TextStyle titleStyle;
@override final  TextStyle descriptionStyle;

/// Create a copy of QuestionTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionThemeCopyWith<_QuestionTheme> get copyWith => __$QuestionThemeCopyWithImpl<_QuestionTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionTheme&&(identical(other.titleStyle, titleStyle) || other.titleStyle == titleStyle)&&(identical(other.descriptionStyle, descriptionStyle) || other.descriptionStyle == descriptionStyle));
}


@override
int get hashCode => Object.hash(runtimeType,titleStyle,descriptionStyle);

@override
String toString() {
  return 'QuestionTheme(titleStyle: $titleStyle, descriptionStyle: $descriptionStyle)';
}


}

/// @nodoc
abstract mixin class _$QuestionThemeCopyWith<$Res> implements $QuestionThemeCopyWith<$Res> {
  factory _$QuestionThemeCopyWith(_QuestionTheme value, $Res Function(_QuestionTheme) _then) = __$QuestionThemeCopyWithImpl;
@override @useResult
$Res call({
 TextStyle titleStyle, TextStyle descriptionStyle
});




}
/// @nodoc
class __$QuestionThemeCopyWithImpl<$Res>
    implements _$QuestionThemeCopyWith<$Res> {
  __$QuestionThemeCopyWithImpl(this._self, this._then);

  final _QuestionTheme _self;
  final $Res Function(_QuestionTheme) _then;

/// Create a copy of QuestionTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleStyle = null,Object? descriptionStyle = null,}) {
  return _then(_QuestionTheme(
titleStyle: null == titleStyle ? _self.titleStyle : titleStyle // ignore: cast_nullable_to_non_nullable
as TextStyle,descriptionStyle: null == descriptionStyle ? _self.descriptionStyle : descriptionStyle // ignore: cast_nullable_to_non_nullable
as TextStyle,
  ));
}


}

// dart format on
