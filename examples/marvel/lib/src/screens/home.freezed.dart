// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CharacterPagination {
  int get page => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CharacterPaginationCopyWith<CharacterPagination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterPaginationCopyWith<$Res> {
  factory $CharacterPaginationCopyWith(
          CharacterPagination value, $Res Function(CharacterPagination) then) =
      _$CharacterPaginationCopyWithImpl<$Res, CharacterPagination>;
  @useResult
  $Res call({int page, String? name});
}

/// @nodoc
class _$CharacterPaginationCopyWithImpl<$Res, $Val extends CharacterPagination>
    implements $CharacterPaginationCopyWith<$Res> {
  _$CharacterPaginationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CharacterPaginationImplCopyWith<$Res>
    implements $CharacterPaginationCopyWith<$Res> {
  factory _$$CharacterPaginationImplCopyWith(_$CharacterPaginationImpl value,
          $Res Function(_$CharacterPaginationImpl) then) =
      __$$CharacterPaginationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int page, String? name});
}

/// @nodoc
class __$$CharacterPaginationImplCopyWithImpl<$Res>
    extends _$CharacterPaginationCopyWithImpl<$Res, _$CharacterPaginationImpl>
    implements _$$CharacterPaginationImplCopyWith<$Res> {
  __$$CharacterPaginationImplCopyWithImpl(_$CharacterPaginationImpl _value,
      $Res Function(_$CharacterPaginationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? name = freezed,
  }) {
    return _then(_$CharacterPaginationImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CharacterPaginationImpl implements _CharacterPagination {
  _$CharacterPaginationImpl({required this.page, this.name});

  @override
  final int page;
  @override
  final String? name;

  @override
  String toString() {
    return 'CharacterPagination(page: $page, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterPaginationImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, page, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterPaginationImplCopyWith<_$CharacterPaginationImpl> get copyWith =>
      __$$CharacterPaginationImplCopyWithImpl<_$CharacterPaginationImpl>(
          this, _$identity);
}

abstract class _CharacterPagination implements CharacterPagination {
  factory _CharacterPagination({required final int page, final String? name}) =
      _$CharacterPaginationImpl;

  @override
  int get page;
  @override
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$CharacterPaginationImplCopyWith<_$CharacterPaginationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CharacterOffset {
  int get offset => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CharacterOffsetCopyWith<CharacterOffset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterOffsetCopyWith<$Res> {
  factory $CharacterOffsetCopyWith(
          CharacterOffset value, $Res Function(CharacterOffset) then) =
      _$CharacterOffsetCopyWithImpl<$Res, CharacterOffset>;
  @useResult
  $Res call({int offset, String name});
}

/// @nodoc
class _$CharacterOffsetCopyWithImpl<$Res, $Val extends CharacterOffset>
    implements $CharacterOffsetCopyWith<$Res> {
  _$CharacterOffsetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CharacterOffsetImplCopyWith<$Res>
    implements $CharacterOffsetCopyWith<$Res> {
  factory _$$CharacterOffsetImplCopyWith(_$CharacterOffsetImpl value,
          $Res Function(_$CharacterOffsetImpl) then) =
      __$$CharacterOffsetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int offset, String name});
}

/// @nodoc
class __$$CharacterOffsetImplCopyWithImpl<$Res>
    extends _$CharacterOffsetCopyWithImpl<$Res, _$CharacterOffsetImpl>
    implements _$$CharacterOffsetImplCopyWith<$Res> {
  __$$CharacterOffsetImplCopyWithImpl(
      _$CharacterOffsetImpl _value, $Res Function(_$CharacterOffsetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? name = null,
  }) {
    return _then(_$CharacterOffsetImpl(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CharacterOffsetImpl implements _CharacterOffset {
  _$CharacterOffsetImpl({required this.offset, this.name = ''});

  @override
  final int offset;
  @override
  @JsonKey()
  final String name;

  @override
  String toString() {
    return 'CharacterOffset(offset: $offset, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterOffsetImpl &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, offset, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterOffsetImplCopyWith<_$CharacterOffsetImpl> get copyWith =>
      __$$CharacterOffsetImplCopyWithImpl<_$CharacterOffsetImpl>(
          this, _$identity);
}

abstract class _CharacterOffset implements CharacterOffset {
  factory _CharacterOffset({required final int offset, final String name}) =
      _$CharacterOffsetImpl;

  @override
  int get offset;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$CharacterOffsetImplCopyWith<_$CharacterOffsetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
