// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionsResponse _$QuestionsResponseFromJson(Map<String, dynamic> json) {
  return _QuestionsResponse.fromJson(json);
}

/// @nodoc
mixin _$QuestionsResponse {
  List<Question> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionsResponseCopyWith<QuestionsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionsResponseCopyWith<$Res> {
  factory $QuestionsResponseCopyWith(
          QuestionsResponse value, $Res Function(QuestionsResponse) then) =
      _$QuestionsResponseCopyWithImpl<$Res, QuestionsResponse>;
  @useResult
  $Res call({List<Question> items, int total});
}

/// @nodoc
class _$QuestionsResponseCopyWithImpl<$Res, $Val extends QuestionsResponse>
    implements $QuestionsResponseCopyWith<$Res> {
  _$QuestionsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionsResponseImplCopyWith<$Res>
    implements $QuestionsResponseCopyWith<$Res> {
  factory _$$QuestionsResponseImplCopyWith(_$QuestionsResponseImpl value,
          $Res Function(_$QuestionsResponseImpl) then) =
      __$$QuestionsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Question> items, int total});
}

/// @nodoc
class __$$QuestionsResponseImplCopyWithImpl<$Res>
    extends _$QuestionsResponseCopyWithImpl<$Res, _$QuestionsResponseImpl>
    implements _$$QuestionsResponseImplCopyWith<$Res> {
  __$$QuestionsResponseImplCopyWithImpl(_$QuestionsResponseImpl _value,
      $Res Function(_$QuestionsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
  }) {
    return _then(_$QuestionsResponseImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionsResponseImpl implements _QuestionsResponse {
  _$QuestionsResponseImpl(
      {required final List<Question> items, required this.total})
      : _items = items;

  factory _$QuestionsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionsResponseImplFromJson(json);

  final List<Question> _items;
  @override
  List<Question> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int total;

  @override
  String toString() {
    return 'QuestionsResponse(items: $items, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionsResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionsResponseImplCopyWith<_$QuestionsResponseImpl> get copyWith =>
      __$$QuestionsResponseImplCopyWithImpl<_$QuestionsResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionsResponseImplToJson(
      this,
    );
  }
}

abstract class _QuestionsResponse implements QuestionsResponse {
  factory _QuestionsResponse(
      {required final List<Question> items,
      required final int total}) = _$QuestionsResponseImpl;

  factory _QuestionsResponse.fromJson(Map<String, dynamic> json) =
      _$QuestionsResponseImpl.fromJson;

  @override
  List<Question> get items;
  @override
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$QuestionsResponseImplCopyWith<_$QuestionsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return _Question.fromJson(json);
}

/// @nodoc
mixin _$Question {
  List<String> get tags => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  int? get bountyAmount => throw _privateConstructorUsedError;
  int? get acceptedAnswerId => throw _privateConstructorUsedError;
  User get owner => throw _privateConstructorUsedError;
  int get answerCount => throw _privateConstructorUsedError;
  @TimestampParser()
  DateTime get creationDate => throw _privateConstructorUsedError;
  int get questionId => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionCopyWith<Question> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) then) =
      _$QuestionCopyWithImpl<$Res, Question>;
  @useResult
  $Res call(
      {List<String> tags,
      int viewCount,
      int score,
      int? bountyAmount,
      int? acceptedAnswerId,
      User owner,
      int answerCount,
      @TimestampParser() DateTime creationDate,
      int questionId,
      String link,
      String title,
      String body});

  $UserCopyWith<$Res> get owner;
}

/// @nodoc
class _$QuestionCopyWithImpl<$Res, $Val extends Question>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tags = null,
    Object? viewCount = null,
    Object? score = null,
    Object? bountyAmount = freezed,
    Object? acceptedAnswerId = freezed,
    Object? owner = null,
    Object? answerCount = null,
    Object? creationDate = null,
    Object? questionId = null,
    Object? link = null,
    Object? title = null,
    Object? body = null,
  }) {
    return _then(_value.copyWith(
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      bountyAmount: freezed == bountyAmount
          ? _value.bountyAmount
          : bountyAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      acceptedAnswerId: freezed == acceptedAnswerId
          ? _value.acceptedAnswerId
          : acceptedAnswerId // ignore: cast_nullable_to_non_nullable
              as int?,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as User,
      answerCount: null == answerCount
          ? _value.answerCount
          : answerCount // ignore: cast_nullable_to_non_nullable
              as int,
      creationDate: null == creationDate
          ? _value.creationDate
          : creationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as int,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get owner {
    return $UserCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestionImplCopyWith<$Res>
    implements $QuestionCopyWith<$Res> {
  factory _$$QuestionImplCopyWith(
          _$QuestionImpl value, $Res Function(_$QuestionImpl) then) =
      __$$QuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> tags,
      int viewCount,
      int score,
      int? bountyAmount,
      int? acceptedAnswerId,
      User owner,
      int answerCount,
      @TimestampParser() DateTime creationDate,
      int questionId,
      String link,
      String title,
      String body});

  @override
  $UserCopyWith<$Res> get owner;
}

/// @nodoc
class __$$QuestionImplCopyWithImpl<$Res>
    extends _$QuestionCopyWithImpl<$Res, _$QuestionImpl>
    implements _$$QuestionImplCopyWith<$Res> {
  __$$QuestionImplCopyWithImpl(
      _$QuestionImpl _value, $Res Function(_$QuestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tags = null,
    Object? viewCount = null,
    Object? score = null,
    Object? bountyAmount = freezed,
    Object? acceptedAnswerId = freezed,
    Object? owner = null,
    Object? answerCount = null,
    Object? creationDate = null,
    Object? questionId = null,
    Object? link = null,
    Object? title = null,
    Object? body = null,
  }) {
    return _then(_$QuestionImpl(
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      bountyAmount: freezed == bountyAmount
          ? _value.bountyAmount
          : bountyAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      acceptedAnswerId: freezed == acceptedAnswerId
          ? _value.acceptedAnswerId
          : acceptedAnswerId // ignore: cast_nullable_to_non_nullable
              as int?,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as User,
      answerCount: null == answerCount
          ? _value.answerCount
          : answerCount // ignore: cast_nullable_to_non_nullable
              as int,
      creationDate: null == creationDate
          ? _value.creationDate
          : creationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as int,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$QuestionImpl implements _Question {
  _$QuestionImpl(
      {required final List<String> tags,
      required this.viewCount,
      required this.score,
      this.bountyAmount,
      this.acceptedAnswerId,
      required this.owner,
      required this.answerCount,
      @TimestampParser() required this.creationDate,
      required this.questionId,
      required this.link,
      required this.title,
      required this.body})
      : _tags = tags;

  factory _$QuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionImplFromJson(json);

  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final int viewCount;
  @override
  final int score;
  @override
  final int? bountyAmount;
  @override
  final int? acceptedAnswerId;
  @override
  final User owner;
  @override
  final int answerCount;
  @override
  @TimestampParser()
  final DateTime creationDate;
  @override
  final int questionId;
  @override
  final String link;
  @override
  final String title;
  @override
  final String body;

  @override
  String toString() {
    return 'Question(tags: $tags, viewCount: $viewCount, score: $score, bountyAmount: $bountyAmount, acceptedAnswerId: $acceptedAnswerId, owner: $owner, answerCount: $answerCount, creationDate: $creationDate, questionId: $questionId, link: $link, title: $title, body: $body)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionImpl &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.bountyAmount, bountyAmount) ||
                other.bountyAmount == bountyAmount) &&
            (identical(other.acceptedAnswerId, acceptedAnswerId) ||
                other.acceptedAnswerId == acceptedAnswerId) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.answerCount, answerCount) ||
                other.answerCount == answerCount) &&
            (identical(other.creationDate, creationDate) ||
                other.creationDate == creationDate) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tags),
      viewCount,
      score,
      bountyAmount,
      acceptedAnswerId,
      owner,
      answerCount,
      creationDate,
      questionId,
      link,
      title,
      body);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      __$$QuestionImplCopyWithImpl<_$QuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionImplToJson(
      this,
    );
  }
}

abstract class _Question implements Question {
  factory _Question(
      {required final List<String> tags,
      required final int viewCount,
      required final int score,
      final int? bountyAmount,
      final int? acceptedAnswerId,
      required final User owner,
      required final int answerCount,
      @TimestampParser() required final DateTime creationDate,
      required final int questionId,
      required final String link,
      required final String title,
      required final String body}) = _$QuestionImpl;

  factory _Question.fromJson(Map<String, dynamic> json) =
      _$QuestionImpl.fromJson;

  @override
  List<String> get tags;
  @override
  int get viewCount;
  @override
  int get score;
  @override
  int? get bountyAmount;
  @override
  int? get acceptedAnswerId;
  @override
  User get owner;
  @override
  int get answerCount;
  @override
  @TimestampParser()
  DateTime get creationDate;
  @override
  int get questionId;
  @override
  String get link;
  @override
  String get title;
  @override
  String get body;
  @override
  @JsonKey(ignore: true)
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$QuestionTheme {
  TextStyle get titleStyle => throw _privateConstructorUsedError;
  TextStyle get descriptionStyle => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QuestionThemeCopyWith<QuestionTheme> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionThemeCopyWith<$Res> {
  factory $QuestionThemeCopyWith(
          QuestionTheme value, $Res Function(QuestionTheme) then) =
      _$QuestionThemeCopyWithImpl<$Res, QuestionTheme>;
  @useResult
  $Res call({TextStyle titleStyle, TextStyle descriptionStyle});
}

/// @nodoc
class _$QuestionThemeCopyWithImpl<$Res, $Val extends QuestionTheme>
    implements $QuestionThemeCopyWith<$Res> {
  _$QuestionThemeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? titleStyle = null,
    Object? descriptionStyle = null,
  }) {
    return _then(_value.copyWith(
      titleStyle: null == titleStyle
          ? _value.titleStyle
          : titleStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle,
      descriptionStyle: null == descriptionStyle
          ? _value.descriptionStyle
          : descriptionStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionThemeImplCopyWith<$Res>
    implements $QuestionThemeCopyWith<$Res> {
  factory _$$QuestionThemeImplCopyWith(
          _$QuestionThemeImpl value, $Res Function(_$QuestionThemeImpl) then) =
      __$$QuestionThemeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TextStyle titleStyle, TextStyle descriptionStyle});
}

/// @nodoc
class __$$QuestionThemeImplCopyWithImpl<$Res>
    extends _$QuestionThemeCopyWithImpl<$Res, _$QuestionThemeImpl>
    implements _$$QuestionThemeImplCopyWith<$Res> {
  __$$QuestionThemeImplCopyWithImpl(
      _$QuestionThemeImpl _value, $Res Function(_$QuestionThemeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? titleStyle = null,
    Object? descriptionStyle = null,
  }) {
    return _then(_$QuestionThemeImpl(
      titleStyle: null == titleStyle
          ? _value.titleStyle
          : titleStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle,
      descriptionStyle: null == descriptionStyle
          ? _value.descriptionStyle
          : descriptionStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle,
    ));
  }
}

/// @nodoc

class _$QuestionThemeImpl implements _QuestionTheme {
  const _$QuestionThemeImpl(
      {required this.titleStyle, required this.descriptionStyle});

  @override
  final TextStyle titleStyle;
  @override
  final TextStyle descriptionStyle;

  @override
  String toString() {
    return 'QuestionTheme(titleStyle: $titleStyle, descriptionStyle: $descriptionStyle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionThemeImpl &&
            (identical(other.titleStyle, titleStyle) ||
                other.titleStyle == titleStyle) &&
            (identical(other.descriptionStyle, descriptionStyle) ||
                other.descriptionStyle == descriptionStyle));
  }

  @override
  int get hashCode => Object.hash(runtimeType, titleStyle, descriptionStyle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionThemeImplCopyWith<_$QuestionThemeImpl> get copyWith =>
      __$$QuestionThemeImplCopyWithImpl<_$QuestionThemeImpl>(this, _$identity);
}

abstract class _QuestionTheme implements QuestionTheme {
  const factory _QuestionTheme(
      {required final TextStyle titleStyle,
      required final TextStyle descriptionStyle}) = _$QuestionThemeImpl;

  @override
  TextStyle get titleStyle;
  @override
  TextStyle get descriptionStyle;
  @override
  @JsonKey(ignore: true)
  _$$QuestionThemeImplCopyWith<_$QuestionThemeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
