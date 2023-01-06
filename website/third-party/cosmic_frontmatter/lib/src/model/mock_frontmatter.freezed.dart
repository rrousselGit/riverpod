// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'mock_frontmatter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MockFrontmatter _$MockFrontmatterFromJson(Map<String, dynamic> json) {
  return _MockFrontmatter.fromJson(json);
}

/// @nodoc
mixin _$MockFrontmatter {
  String get title => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get excerpt => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MockFrontmatterCopyWith<MockFrontmatter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MockFrontmatterCopyWith<$Res> {
  factory $MockFrontmatterCopyWith(
          MockFrontmatter value, $Res Function(MockFrontmatter) then) =
      _$MockFrontmatterCopyWithImpl<$Res>;
  $Res call(
      {String title,
      String author,
      String excerpt,
      String category,
      String date});
}

/// @nodoc
class _$MockFrontmatterCopyWithImpl<$Res>
    implements $MockFrontmatterCopyWith<$Res> {
  _$MockFrontmatterCopyWithImpl(this._value, this._then);

  final MockFrontmatter _value;
  // ignore: unused_field
  final $Res Function(MockFrontmatter) _then;

  @override
  $Res call({
    Object? title = freezed,
    Object? author = freezed,
    Object? excerpt = freezed,
    Object? category = freezed,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: author == freezed
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      excerpt: excerpt == freezed
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_MockFrontmatterCopyWith<$Res>
    implements $MockFrontmatterCopyWith<$Res> {
  factory _$$_MockFrontmatterCopyWith(
          _$_MockFrontmatter value, $Res Function(_$_MockFrontmatter) then) =
      __$$_MockFrontmatterCopyWithImpl<$Res>;
  @override
  $Res call(
      {String title,
      String author,
      String excerpt,
      String category,
      String date});
}

/// @nodoc
class __$$_MockFrontmatterCopyWithImpl<$Res>
    extends _$MockFrontmatterCopyWithImpl<$Res>
    implements _$$_MockFrontmatterCopyWith<$Res> {
  __$$_MockFrontmatterCopyWithImpl(
      _$_MockFrontmatter _value, $Res Function(_$_MockFrontmatter) _then)
      : super(_value, (v) => _then(v as _$_MockFrontmatter));

  @override
  _$_MockFrontmatter get _value => super._value as _$_MockFrontmatter;

  @override
  $Res call({
    Object? title = freezed,
    Object? author = freezed,
    Object? excerpt = freezed,
    Object? category = freezed,
    Object? date = freezed,
  }) {
    return _then(_$_MockFrontmatter(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: author == freezed
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      excerpt: excerpt == freezed
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MockFrontmatter extends _MockFrontmatter {
  const _$_MockFrontmatter(
      {required this.title,
      required this.author,
      required this.excerpt,
      required this.category,
      required this.date})
      : super._();

  factory _$_MockFrontmatter.fromJson(Map<String, dynamic> json) =>
      _$$_MockFrontmatterFromJson(json);

  @override
  final String title;
  @override
  final String author;
  @override
  final String excerpt;
  @override
  final String category;
  @override
  final String date;

  @override
  String toString() {
    return 'MockFrontmatter(title: $title, author: $author, excerpt: $excerpt, category: $category, date: $date)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MockFrontmatter &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.author, author) &&
            const DeepCollectionEquality().equals(other.excerpt, excerpt) &&
            const DeepCollectionEquality().equals(other.category, category) &&
            const DeepCollectionEquality().equals(other.date, date));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(author),
      const DeepCollectionEquality().hash(excerpt),
      const DeepCollectionEquality().hash(category),
      const DeepCollectionEquality().hash(date));

  @JsonKey(ignore: true)
  @override
  _$$_MockFrontmatterCopyWith<_$_MockFrontmatter> get copyWith =>
      __$$_MockFrontmatterCopyWithImpl<_$_MockFrontmatter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MockFrontmatterToJson(
      this,
    );
  }
}

abstract class _MockFrontmatter extends MockFrontmatter {
  const factory _MockFrontmatter(
      {required final String title,
      required final String author,
      required final String excerpt,
      required final String category,
      required final String date}) = _$_MockFrontmatter;
  const _MockFrontmatter._() : super._();

  factory _MockFrontmatter.fromJson(Map<String, dynamic> json) =
      _$_MockFrontmatter.fromJson;

  @override
  String get title;
  @override
  String get author;
  @override
  String get excerpt;
  @override
  String get category;
  @override
  String get date;
  @override
  @JsonKey(ignore: true)
  _$$_MockFrontmatterCopyWith<_$_MockFrontmatter> get copyWith =>
      throw _privateConstructorUsedError;
}
