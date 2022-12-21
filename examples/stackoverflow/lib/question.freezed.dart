// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
      _$QuestionsResponseCopyWithImpl<$Res>;
  $Res call({List<Question> items, int total});
}

/// @nodoc
class _$QuestionsResponseCopyWithImpl<$Res>
    implements $QuestionsResponseCopyWith<$Res> {
  _$QuestionsResponseCopyWithImpl(this._value, this._then);

  final QuestionsResponse _value;
  // ignore: unused_field
  final $Res Function(QuestionsResponse) _then;

  @override
  $Res call({
    Object? items = freezed,
    Object? total = freezed,
  }) {
    return _then(_value.copyWith(
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      total: total == freezed
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$_QuestionsResponseCopyWith<$Res>
    implements $QuestionsResponseCopyWith<$Res> {
  factory _$$_QuestionsResponseCopyWith(_$_QuestionsResponse value,
          $Res Function(_$_QuestionsResponse) then) =
      __$$_QuestionsResponseCopyWithImpl<$Res>;
  @override
  $Res call({List<Question> items, int total});
}

/// @nodoc
class __$$_QuestionsResponseCopyWithImpl<$Res>
    extends _$QuestionsResponseCopyWithImpl<$Res>
    implements _$$_QuestionsResponseCopyWith<$Res> {
  __$$_QuestionsResponseCopyWithImpl(
      _$_QuestionsResponse _value, $Res Function(_$_QuestionsResponse) _then)
      : super(_value, (v) => _then(v as _$_QuestionsResponse));

  @override
  _$_QuestionsResponse get _value => super._value as _$_QuestionsResponse;

  @override
  $Res call({
    Object? items = freezed,
    Object? total = freezed,
  }) {
    return _then(_$_QuestionsResponse(
      items: items == freezed
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      total: total == freezed
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_QuestionsResponse implements _QuestionsResponse {
  _$_QuestionsResponse(
      {required final List<Question> items, required this.total})
      : _items = items;

  factory _$_QuestionsResponse.fromJson(Map<String, dynamic> json) =>
      _$$_QuestionsResponseFromJson(json);

  final List<Question> _items;
  @override
  List<Question> get items {
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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_QuestionsResponse &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other.total, total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(total));

  @JsonKey(ignore: true)
  @override
  _$$_QuestionsResponseCopyWith<_$_QuestionsResponse> get copyWith =>
      __$$_QuestionsResponseCopyWithImpl<_$_QuestionsResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_QuestionsResponseToJson(
      this,
    );
  }
}

abstract class _QuestionsResponse implements QuestionsResponse {
  factory _QuestionsResponse(
      {required final List<Question> items,
      required final int total}) = _$_QuestionsResponse;

  factory _QuestionsResponse.fromJson(Map<String, dynamic> json) =
      _$_QuestionsResponse.fromJson;

  @override
  List<Question> get items;
  @override
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$_QuestionsResponseCopyWith<_$_QuestionsResponse> get copyWith =>
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
      _$QuestionCopyWithImpl<$Res>;
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
class _$QuestionCopyWithImpl<$Res> implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._value, this._then);

  final Question _value;
  // ignore: unused_field
  final $Res Function(Question) _then;

  @override
  $Res call({
    Object? tags = freezed,
    Object? viewCount = freezed,
    Object? score = freezed,
    Object? bountyAmount = freezed,
    Object? acceptedAnswerId = freezed,
    Object? owner = freezed,
    Object? answerCount = freezed,
    Object? creationDate = freezed,
    Object? questionId = freezed,
    Object? link = freezed,
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(_value.copyWith(
      tags: tags == freezed
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      viewCount: viewCount == freezed
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      score: score == freezed
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      bountyAmount: bountyAmount == freezed
          ? _value.bountyAmount
          : bountyAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      acceptedAnswerId: acceptedAnswerId == freezed
          ? _value.acceptedAnswerId
          : acceptedAnswerId // ignore: cast_nullable_to_non_nullable
              as int?,
      owner: owner == freezed
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as User,
      answerCount: answerCount == freezed
          ? _value.answerCount
          : answerCount // ignore: cast_nullable_to_non_nullable
              as int,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      questionId: questionId == freezed
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as int,
      link: link == freezed
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  $UserCopyWith<$Res> get owner {
    return $UserCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value));
    });
  }
}

/// @nodoc
abstract class _$$_QuestionCopyWith<$Res> implements $QuestionCopyWith<$Res> {
  factory _$$_QuestionCopyWith(
          _$_Question value, $Res Function(_$_Question) then) =
      __$$_QuestionCopyWithImpl<$Res>;
  @override
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
class __$$_QuestionCopyWithImpl<$Res> extends _$QuestionCopyWithImpl<$Res>
    implements _$$_QuestionCopyWith<$Res> {
  __$$_QuestionCopyWithImpl(
      _$_Question _value, $Res Function(_$_Question) _then)
      : super(_value, (v) => _then(v as _$_Question));

  @override
  _$_Question get _value => super._value as _$_Question;

  @override
  $Res call({
    Object? tags = freezed,
    Object? viewCount = freezed,
    Object? score = freezed,
    Object? bountyAmount = freezed,
    Object? acceptedAnswerId = freezed,
    Object? owner = freezed,
    Object? answerCount = freezed,
    Object? creationDate = freezed,
    Object? questionId = freezed,
    Object? link = freezed,
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(_$_Question(
      tags: tags == freezed
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      viewCount: viewCount == freezed
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      score: score == freezed
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      bountyAmount: bountyAmount == freezed
          ? _value.bountyAmount
          : bountyAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      acceptedAnswerId: acceptedAnswerId == freezed
          ? _value.acceptedAnswerId
          : acceptedAnswerId // ignore: cast_nullable_to_non_nullable
              as int?,
      owner: owner == freezed
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as User,
      answerCount: answerCount == freezed
          ? _value.answerCount
          : answerCount // ignore: cast_nullable_to_non_nullable
              as int,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      questionId: questionId == freezed
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as int,
      link: link == freezed
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_Question implements _Question {
  _$_Question(
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

  factory _$_Question.fromJson(Map<String, dynamic> json) =>
      _$$_QuestionFromJson(json);

  final List<String> _tags;
  @override
  List<String> get tags {
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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Question &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other.viewCount, viewCount) &&
            const DeepCollectionEquality().equals(other.score, score) &&
            const DeepCollectionEquality()
                .equals(other.bountyAmount, bountyAmount) &&
            const DeepCollectionEquality()
                .equals(other.acceptedAnswerId, acceptedAnswerId) &&
            const DeepCollectionEquality().equals(other.owner, owner) &&
            const DeepCollectionEquality()
                .equals(other.answerCount, answerCount) &&
            const DeepCollectionEquality()
                .equals(other.creationDate, creationDate) &&
            const DeepCollectionEquality()
                .equals(other.questionId, questionId) &&
            const DeepCollectionEquality().equals(other.link, link) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.body, body));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(viewCount),
      const DeepCollectionEquality().hash(score),
      const DeepCollectionEquality().hash(bountyAmount),
      const DeepCollectionEquality().hash(acceptedAnswerId),
      const DeepCollectionEquality().hash(owner),
      const DeepCollectionEquality().hash(answerCount),
      const DeepCollectionEquality().hash(creationDate),
      const DeepCollectionEquality().hash(questionId),
      const DeepCollectionEquality().hash(link),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(body));

  @JsonKey(ignore: true)
  @override
  _$$_QuestionCopyWith<_$_Question> get copyWith =>
      __$$_QuestionCopyWithImpl<_$_Question>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_QuestionToJson(
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
      required final String body}) = _$_Question;

  factory _Question.fromJson(Map<String, dynamic> json) = _$_Question.fromJson;

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
  _$$_QuestionCopyWith<_$_Question> get copyWith =>
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
      _$QuestionThemeCopyWithImpl<$Res>;
  $Res call({TextStyle titleStyle, TextStyle descriptionStyle});
}

/// @nodoc
class _$QuestionThemeCopyWithImpl<$Res>
    implements $QuestionThemeCopyWith<$Res> {
  _$QuestionThemeCopyWithImpl(this._value, this._then);

  final QuestionTheme _value;
  // ignore: unused_field
  final $Res Function(QuestionTheme) _then;

  @override
  $Res call({
    Object? titleStyle = freezed,
    Object? descriptionStyle = freezed,
  }) {
    return _then(_value.copyWith(
      titleStyle: titleStyle == freezed
          ? _value.titleStyle
          : titleStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle,
      descriptionStyle: descriptionStyle == freezed
          ? _value.descriptionStyle
          : descriptionStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle,
    ));
  }
}

/// @nodoc
abstract class _$$_QuestionThemeCopyWith<$Res>
    implements $QuestionThemeCopyWith<$Res> {
  factory _$$_QuestionThemeCopyWith(
          _$_QuestionTheme value, $Res Function(_$_QuestionTheme) then) =
      __$$_QuestionThemeCopyWithImpl<$Res>;
  @override
  $Res call({TextStyle titleStyle, TextStyle descriptionStyle});
}

/// @nodoc
class __$$_QuestionThemeCopyWithImpl<$Res>
    extends _$QuestionThemeCopyWithImpl<$Res>
    implements _$$_QuestionThemeCopyWith<$Res> {
  __$$_QuestionThemeCopyWithImpl(
      _$_QuestionTheme _value, $Res Function(_$_QuestionTheme) _then)
      : super(_value, (v) => _then(v as _$_QuestionTheme));

  @override
  _$_QuestionTheme get _value => super._value as _$_QuestionTheme;

  @override
  $Res call({
    Object? titleStyle = freezed,
    Object? descriptionStyle = freezed,
  }) {
    return _then(_$_QuestionTheme(
      titleStyle: titleStyle == freezed
          ? _value.titleStyle
          : titleStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle,
      descriptionStyle: descriptionStyle == freezed
          ? _value.descriptionStyle
          : descriptionStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle,
    ));
  }
}

/// @nodoc

class _$_QuestionTheme implements _QuestionTheme {
  const _$_QuestionTheme(
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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_QuestionTheme &&
            const DeepCollectionEquality()
                .equals(other.titleStyle, titleStyle) &&
            const DeepCollectionEquality()
                .equals(other.descriptionStyle, descriptionStyle));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(titleStyle),
      const DeepCollectionEquality().hash(descriptionStyle));

  @JsonKey(ignore: true)
  @override
  _$$_QuestionThemeCopyWith<_$_QuestionTheme> get copyWith =>
      __$$_QuestionThemeCopyWithImpl<_$_QuestionTheme>(this, _$identity);
}

abstract class _QuestionTheme implements QuestionTheme {
  const factory _QuestionTheme(
      {required final TextStyle titleStyle,
      required final TextStyle descriptionStyle}) = _$_QuestionTheme;

  @override
  TextStyle get titleStyle;
  @override
  TextStyle get descriptionStyle;
  @override
  @JsonKey(ignore: true)
  _$$_QuestionThemeCopyWith<_$_QuestionTheme> get copyWith =>
      throw _privateConstructorUsedError;
}
