// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'provider_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LegacyProviderDefinition {
  String get name => throw _privateConstructorUsedError;
  bool get isAutoDispose => throw _privateConstructorUsedError;
  DartType? get familyArgumentType => throw _privateConstructorUsedError;
  LegacyProviderType get providerType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LegacyProviderDefinitionCopyWith<LegacyProviderDefinition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LegacyProviderDefinitionCopyWith<$Res> {
  factory $LegacyProviderDefinitionCopyWith(LegacyProviderDefinition value,
          $Res Function(LegacyProviderDefinition) then) =
      _$LegacyProviderDefinitionCopyWithImpl<$Res, LegacyProviderDefinition>;
  @useResult
  $Res call(
      {String name,
      bool isAutoDispose,
      DartType? familyArgumentType,
      LegacyProviderType providerType});
}

/// @nodoc
class _$LegacyProviderDefinitionCopyWithImpl<$Res,
        $Val extends LegacyProviderDefinition>
    implements $LegacyProviderDefinitionCopyWith<$Res> {
  _$LegacyProviderDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? isAutoDispose = null,
    Object? familyArgumentType = freezed,
    Object? providerType = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isAutoDispose: null == isAutoDispose
          ? _value.isAutoDispose
          : isAutoDispose // ignore: cast_nullable_to_non_nullable
              as bool,
      familyArgumentType: freezed == familyArgumentType
          ? _value.familyArgumentType
          : familyArgumentType // ignore: cast_nullable_to_non_nullable
              as DartType?,
      providerType: null == providerType
          ? _value.providerType
          : providerType // ignore: cast_nullable_to_non_nullable
              as LegacyProviderType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LegacyProviderDefinitionCopyWith<$Res>
    implements $LegacyProviderDefinitionCopyWith<$Res> {
  factory _$$_LegacyProviderDefinitionCopyWith(
          _$_LegacyProviderDefinition value,
          $Res Function(_$_LegacyProviderDefinition) then) =
      __$$_LegacyProviderDefinitionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      bool isAutoDispose,
      DartType? familyArgumentType,
      LegacyProviderType providerType});
}

/// @nodoc
class __$$_LegacyProviderDefinitionCopyWithImpl<$Res>
    extends _$LegacyProviderDefinitionCopyWithImpl<$Res,
        _$_LegacyProviderDefinition>
    implements _$$_LegacyProviderDefinitionCopyWith<$Res> {
  __$$_LegacyProviderDefinitionCopyWithImpl(_$_LegacyProviderDefinition _value,
      $Res Function(_$_LegacyProviderDefinition) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? isAutoDispose = null,
    Object? familyArgumentType = freezed,
    Object? providerType = null,
  }) {
    return _then(_$_LegacyProviderDefinition(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isAutoDispose: null == isAutoDispose
          ? _value.isAutoDispose
          : isAutoDispose // ignore: cast_nullable_to_non_nullable
              as bool,
      familyArgumentType: freezed == familyArgumentType
          ? _value.familyArgumentType
          : familyArgumentType // ignore: cast_nullable_to_non_nullable
              as DartType?,
      providerType: null == providerType
          ? _value.providerType
          : providerType // ignore: cast_nullable_to_non_nullable
              as LegacyProviderType,
    ));
  }
}

/// @nodoc

class _$_LegacyProviderDefinition implements _LegacyProviderDefinition {
  _$_LegacyProviderDefinition(
      {required this.name,
      required this.isAutoDispose,
      required this.familyArgumentType,
      required this.providerType});

  @override
  final String name;
  @override
  final bool isAutoDispose;
  @override
  final DartType? familyArgumentType;
  @override
  final LegacyProviderType providerType;

  @override
  String toString() {
    return 'LegacyProviderDefinition._(name: $name, isAutoDispose: $isAutoDispose, familyArgumentType: $familyArgumentType, providerType: $providerType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LegacyProviderDefinition &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isAutoDispose, isAutoDispose) ||
                other.isAutoDispose == isAutoDispose) &&
            (identical(other.familyArgumentType, familyArgumentType) ||
                other.familyArgumentType == familyArgumentType) &&
            (identical(other.providerType, providerType) ||
                other.providerType == providerType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, name, isAutoDispose, familyArgumentType, providerType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LegacyProviderDefinitionCopyWith<_$_LegacyProviderDefinition>
      get copyWith => __$$_LegacyProviderDefinitionCopyWithImpl<
          _$_LegacyProviderDefinition>(this, _$identity);
}

abstract class _LegacyProviderDefinition implements LegacyProviderDefinition {
  factory _LegacyProviderDefinition(
          {required final String name,
          required final bool isAutoDispose,
          required final DartType? familyArgumentType,
          required final LegacyProviderType providerType}) =
      _$_LegacyProviderDefinition;

  @override
  String get name;
  @override
  bool get isAutoDispose;
  @override
  DartType? get familyArgumentType;
  @override
  LegacyProviderType get providerType;
  @override
  @JsonKey(ignore: true)
  _$$_LegacyProviderDefinitionCopyWith<_$_LegacyProviderDefinition>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GeneratorCreatedType {
  DartType get stateType => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(DartType createdType, DartType stateType) $default, {
    required TResult Function(InterfaceType createdType, DartType stateType)
        futureOr,
    required TResult Function(InterfaceType createdType, DartType stateType)
        future,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DartType createdType, DartType stateType)? $default, {
    TResult? Function(InterfaceType createdType, DartType stateType)? futureOr,
    TResult? Function(InterfaceType createdType, DartType stateType)? future,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DartType createdType, DartType stateType)? $default, {
    TResult Function(InterfaceType createdType, DartType stateType)? futureOr,
    TResult Function(InterfaceType createdType, DartType stateType)? future,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(PlainGeneratorCreatedType value) $default, {
    required TResult Function(FutureGeneratorCreatedType value) futureOr,
    required TResult Function(FutureOrGeneratorCreatedType value) future,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(PlainGeneratorCreatedType value)? $default, {
    TResult? Function(FutureGeneratorCreatedType value)? futureOr,
    TResult? Function(FutureOrGeneratorCreatedType value)? future,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(PlainGeneratorCreatedType value)? $default, {
    TResult Function(FutureGeneratorCreatedType value)? futureOr,
    TResult Function(FutureOrGeneratorCreatedType value)? future,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GeneratorCreatedTypeCopyWith<GeneratorCreatedType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneratorCreatedTypeCopyWith<$Res> {
  factory $GeneratorCreatedTypeCopyWith(GeneratorCreatedType value,
          $Res Function(GeneratorCreatedType) then) =
      _$GeneratorCreatedTypeCopyWithImpl<$Res, GeneratorCreatedType>;
  @useResult
  $Res call({DartType stateType});
}

/// @nodoc
class _$GeneratorCreatedTypeCopyWithImpl<$Res,
        $Val extends GeneratorCreatedType>
    implements $GeneratorCreatedTypeCopyWith<$Res> {
  _$GeneratorCreatedTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stateType = null,
  }) {
    return _then(_value.copyWith(
      stateType: null == stateType
          ? _value.stateType
          : stateType // ignore: cast_nullable_to_non_nullable
              as DartType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlainGeneratorCreatedTypeCopyWith<$Res>
    implements $GeneratorCreatedTypeCopyWith<$Res> {
  factory _$$PlainGeneratorCreatedTypeCopyWith(
          _$PlainGeneratorCreatedType value,
          $Res Function(_$PlainGeneratorCreatedType) then) =
      __$$PlainGeneratorCreatedTypeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DartType createdType, DartType stateType});
}

/// @nodoc
class __$$PlainGeneratorCreatedTypeCopyWithImpl<$Res>
    extends _$GeneratorCreatedTypeCopyWithImpl<$Res,
        _$PlainGeneratorCreatedType>
    implements _$$PlainGeneratorCreatedTypeCopyWith<$Res> {
  __$$PlainGeneratorCreatedTypeCopyWithImpl(_$PlainGeneratorCreatedType _value,
      $Res Function(_$PlainGeneratorCreatedType) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdType = null,
    Object? stateType = null,
  }) {
    return _then(_$PlainGeneratorCreatedType(
      createdType: null == createdType
          ? _value.createdType
          : createdType // ignore: cast_nullable_to_non_nullable
              as DartType,
      stateType: null == stateType
          ? _value.stateType
          : stateType // ignore: cast_nullable_to_non_nullable
              as DartType,
    ));
  }
}

/// @nodoc

@internal
class _$PlainGeneratorCreatedType extends PlainGeneratorCreatedType {
  _$PlainGeneratorCreatedType(
      {required this.createdType, required this.stateType})
      : assert(createdType == stateType),
        super._();

  @override
  final DartType createdType;
  @override
  final DartType stateType;

  @override
  String toString() {
    return 'GeneratorCreatedType(createdType: $createdType, stateType: $stateType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlainGeneratorCreatedType &&
            (identical(other.createdType, createdType) ||
                other.createdType == createdType) &&
            (identical(other.stateType, stateType) ||
                other.stateType == stateType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, createdType, stateType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlainGeneratorCreatedTypeCopyWith<_$PlainGeneratorCreatedType>
      get copyWith => __$$PlainGeneratorCreatedTypeCopyWithImpl<
          _$PlainGeneratorCreatedType>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(DartType createdType, DartType stateType) $default, {
    required TResult Function(InterfaceType createdType, DartType stateType)
        futureOr,
    required TResult Function(InterfaceType createdType, DartType stateType)
        future,
  }) {
    return $default(createdType, stateType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DartType createdType, DartType stateType)? $default, {
    TResult? Function(InterfaceType createdType, DartType stateType)? futureOr,
    TResult? Function(InterfaceType createdType, DartType stateType)? future,
  }) {
    return $default?.call(createdType, stateType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DartType createdType, DartType stateType)? $default, {
    TResult Function(InterfaceType createdType, DartType stateType)? futureOr,
    TResult Function(InterfaceType createdType, DartType stateType)? future,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(createdType, stateType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(PlainGeneratorCreatedType value) $default, {
    required TResult Function(FutureGeneratorCreatedType value) futureOr,
    required TResult Function(FutureOrGeneratorCreatedType value) future,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(PlainGeneratorCreatedType value)? $default, {
    TResult? Function(FutureGeneratorCreatedType value)? futureOr,
    TResult? Function(FutureOrGeneratorCreatedType value)? future,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(PlainGeneratorCreatedType value)? $default, {
    TResult Function(FutureGeneratorCreatedType value)? futureOr,
    TResult Function(FutureOrGeneratorCreatedType value)? future,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class PlainGeneratorCreatedType extends GeneratorCreatedType {
  factory PlainGeneratorCreatedType(
      {required final DartType createdType,
      required final DartType stateType}) = _$PlainGeneratorCreatedType;
  PlainGeneratorCreatedType._() : super._();

  DartType get createdType;
  @override
  DartType get stateType;
  @override
  @JsonKey(ignore: true)
  _$$PlainGeneratorCreatedTypeCopyWith<_$PlainGeneratorCreatedType>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FutureGeneratorCreatedTypeCopyWith<$Res>
    implements $GeneratorCreatedTypeCopyWith<$Res> {
  factory _$$FutureGeneratorCreatedTypeCopyWith(
          _$FutureGeneratorCreatedType value,
          $Res Function(_$FutureGeneratorCreatedType) then) =
      __$$FutureGeneratorCreatedTypeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({InterfaceType createdType, DartType stateType});
}

/// @nodoc
class __$$FutureGeneratorCreatedTypeCopyWithImpl<$Res>
    extends _$GeneratorCreatedTypeCopyWithImpl<$Res,
        _$FutureGeneratorCreatedType>
    implements _$$FutureGeneratorCreatedTypeCopyWith<$Res> {
  __$$FutureGeneratorCreatedTypeCopyWithImpl(
      _$FutureGeneratorCreatedType _value,
      $Res Function(_$FutureGeneratorCreatedType) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdType = null,
    Object? stateType = null,
  }) {
    return _then(_$FutureGeneratorCreatedType(
      createdType: null == createdType
          ? _value.createdType
          : createdType // ignore: cast_nullable_to_non_nullable
              as InterfaceType,
      stateType: null == stateType
          ? _value.stateType
          : stateType // ignore: cast_nullable_to_non_nullable
              as DartType,
    ));
  }
}

/// @nodoc

@internal
class _$FutureGeneratorCreatedType extends FutureGeneratorCreatedType {
  _$FutureGeneratorCreatedType(
      {required this.createdType, required this.stateType})
      : super._();

  @override
  final InterfaceType createdType;
  @override
  final DartType stateType;

  @override
  String toString() {
    return 'GeneratorCreatedType.futureOr(createdType: $createdType, stateType: $stateType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FutureGeneratorCreatedType &&
            (identical(other.createdType, createdType) ||
                other.createdType == createdType) &&
            (identical(other.stateType, stateType) ||
                other.stateType == stateType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, createdType, stateType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FutureGeneratorCreatedTypeCopyWith<_$FutureGeneratorCreatedType>
      get copyWith => __$$FutureGeneratorCreatedTypeCopyWithImpl<
          _$FutureGeneratorCreatedType>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(DartType createdType, DartType stateType) $default, {
    required TResult Function(InterfaceType createdType, DartType stateType)
        futureOr,
    required TResult Function(InterfaceType createdType, DartType stateType)
        future,
  }) {
    return futureOr(createdType, stateType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DartType createdType, DartType stateType)? $default, {
    TResult? Function(InterfaceType createdType, DartType stateType)? futureOr,
    TResult? Function(InterfaceType createdType, DartType stateType)? future,
  }) {
    return futureOr?.call(createdType, stateType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DartType createdType, DartType stateType)? $default, {
    TResult Function(InterfaceType createdType, DartType stateType)? futureOr,
    TResult Function(InterfaceType createdType, DartType stateType)? future,
    required TResult orElse(),
  }) {
    if (futureOr != null) {
      return futureOr(createdType, stateType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(PlainGeneratorCreatedType value) $default, {
    required TResult Function(FutureGeneratorCreatedType value) futureOr,
    required TResult Function(FutureOrGeneratorCreatedType value) future,
  }) {
    return futureOr(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(PlainGeneratorCreatedType value)? $default, {
    TResult? Function(FutureGeneratorCreatedType value)? futureOr,
    TResult? Function(FutureOrGeneratorCreatedType value)? future,
  }) {
    return futureOr?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(PlainGeneratorCreatedType value)? $default, {
    TResult Function(FutureGeneratorCreatedType value)? futureOr,
    TResult Function(FutureOrGeneratorCreatedType value)? future,
    required TResult orElse(),
  }) {
    if (futureOr != null) {
      return futureOr(this);
    }
    return orElse();
  }
}

abstract class FutureGeneratorCreatedType extends GeneratorCreatedType {
  factory FutureGeneratorCreatedType(
      {required final InterfaceType createdType,
      required final DartType stateType}) = _$FutureGeneratorCreatedType;
  FutureGeneratorCreatedType._() : super._();

  InterfaceType get createdType;
  @override
  DartType get stateType;
  @override
  @JsonKey(ignore: true)
  _$$FutureGeneratorCreatedTypeCopyWith<_$FutureGeneratorCreatedType>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FutureOrGeneratorCreatedTypeCopyWith<$Res>
    implements $GeneratorCreatedTypeCopyWith<$Res> {
  factory _$$FutureOrGeneratorCreatedTypeCopyWith(
          _$FutureOrGeneratorCreatedType value,
          $Res Function(_$FutureOrGeneratorCreatedType) then) =
      __$$FutureOrGeneratorCreatedTypeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({InterfaceType createdType, DartType stateType});
}

/// @nodoc
class __$$FutureOrGeneratorCreatedTypeCopyWithImpl<$Res>
    extends _$GeneratorCreatedTypeCopyWithImpl<$Res,
        _$FutureOrGeneratorCreatedType>
    implements _$$FutureOrGeneratorCreatedTypeCopyWith<$Res> {
  __$$FutureOrGeneratorCreatedTypeCopyWithImpl(
      _$FutureOrGeneratorCreatedType _value,
      $Res Function(_$FutureOrGeneratorCreatedType) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdType = null,
    Object? stateType = null,
  }) {
    return _then(_$FutureOrGeneratorCreatedType(
      createdType: null == createdType
          ? _value.createdType
          : createdType // ignore: cast_nullable_to_non_nullable
              as InterfaceType,
      stateType: null == stateType
          ? _value.stateType
          : stateType // ignore: cast_nullable_to_non_nullable
              as DartType,
    ));
  }
}

/// @nodoc

@internal
class _$FutureOrGeneratorCreatedType extends FutureOrGeneratorCreatedType {
  _$FutureOrGeneratorCreatedType(
      {required this.createdType, required this.stateType})
      : super._();

  @override
  final InterfaceType createdType;
  @override
  final DartType stateType;

  @override
  String toString() {
    return 'GeneratorCreatedType.future(createdType: $createdType, stateType: $stateType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FutureOrGeneratorCreatedType &&
            (identical(other.createdType, createdType) ||
                other.createdType == createdType) &&
            (identical(other.stateType, stateType) ||
                other.stateType == stateType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, createdType, stateType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FutureOrGeneratorCreatedTypeCopyWith<_$FutureOrGeneratorCreatedType>
      get copyWith => __$$FutureOrGeneratorCreatedTypeCopyWithImpl<
          _$FutureOrGeneratorCreatedType>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(DartType createdType, DartType stateType) $default, {
    required TResult Function(InterfaceType createdType, DartType stateType)
        futureOr,
    required TResult Function(InterfaceType createdType, DartType stateType)
        future,
  }) {
    return future(createdType, stateType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DartType createdType, DartType stateType)? $default, {
    TResult? Function(InterfaceType createdType, DartType stateType)? futureOr,
    TResult? Function(InterfaceType createdType, DartType stateType)? future,
  }) {
    return future?.call(createdType, stateType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DartType createdType, DartType stateType)? $default, {
    TResult Function(InterfaceType createdType, DartType stateType)? futureOr,
    TResult Function(InterfaceType createdType, DartType stateType)? future,
    required TResult orElse(),
  }) {
    if (future != null) {
      return future(createdType, stateType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(PlainGeneratorCreatedType value) $default, {
    required TResult Function(FutureGeneratorCreatedType value) futureOr,
    required TResult Function(FutureOrGeneratorCreatedType value) future,
  }) {
    return future(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(PlainGeneratorCreatedType value)? $default, {
    TResult? Function(FutureGeneratorCreatedType value)? futureOr,
    TResult? Function(FutureOrGeneratorCreatedType value)? future,
  }) {
    return future?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(PlainGeneratorCreatedType value)? $default, {
    TResult Function(FutureGeneratorCreatedType value)? futureOr,
    TResult Function(FutureOrGeneratorCreatedType value)? future,
    required TResult orElse(),
  }) {
    if (future != null) {
      return future(this);
    }
    return orElse();
  }
}

abstract class FutureOrGeneratorCreatedType extends GeneratorCreatedType {
  factory FutureOrGeneratorCreatedType(
      {required final InterfaceType createdType,
      required final DartType stateType}) = _$FutureOrGeneratorCreatedType;
  FutureOrGeneratorCreatedType._() : super._();

  InterfaceType get createdType;
  @override
  DartType get stateType;
  @override
  @JsonKey(ignore: true)
  _$$FutureOrGeneratorCreatedTypeCopyWith<_$FutureOrGeneratorCreatedType>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GeneratorProviderDefinition {
  String get name => throw _privateConstructorUsedError;

  /// Information about the type of the value exposed
  GeneratorCreatedType get type => throw _privateConstructorUsedError;
  bool get isAutoDispose => throw _privateConstructorUsedError;
  List<ParameterElement> get parameters => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, GeneratorCreatedType type,
            bool isAutoDispose, List<ParameterElement> parameters)
        functional,
    required TResult Function(String name, GeneratorCreatedType type,
            bool isAutoDispose, List<ParameterElement> parameters)
        notifier,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, GeneratorCreatedType type,
            bool isAutoDispose, List<ParameterElement> parameters)?
        functional,
    TResult? Function(String name, GeneratorCreatedType type,
            bool isAutoDispose, List<ParameterElement> parameters)?
        notifier,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, GeneratorCreatedType type, bool isAutoDispose,
            List<ParameterElement> parameters)?
        functional,
    TResult Function(String name, GeneratorCreatedType type, bool isAutoDispose,
            List<ParameterElement> parameters)?
        notifier,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FunctionalGeneratorProviderDefinition value)
        functional,
    required TResult Function(NotifierGeneratorProviderDefinition value)
        notifier,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FunctionalGeneratorProviderDefinition value)? functional,
    TResult? Function(NotifierGeneratorProviderDefinition value)? notifier,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FunctionalGeneratorProviderDefinition value)? functional,
    TResult Function(NotifierGeneratorProviderDefinition value)? notifier,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GeneratorProviderDefinitionCopyWith<GeneratorProviderDefinition>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneratorProviderDefinitionCopyWith<$Res> {
  factory $GeneratorProviderDefinitionCopyWith(
          GeneratorProviderDefinition value,
          $Res Function(GeneratorProviderDefinition) then) =
      _$GeneratorProviderDefinitionCopyWithImpl<$Res,
          GeneratorProviderDefinition>;
  @useResult
  $Res call(
      {String name,
      GeneratorCreatedType type,
      bool isAutoDispose,
      List<ParameterElement> parameters});

  $GeneratorCreatedTypeCopyWith<$Res> get type;
}

/// @nodoc
class _$GeneratorProviderDefinitionCopyWithImpl<$Res,
        $Val extends GeneratorProviderDefinition>
    implements $GeneratorProviderDefinitionCopyWith<$Res> {
  _$GeneratorProviderDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? isAutoDispose = null,
    Object? parameters = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as GeneratorCreatedType,
      isAutoDispose: null == isAutoDispose
          ? _value.isAutoDispose
          : isAutoDispose // ignore: cast_nullable_to_non_nullable
              as bool,
      parameters: null == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<ParameterElement>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GeneratorCreatedTypeCopyWith<$Res> get type {
    return $GeneratorCreatedTypeCopyWith<$Res>(_value.type, (value) {
      return _then(_value.copyWith(type: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FunctionalGeneratorProviderDefinitionCopyWith<$Res>
    implements $GeneratorProviderDefinitionCopyWith<$Res> {
  factory _$$FunctionalGeneratorProviderDefinitionCopyWith(
          _$FunctionalGeneratorProviderDefinition value,
          $Res Function(_$FunctionalGeneratorProviderDefinition) then) =
      __$$FunctionalGeneratorProviderDefinitionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      GeneratorCreatedType type,
      bool isAutoDispose,
      List<ParameterElement> parameters});

  @override
  $GeneratorCreatedTypeCopyWith<$Res> get type;
}

/// @nodoc
class __$$FunctionalGeneratorProviderDefinitionCopyWithImpl<$Res>
    extends _$GeneratorProviderDefinitionCopyWithImpl<$Res,
        _$FunctionalGeneratorProviderDefinition>
    implements _$$FunctionalGeneratorProviderDefinitionCopyWith<$Res> {
  __$$FunctionalGeneratorProviderDefinitionCopyWithImpl(
      _$FunctionalGeneratorProviderDefinition _value,
      $Res Function(_$FunctionalGeneratorProviderDefinition) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? isAutoDispose = null,
    Object? parameters = null,
  }) {
    return _then(_$FunctionalGeneratorProviderDefinition(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as GeneratorCreatedType,
      isAutoDispose: null == isAutoDispose
          ? _value.isAutoDispose
          : isAutoDispose // ignore: cast_nullable_to_non_nullable
              as bool,
      parameters: null == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<ParameterElement>,
    ));
  }
}

/// @nodoc

@internal
class _$FunctionalGeneratorProviderDefinition
    implements FunctionalGeneratorProviderDefinition {
  _$FunctionalGeneratorProviderDefinition(
      {required this.name,
      required this.type,
      required this.isAutoDispose,
      required final List<ParameterElement> parameters})
      : _parameters = parameters;

  @override
  final String name;

  /// Information about the type of the value exposed
  @override
  final GeneratorCreatedType type;
  @override
  final bool isAutoDispose;
  final List<ParameterElement> _parameters;
  @override
  List<ParameterElement> get parameters {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parameters);
  }

  @override
  String toString() {
    return 'GeneratorProviderDefinition.functional(name: $name, type: $type, isAutoDispose: $isAutoDispose, parameters: $parameters)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FunctionalGeneratorProviderDefinition &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isAutoDispose, isAutoDispose) ||
                other.isAutoDispose == isAutoDispose) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, type, isAutoDispose,
      const DeepCollectionEquality().hash(_parameters));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FunctionalGeneratorProviderDefinitionCopyWith<
          _$FunctionalGeneratorProviderDefinition>
      get copyWith => __$$FunctionalGeneratorProviderDefinitionCopyWithImpl<
          _$FunctionalGeneratorProviderDefinition>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, GeneratorCreatedType type,
            bool isAutoDispose, List<ParameterElement> parameters)
        functional,
    required TResult Function(String name, GeneratorCreatedType type,
            bool isAutoDispose, List<ParameterElement> parameters)
        notifier,
  }) {
    return functional(name, type, isAutoDispose, parameters);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, GeneratorCreatedType type,
            bool isAutoDispose, List<ParameterElement> parameters)?
        functional,
    TResult? Function(String name, GeneratorCreatedType type,
            bool isAutoDispose, List<ParameterElement> parameters)?
        notifier,
  }) {
    return functional?.call(name, type, isAutoDispose, parameters);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, GeneratorCreatedType type, bool isAutoDispose,
            List<ParameterElement> parameters)?
        functional,
    TResult Function(String name, GeneratorCreatedType type, bool isAutoDispose,
            List<ParameterElement> parameters)?
        notifier,
    required TResult orElse(),
  }) {
    if (functional != null) {
      return functional(name, type, isAutoDispose, parameters);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FunctionalGeneratorProviderDefinition value)
        functional,
    required TResult Function(NotifierGeneratorProviderDefinition value)
        notifier,
  }) {
    return functional(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FunctionalGeneratorProviderDefinition value)? functional,
    TResult? Function(NotifierGeneratorProviderDefinition value)? notifier,
  }) {
    return functional?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FunctionalGeneratorProviderDefinition value)? functional,
    TResult Function(NotifierGeneratorProviderDefinition value)? notifier,
    required TResult orElse(),
  }) {
    if (functional != null) {
      return functional(this);
    }
    return orElse();
  }
}

abstract class FunctionalGeneratorProviderDefinition
    implements GeneratorProviderDefinition {
  factory FunctionalGeneratorProviderDefinition(
          {required final String name,
          required final GeneratorCreatedType type,
          required final bool isAutoDispose,
          required final List<ParameterElement> parameters}) =
      _$FunctionalGeneratorProviderDefinition;

  @override
  String get name;
  @override

  /// Information about the type of the value exposed
  GeneratorCreatedType get type;
  @override
  bool get isAutoDispose;
  @override
  List<ParameterElement> get parameters;
  @override
  @JsonKey(ignore: true)
  _$$FunctionalGeneratorProviderDefinitionCopyWith<
          _$FunctionalGeneratorProviderDefinition>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotifierGeneratorProviderDefinitionCopyWith<$Res>
    implements $GeneratorProviderDefinitionCopyWith<$Res> {
  factory _$$NotifierGeneratorProviderDefinitionCopyWith(
          _$NotifierGeneratorProviderDefinition value,
          $Res Function(_$NotifierGeneratorProviderDefinition) then) =
      __$$NotifierGeneratorProviderDefinitionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      GeneratorCreatedType type,
      bool isAutoDispose,
      List<ParameterElement> parameters});

  @override
  $GeneratorCreatedTypeCopyWith<$Res> get type;
}

/// @nodoc
class __$$NotifierGeneratorProviderDefinitionCopyWithImpl<$Res>
    extends _$GeneratorProviderDefinitionCopyWithImpl<$Res,
        _$NotifierGeneratorProviderDefinition>
    implements _$$NotifierGeneratorProviderDefinitionCopyWith<$Res> {
  __$$NotifierGeneratorProviderDefinitionCopyWithImpl(
      _$NotifierGeneratorProviderDefinition _value,
      $Res Function(_$NotifierGeneratorProviderDefinition) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? isAutoDispose = null,
    Object? parameters = null,
  }) {
    return _then(_$NotifierGeneratorProviderDefinition(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as GeneratorCreatedType,
      isAutoDispose: null == isAutoDispose
          ? _value.isAutoDispose
          : isAutoDispose // ignore: cast_nullable_to_non_nullable
              as bool,
      parameters: null == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<ParameterElement>,
    ));
  }
}

/// @nodoc

@internal
class _$NotifierGeneratorProviderDefinition
    implements NotifierGeneratorProviderDefinition {
  _$NotifierGeneratorProviderDefinition(
      {required this.name,
      required this.type,
      required this.isAutoDispose,
      required final List<ParameterElement> parameters})
      : _parameters = parameters;

  @override
  final String name;

  /// Information about the type of the value exposed
  @override
  final GeneratorCreatedType type;
  @override
  final bool isAutoDispose;
  final List<ParameterElement> _parameters;
  @override
  List<ParameterElement> get parameters {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parameters);
  }

  @override
  String toString() {
    return 'GeneratorProviderDefinition.notifier(name: $name, type: $type, isAutoDispose: $isAutoDispose, parameters: $parameters)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotifierGeneratorProviderDefinition &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isAutoDispose, isAutoDispose) ||
                other.isAutoDispose == isAutoDispose) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, type, isAutoDispose,
      const DeepCollectionEquality().hash(_parameters));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotifierGeneratorProviderDefinitionCopyWith<
          _$NotifierGeneratorProviderDefinition>
      get copyWith => __$$NotifierGeneratorProviderDefinitionCopyWithImpl<
          _$NotifierGeneratorProviderDefinition>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, GeneratorCreatedType type,
            bool isAutoDispose, List<ParameterElement> parameters)
        functional,
    required TResult Function(String name, GeneratorCreatedType type,
            bool isAutoDispose, List<ParameterElement> parameters)
        notifier,
  }) {
    return notifier(name, type, isAutoDispose, parameters);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, GeneratorCreatedType type,
            bool isAutoDispose, List<ParameterElement> parameters)?
        functional,
    TResult? Function(String name, GeneratorCreatedType type,
            bool isAutoDispose, List<ParameterElement> parameters)?
        notifier,
  }) {
    return notifier?.call(name, type, isAutoDispose, parameters);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, GeneratorCreatedType type, bool isAutoDispose,
            List<ParameterElement> parameters)?
        functional,
    TResult Function(String name, GeneratorCreatedType type, bool isAutoDispose,
            List<ParameterElement> parameters)?
        notifier,
    required TResult orElse(),
  }) {
    if (notifier != null) {
      return notifier(name, type, isAutoDispose, parameters);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FunctionalGeneratorProviderDefinition value)
        functional,
    required TResult Function(NotifierGeneratorProviderDefinition value)
        notifier,
  }) {
    return notifier(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FunctionalGeneratorProviderDefinition value)? functional,
    TResult? Function(NotifierGeneratorProviderDefinition value)? notifier,
  }) {
    return notifier?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FunctionalGeneratorProviderDefinition value)? functional,
    TResult Function(NotifierGeneratorProviderDefinition value)? notifier,
    required TResult orElse(),
  }) {
    if (notifier != null) {
      return notifier(this);
    }
    return orElse();
  }
}

abstract class NotifierGeneratorProviderDefinition
    implements GeneratorProviderDefinition {
  factory NotifierGeneratorProviderDefinition(
          {required final String name,
          required final GeneratorCreatedType type,
          required final bool isAutoDispose,
          required final List<ParameterElement> parameters}) =
      _$NotifierGeneratorProviderDefinition;

  @override
  String get name;
  @override

  /// Information about the type of the value exposed
  GeneratorCreatedType get type;
  @override
  bool get isAutoDispose;
  @override
  List<ParameterElement> get parameters;
  @override
  @JsonKey(ignore: true)
  _$$NotifierGeneratorProviderDefinitionCopyWith<
          _$NotifierGeneratorProviderDefinition>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AnyProviderDefinition {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LegacyProviderDefinition value) legacy,
    required TResult Function(GeneratorProviderDefinition value) generator,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LegacyProviderDefinition value)? legacy,
    TResult? Function(GeneratorProviderDefinition value)? generator,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LegacyProviderDefinition value)? legacy,
    TResult Function(GeneratorProviderDefinition value)? generator,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LegacyAnyProviderDefinition value) legacy,
    required TResult Function(GeneratorAnyProviderDefinition value) generator,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LegacyAnyProviderDefinition value)? legacy,
    TResult? Function(GeneratorAnyProviderDefinition value)? generator,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LegacyAnyProviderDefinition value)? legacy,
    TResult Function(GeneratorAnyProviderDefinition value)? generator,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnyProviderDefinitionCopyWith<$Res> {
  factory $AnyProviderDefinitionCopyWith(AnyProviderDefinition value,
          $Res Function(AnyProviderDefinition) then) =
      _$AnyProviderDefinitionCopyWithImpl<$Res, AnyProviderDefinition>;
}

/// @nodoc
class _$AnyProviderDefinitionCopyWithImpl<$Res,
        $Val extends AnyProviderDefinition>
    implements $AnyProviderDefinitionCopyWith<$Res> {
  _$AnyProviderDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LegacyAnyProviderDefinitionCopyWith<$Res> {
  factory _$$LegacyAnyProviderDefinitionCopyWith(
          _$LegacyAnyProviderDefinition value,
          $Res Function(_$LegacyAnyProviderDefinition) then) =
      __$$LegacyAnyProviderDefinitionCopyWithImpl<$Res>;
  @useResult
  $Res call({LegacyProviderDefinition value});

  $LegacyProviderDefinitionCopyWith<$Res> get value;
}

/// @nodoc
class __$$LegacyAnyProviderDefinitionCopyWithImpl<$Res>
    extends _$AnyProviderDefinitionCopyWithImpl<$Res,
        _$LegacyAnyProviderDefinition>
    implements _$$LegacyAnyProviderDefinitionCopyWith<$Res> {
  __$$LegacyAnyProviderDefinitionCopyWithImpl(
      _$LegacyAnyProviderDefinition _value,
      $Res Function(_$LegacyAnyProviderDefinition) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$LegacyAnyProviderDefinition(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as LegacyProviderDefinition,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $LegacyProviderDefinitionCopyWith<$Res> get value {
    return $LegacyProviderDefinitionCopyWith<$Res>(_value.value, (value) {
      return _then(_value.copyWith(value: value));
    });
  }
}

/// @nodoc

@internal
class _$LegacyAnyProviderDefinition extends LegacyAnyProviderDefinition {
  _$LegacyAnyProviderDefinition(this.value) : super._();

  @override
  final LegacyProviderDefinition value;

  @override
  String toString() {
    return 'AnyProviderDefinition.legacy(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LegacyAnyProviderDefinition &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LegacyAnyProviderDefinitionCopyWith<_$LegacyAnyProviderDefinition>
      get copyWith => __$$LegacyAnyProviderDefinitionCopyWithImpl<
          _$LegacyAnyProviderDefinition>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LegacyProviderDefinition value) legacy,
    required TResult Function(GeneratorProviderDefinition value) generator,
  }) {
    return legacy(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LegacyProviderDefinition value)? legacy,
    TResult? Function(GeneratorProviderDefinition value)? generator,
  }) {
    return legacy?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LegacyProviderDefinition value)? legacy,
    TResult Function(GeneratorProviderDefinition value)? generator,
    required TResult orElse(),
  }) {
    if (legacy != null) {
      return legacy(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LegacyAnyProviderDefinition value) legacy,
    required TResult Function(GeneratorAnyProviderDefinition value) generator,
  }) {
    return legacy(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LegacyAnyProviderDefinition value)? legacy,
    TResult? Function(GeneratorAnyProviderDefinition value)? generator,
  }) {
    return legacy?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LegacyAnyProviderDefinition value)? legacy,
    TResult Function(GeneratorAnyProviderDefinition value)? generator,
    required TResult orElse(),
  }) {
    if (legacy != null) {
      return legacy(this);
    }
    return orElse();
  }
}

abstract class LegacyAnyProviderDefinition extends AnyProviderDefinition {
  factory LegacyAnyProviderDefinition(final LegacyProviderDefinition value) =
      _$LegacyAnyProviderDefinition;
  LegacyAnyProviderDefinition._() : super._();

  LegacyProviderDefinition get value;
  @JsonKey(ignore: true)
  _$$LegacyAnyProviderDefinitionCopyWith<_$LegacyAnyProviderDefinition>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GeneratorAnyProviderDefinitionCopyWith<$Res> {
  factory _$$GeneratorAnyProviderDefinitionCopyWith(
          _$GeneratorAnyProviderDefinition value,
          $Res Function(_$GeneratorAnyProviderDefinition) then) =
      __$$GeneratorAnyProviderDefinitionCopyWithImpl<$Res>;
  @useResult
  $Res call({GeneratorProviderDefinition value});

  $GeneratorProviderDefinitionCopyWith<$Res> get value;
}

/// @nodoc
class __$$GeneratorAnyProviderDefinitionCopyWithImpl<$Res>
    extends _$AnyProviderDefinitionCopyWithImpl<$Res,
        _$GeneratorAnyProviderDefinition>
    implements _$$GeneratorAnyProviderDefinitionCopyWith<$Res> {
  __$$GeneratorAnyProviderDefinitionCopyWithImpl(
      _$GeneratorAnyProviderDefinition _value,
      $Res Function(_$GeneratorAnyProviderDefinition) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$GeneratorAnyProviderDefinition(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as GeneratorProviderDefinition,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $GeneratorProviderDefinitionCopyWith<$Res> get value {
    return $GeneratorProviderDefinitionCopyWith<$Res>(_value.value, (value) {
      return _then(_value.copyWith(value: value));
    });
  }
}

/// @nodoc

@internal
class _$GeneratorAnyProviderDefinition extends GeneratorAnyProviderDefinition {
  _$GeneratorAnyProviderDefinition(this.value) : super._();

  @override
  final GeneratorProviderDefinition value;

  @override
  String toString() {
    return 'AnyProviderDefinition.generator(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneratorAnyProviderDefinition &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneratorAnyProviderDefinitionCopyWith<_$GeneratorAnyProviderDefinition>
      get copyWith => __$$GeneratorAnyProviderDefinitionCopyWithImpl<
          _$GeneratorAnyProviderDefinition>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LegacyProviderDefinition value) legacy,
    required TResult Function(GeneratorProviderDefinition value) generator,
  }) {
    return generator(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LegacyProviderDefinition value)? legacy,
    TResult? Function(GeneratorProviderDefinition value)? generator,
  }) {
    return generator?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LegacyProviderDefinition value)? legacy,
    TResult Function(GeneratorProviderDefinition value)? generator,
    required TResult orElse(),
  }) {
    if (generator != null) {
      return generator(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LegacyAnyProviderDefinition value) legacy,
    required TResult Function(GeneratorAnyProviderDefinition value) generator,
  }) {
    return generator(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LegacyAnyProviderDefinition value)? legacy,
    TResult? Function(GeneratorAnyProviderDefinition value)? generator,
  }) {
    return generator?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LegacyAnyProviderDefinition value)? legacy,
    TResult Function(GeneratorAnyProviderDefinition value)? generator,
    required TResult orElse(),
  }) {
    if (generator != null) {
      return generator(this);
    }
    return orElse();
  }
}

abstract class GeneratorAnyProviderDefinition extends AnyProviderDefinition {
  factory GeneratorAnyProviderDefinition(
          final GeneratorProviderDefinition value) =
      _$GeneratorAnyProviderDefinition;
  GeneratorAnyProviderDefinition._() : super._();

  GeneratorProviderDefinition get value;
  @JsonKey(ignore: true)
  _$$GeneratorAnyProviderDefinitionCopyWith<_$GeneratorAnyProviderDefinition>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AnyProviderDefinitionFormatException {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            GeneratorProviderDefinitionFormatException exception)
        generatorException,
    required TResult Function(LegacyProviderDefinitionFormatException exception)
        legacyException,
    required TResult Function(Element element) notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GeneratorProviderDefinitionFormatException exception)?
        generatorException,
    TResult? Function(LegacyProviderDefinitionFormatException exception)?
        legacyException,
    TResult? Function(Element element)? notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GeneratorProviderDefinitionFormatException exception)?
        generatorException,
    TResult Function(LegacyProviderDefinitionFormatException exception)?
        legacyException,
    TResult Function(Element element)? notAProvider,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            GeneratorAnyProviderDefinitionFormatException value)
        generatorException,
    required TResult Function(LegacyAnyProviderDefinitionFormatException value)
        legacyException,
    required TResult Function(
            NotAProviderProviderDefinitionFormatException value)
        notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GeneratorAnyProviderDefinitionFormatException value)?
        generatorException,
    TResult? Function(LegacyAnyProviderDefinitionFormatException value)?
        legacyException,
    TResult? Function(NotAProviderProviderDefinitionFormatException value)?
        notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GeneratorAnyProviderDefinitionFormatException value)?
        generatorException,
    TResult Function(LegacyAnyProviderDefinitionFormatException value)?
        legacyException,
    TResult Function(NotAProviderProviderDefinitionFormatException value)?
        notAProvider,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnyProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory $AnyProviderDefinitionFormatExceptionCopyWith(
          AnyProviderDefinitionFormatException value,
          $Res Function(AnyProviderDefinitionFormatException) then) =
      _$AnyProviderDefinitionFormatExceptionCopyWithImpl<$Res,
          AnyProviderDefinitionFormatException>;
}

/// @nodoc
class _$AnyProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        $Val extends AnyProviderDefinitionFormatException>
    implements $AnyProviderDefinitionFormatExceptionCopyWith<$Res> {
  _$AnyProviderDefinitionFormatExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$GeneratorAnyProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory _$$GeneratorAnyProviderDefinitionFormatExceptionCopyWith(
          _$GeneratorAnyProviderDefinitionFormatException value,
          $Res Function(_$GeneratorAnyProviderDefinitionFormatException) then) =
      __$$GeneratorAnyProviderDefinitionFormatExceptionCopyWithImpl<$Res>;
  @useResult
  $Res call({GeneratorProviderDefinitionFormatException exception});

  $GeneratorProviderDefinitionFormatExceptionCopyWith<$Res> get exception;
}

/// @nodoc
class __$$GeneratorAnyProviderDefinitionFormatExceptionCopyWithImpl<$Res>
    extends _$AnyProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        _$GeneratorAnyProviderDefinitionFormatException>
    implements _$$GeneratorAnyProviderDefinitionFormatExceptionCopyWith<$Res> {
  __$$GeneratorAnyProviderDefinitionFormatExceptionCopyWithImpl(
      _$GeneratorAnyProviderDefinitionFormatException _value,
      $Res Function(_$GeneratorAnyProviderDefinitionFormatException) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exception = null,
  }) {
    return _then(_$GeneratorAnyProviderDefinitionFormatException(
      null == exception
          ? _value.exception
          : exception // ignore: cast_nullable_to_non_nullable
              as GeneratorProviderDefinitionFormatException,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $GeneratorProviderDefinitionFormatExceptionCopyWith<$Res> get exception {
    return $GeneratorProviderDefinitionFormatExceptionCopyWith<$Res>(
        _value.exception, (value) {
      return _then(_value.copyWith(exception: value));
    });
  }
}

/// @nodoc

class _$GeneratorAnyProviderDefinitionFormatException
    extends GeneratorAnyProviderDefinitionFormatException {
  _$GeneratorAnyProviderDefinitionFormatException(this.exception) : super._();

  @override
  final GeneratorProviderDefinitionFormatException exception;

  @override
  String toString() {
    return 'AnyProviderDefinitionFormatException.generatorException(exception: $exception)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneratorAnyProviderDefinitionFormatException &&
            (identical(other.exception, exception) ||
                other.exception == exception));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exception);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneratorAnyProviderDefinitionFormatExceptionCopyWith<
          _$GeneratorAnyProviderDefinitionFormatException>
      get copyWith =>
          __$$GeneratorAnyProviderDefinitionFormatExceptionCopyWithImpl<
                  _$GeneratorAnyProviderDefinitionFormatException>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            GeneratorProviderDefinitionFormatException exception)
        generatorException,
    required TResult Function(LegacyProviderDefinitionFormatException exception)
        legacyException,
    required TResult Function(Element element) notAProvider,
  }) {
    return generatorException(exception);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GeneratorProviderDefinitionFormatException exception)?
        generatorException,
    TResult? Function(LegacyProviderDefinitionFormatException exception)?
        legacyException,
    TResult? Function(Element element)? notAProvider,
  }) {
    return generatorException?.call(exception);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GeneratorProviderDefinitionFormatException exception)?
        generatorException,
    TResult Function(LegacyProviderDefinitionFormatException exception)?
        legacyException,
    TResult Function(Element element)? notAProvider,
    required TResult orElse(),
  }) {
    if (generatorException != null) {
      return generatorException(exception);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            GeneratorAnyProviderDefinitionFormatException value)
        generatorException,
    required TResult Function(LegacyAnyProviderDefinitionFormatException value)
        legacyException,
    required TResult Function(
            NotAProviderProviderDefinitionFormatException value)
        notAProvider,
  }) {
    return generatorException(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GeneratorAnyProviderDefinitionFormatException value)?
        generatorException,
    TResult? Function(LegacyAnyProviderDefinitionFormatException value)?
        legacyException,
    TResult? Function(NotAProviderProviderDefinitionFormatException value)?
        notAProvider,
  }) {
    return generatorException?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GeneratorAnyProviderDefinitionFormatException value)?
        generatorException,
    TResult Function(LegacyAnyProviderDefinitionFormatException value)?
        legacyException,
    TResult Function(NotAProviderProviderDefinitionFormatException value)?
        notAProvider,
    required TResult orElse(),
  }) {
    if (generatorException != null) {
      return generatorException(this);
    }
    return orElse();
  }
}

abstract class GeneratorAnyProviderDefinitionFormatException
    extends AnyProviderDefinitionFormatException {
  factory GeneratorAnyProviderDefinitionFormatException(
          final GeneratorProviderDefinitionFormatException exception) =
      _$GeneratorAnyProviderDefinitionFormatException;
  GeneratorAnyProviderDefinitionFormatException._() : super._();

  GeneratorProviderDefinitionFormatException get exception;
  @JsonKey(ignore: true)
  _$$GeneratorAnyProviderDefinitionFormatExceptionCopyWith<
          _$GeneratorAnyProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LegacyAnyProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory _$$LegacyAnyProviderDefinitionFormatExceptionCopyWith(
          _$LegacyAnyProviderDefinitionFormatException value,
          $Res Function(_$LegacyAnyProviderDefinitionFormatException) then) =
      __$$LegacyAnyProviderDefinitionFormatExceptionCopyWithImpl<$Res>;
  @useResult
  $Res call({LegacyProviderDefinitionFormatException exception});

  $LegacyProviderDefinitionFormatExceptionCopyWith<$Res> get exception;
}

/// @nodoc
class __$$LegacyAnyProviderDefinitionFormatExceptionCopyWithImpl<$Res>
    extends _$AnyProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        _$LegacyAnyProviderDefinitionFormatException>
    implements _$$LegacyAnyProviderDefinitionFormatExceptionCopyWith<$Res> {
  __$$LegacyAnyProviderDefinitionFormatExceptionCopyWithImpl(
      _$LegacyAnyProviderDefinitionFormatException _value,
      $Res Function(_$LegacyAnyProviderDefinitionFormatException) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exception = null,
  }) {
    return _then(_$LegacyAnyProviderDefinitionFormatException(
      null == exception
          ? _value.exception
          : exception // ignore: cast_nullable_to_non_nullable
              as LegacyProviderDefinitionFormatException,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $LegacyProviderDefinitionFormatExceptionCopyWith<$Res> get exception {
    return $LegacyProviderDefinitionFormatExceptionCopyWith<$Res>(
        _value.exception, (value) {
      return _then(_value.copyWith(exception: value));
    });
  }
}

/// @nodoc

class _$LegacyAnyProviderDefinitionFormatException
    extends LegacyAnyProviderDefinitionFormatException {
  _$LegacyAnyProviderDefinitionFormatException(this.exception) : super._();

  @override
  final LegacyProviderDefinitionFormatException exception;

  @override
  String toString() {
    return 'AnyProviderDefinitionFormatException.legacyException(exception: $exception)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LegacyAnyProviderDefinitionFormatException &&
            (identical(other.exception, exception) ||
                other.exception == exception));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exception);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LegacyAnyProviderDefinitionFormatExceptionCopyWith<
          _$LegacyAnyProviderDefinitionFormatException>
      get copyWith =>
          __$$LegacyAnyProviderDefinitionFormatExceptionCopyWithImpl<
              _$LegacyAnyProviderDefinitionFormatException>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            GeneratorProviderDefinitionFormatException exception)
        generatorException,
    required TResult Function(LegacyProviderDefinitionFormatException exception)
        legacyException,
    required TResult Function(Element element) notAProvider,
  }) {
    return legacyException(exception);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GeneratorProviderDefinitionFormatException exception)?
        generatorException,
    TResult? Function(LegacyProviderDefinitionFormatException exception)?
        legacyException,
    TResult? Function(Element element)? notAProvider,
  }) {
    return legacyException?.call(exception);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GeneratorProviderDefinitionFormatException exception)?
        generatorException,
    TResult Function(LegacyProviderDefinitionFormatException exception)?
        legacyException,
    TResult Function(Element element)? notAProvider,
    required TResult orElse(),
  }) {
    if (legacyException != null) {
      return legacyException(exception);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            GeneratorAnyProviderDefinitionFormatException value)
        generatorException,
    required TResult Function(LegacyAnyProviderDefinitionFormatException value)
        legacyException,
    required TResult Function(
            NotAProviderProviderDefinitionFormatException value)
        notAProvider,
  }) {
    return legacyException(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GeneratorAnyProviderDefinitionFormatException value)?
        generatorException,
    TResult? Function(LegacyAnyProviderDefinitionFormatException value)?
        legacyException,
    TResult? Function(NotAProviderProviderDefinitionFormatException value)?
        notAProvider,
  }) {
    return legacyException?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GeneratorAnyProviderDefinitionFormatException value)?
        generatorException,
    TResult Function(LegacyAnyProviderDefinitionFormatException value)?
        legacyException,
    TResult Function(NotAProviderProviderDefinitionFormatException value)?
        notAProvider,
    required TResult orElse(),
  }) {
    if (legacyException != null) {
      return legacyException(this);
    }
    return orElse();
  }
}

abstract class LegacyAnyProviderDefinitionFormatException
    extends AnyProviderDefinitionFormatException {
  factory LegacyAnyProviderDefinitionFormatException(
          final LegacyProviderDefinitionFormatException exception) =
      _$LegacyAnyProviderDefinitionFormatException;
  LegacyAnyProviderDefinitionFormatException._() : super._();

  LegacyProviderDefinitionFormatException get exception;
  @JsonKey(ignore: true)
  _$$LegacyAnyProviderDefinitionFormatExceptionCopyWith<
          _$LegacyAnyProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotAProviderProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory _$$NotAProviderProviderDefinitionFormatExceptionCopyWith(
          _$NotAProviderProviderDefinitionFormatException value,
          $Res Function(_$NotAProviderProviderDefinitionFormatException) then) =
      __$$NotAProviderProviderDefinitionFormatExceptionCopyWithImpl<$Res>;
  @useResult
  $Res call({Element element});
}

/// @nodoc
class __$$NotAProviderProviderDefinitionFormatExceptionCopyWithImpl<$Res>
    extends _$AnyProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        _$NotAProviderProviderDefinitionFormatException>
    implements _$$NotAProviderProviderDefinitionFormatExceptionCopyWith<$Res> {
  __$$NotAProviderProviderDefinitionFormatExceptionCopyWithImpl(
      _$NotAProviderProviderDefinitionFormatException _value,
      $Res Function(_$NotAProviderProviderDefinitionFormatException) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? element = null,
  }) {
    return _then(_$NotAProviderProviderDefinitionFormatException(
      null == element
          ? _value.element
          : element // ignore: cast_nullable_to_non_nullable
              as Element,
    ));
  }
}

/// @nodoc

class _$NotAProviderProviderDefinitionFormatException
    extends NotAProviderProviderDefinitionFormatException {
  _$NotAProviderProviderDefinitionFormatException(this.element) : super._();

  @override
  final Element element;

  @override
  String toString() {
    return 'AnyProviderDefinitionFormatException.notAProvider(element: $element)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotAProviderProviderDefinitionFormatException &&
            (identical(other.element, element) || other.element == element));
  }

  @override
  int get hashCode => Object.hash(runtimeType, element);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotAProviderProviderDefinitionFormatExceptionCopyWith<
          _$NotAProviderProviderDefinitionFormatException>
      get copyWith =>
          __$$NotAProviderProviderDefinitionFormatExceptionCopyWithImpl<
                  _$NotAProviderProviderDefinitionFormatException>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            GeneratorProviderDefinitionFormatException exception)
        generatorException,
    required TResult Function(LegacyProviderDefinitionFormatException exception)
        legacyException,
    required TResult Function(Element element) notAProvider,
  }) {
    return notAProvider(element);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GeneratorProviderDefinitionFormatException exception)?
        generatorException,
    TResult? Function(LegacyProviderDefinitionFormatException exception)?
        legacyException,
    TResult? Function(Element element)? notAProvider,
  }) {
    return notAProvider?.call(element);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GeneratorProviderDefinitionFormatException exception)?
        generatorException,
    TResult Function(LegacyProviderDefinitionFormatException exception)?
        legacyException,
    TResult Function(Element element)? notAProvider,
    required TResult orElse(),
  }) {
    if (notAProvider != null) {
      return notAProvider(element);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            GeneratorAnyProviderDefinitionFormatException value)
        generatorException,
    required TResult Function(LegacyAnyProviderDefinitionFormatException value)
        legacyException,
    required TResult Function(
            NotAProviderProviderDefinitionFormatException value)
        notAProvider,
  }) {
    return notAProvider(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GeneratorAnyProviderDefinitionFormatException value)?
        generatorException,
    TResult? Function(LegacyAnyProviderDefinitionFormatException value)?
        legacyException,
    TResult? Function(NotAProviderProviderDefinitionFormatException value)?
        notAProvider,
  }) {
    return notAProvider?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GeneratorAnyProviderDefinitionFormatException value)?
        generatorException,
    TResult Function(LegacyAnyProviderDefinitionFormatException value)?
        legacyException,
    TResult Function(NotAProviderProviderDefinitionFormatException value)?
        notAProvider,
    required TResult orElse(),
  }) {
    if (notAProvider != null) {
      return notAProvider(this);
    }
    return orElse();
  }
}

abstract class NotAProviderProviderDefinitionFormatException
    extends AnyProviderDefinitionFormatException {
  factory NotAProviderProviderDefinitionFormatException(final Element element) =
      _$NotAProviderProviderDefinitionFormatException;
  NotAProviderProviderDefinitionFormatException._() : super._();

  Element get element;
  @JsonKey(ignore: true)
  _$$NotAProviderProviderDefinitionFormatExceptionCopyWith<
          _$NotAProviderProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GeneratorProviderDefinitionFormatException {
  Element get element => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Element element) notAProvider,
    required TResult Function(Element element) neitherClassNorFunction,
    required TResult Function(Element element) tooManyAnnotations,
    required TResult Function(Element element) noBuildMethod,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Element element)? notAProvider,
    TResult? Function(Element element)? neitherClassNorFunction,
    TResult? Function(Element element)? tooManyAnnotations,
    TResult? Function(Element element)? noBuildMethod,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Element element)? notAProvider,
    TResult Function(Element element)? neitherClassNorFunction,
    TResult Function(Element element)? tooManyAnnotations,
    TResult Function(Element element)? noBuildMethod,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)
        notAProvider,
    required TResult Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)
        neitherClassNorFunction,
    required TResult Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)
        tooManyAnnotations,
    required TResult Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)
        noBuildMethod,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)?
        notAProvider,
    TResult? Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)?
        neitherClassNorFunction,
    TResult? Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)?
        tooManyAnnotations,
    TResult? Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)?
        noBuildMethod,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)?
        notAProvider,
    TResult Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)?
        neitherClassNorFunction,
    TResult Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)?
        tooManyAnnotations,
    TResult Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)?
        noBuildMethod,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GeneratorProviderDefinitionFormatExceptionCopyWith<
          GeneratorProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneratorProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory $GeneratorProviderDefinitionFormatExceptionCopyWith(
          GeneratorProviderDefinitionFormatException value,
          $Res Function(GeneratorProviderDefinitionFormatException) then) =
      _$GeneratorProviderDefinitionFormatExceptionCopyWithImpl<$Res,
          GeneratorProviderDefinitionFormatException>;
  @useResult
  $Res call({Element element});
}

/// @nodoc
class _$GeneratorProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        $Val extends GeneratorProviderDefinitionFormatException>
    implements $GeneratorProviderDefinitionFormatExceptionCopyWith<$Res> {
  _$GeneratorProviderDefinitionFormatExceptionCopyWithImpl(
      this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? element = null,
  }) {
    return _then(_value.copyWith(
      element: null == element
          ? _value.element
          : element // ignore: cast_nullable_to_non_nullable
              as Element,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotAProviderGeneratorProviderDefinitionFormatExceptionCopyWith<
    $Res> implements $GeneratorProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory _$$NotAProviderGeneratorProviderDefinitionFormatExceptionCopyWith(
          _$NotAProviderGeneratorProviderDefinitionFormatException value,
          $Res Function(
                  _$NotAProviderGeneratorProviderDefinitionFormatException)
              then) =
      __$$NotAProviderGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
          $Res>;
  @override
  @useResult
  $Res call({Element element});
}

/// @nodoc
class __$$NotAProviderGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
        $Res>
    extends _$GeneratorProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        _$NotAProviderGeneratorProviderDefinitionFormatException>
    implements
        _$$NotAProviderGeneratorProviderDefinitionFormatExceptionCopyWith<
            $Res> {
  __$$NotAProviderGeneratorProviderDefinitionFormatExceptionCopyWithImpl(
      _$NotAProviderGeneratorProviderDefinitionFormatException _value,
      $Res Function(_$NotAProviderGeneratorProviderDefinitionFormatException)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? element = null,
  }) {
    return _then(_$NotAProviderGeneratorProviderDefinitionFormatException(
      null == element
          ? _value.element
          : element // ignore: cast_nullable_to_non_nullable
              as Element,
    ));
  }
}

/// @nodoc

class _$NotAProviderGeneratorProviderDefinitionFormatException
    implements NotAProviderGeneratorProviderDefinitionFormatException {
  _$NotAProviderGeneratorProviderDefinitionFormatException(this.element);

  @override
  final Element element;

  @override
  String toString() {
    return 'GeneratorProviderDefinitionFormatException.notAProvider(element: $element)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotAProviderGeneratorProviderDefinitionFormatException &&
            (identical(other.element, element) || other.element == element));
  }

  @override
  int get hashCode => Object.hash(runtimeType, element);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotAProviderGeneratorProviderDefinitionFormatExceptionCopyWith<
          _$NotAProviderGeneratorProviderDefinitionFormatException>
      get copyWith =>
          __$$NotAProviderGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
                  _$NotAProviderGeneratorProviderDefinitionFormatException>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Element element) notAProvider,
    required TResult Function(Element element) neitherClassNorFunction,
    required TResult Function(Element element) tooManyAnnotations,
    required TResult Function(Element element) noBuildMethod,
  }) {
    return notAProvider(element);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Element element)? notAProvider,
    TResult? Function(Element element)? neitherClassNorFunction,
    TResult? Function(Element element)? tooManyAnnotations,
    TResult? Function(Element element)? noBuildMethod,
  }) {
    return notAProvider?.call(element);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Element element)? notAProvider,
    TResult Function(Element element)? neitherClassNorFunction,
    TResult Function(Element element)? tooManyAnnotations,
    TResult Function(Element element)? noBuildMethod,
    required TResult orElse(),
  }) {
    if (notAProvider != null) {
      return notAProvider(element);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)
        notAProvider,
    required TResult Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)
        neitherClassNorFunction,
    required TResult Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)
        tooManyAnnotations,
    required TResult Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)
        noBuildMethod,
  }) {
    return notAProvider(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)?
        notAProvider,
    TResult? Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)?
        neitherClassNorFunction,
    TResult? Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)?
        tooManyAnnotations,
    TResult? Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)?
        noBuildMethod,
  }) {
    return notAProvider?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)?
        notAProvider,
    TResult Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)?
        neitherClassNorFunction,
    TResult Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)?
        tooManyAnnotations,
    TResult Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)?
        noBuildMethod,
    required TResult orElse(),
  }) {
    if (notAProvider != null) {
      return notAProvider(this);
    }
    return orElse();
  }
}

abstract class NotAProviderGeneratorProviderDefinitionFormatException
    implements GeneratorProviderDefinitionFormatException {
  factory NotAProviderGeneratorProviderDefinitionFormatException(
          final Element element) =
      _$NotAProviderGeneratorProviderDefinitionFormatException;

  @override
  Element get element;
  @override
  @JsonKey(ignore: true)
  _$$NotAProviderGeneratorProviderDefinitionFormatExceptionCopyWith<
          _$NotAProviderGeneratorProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NeitherClassNorFunctionGeneratorProviderDefinitionFormatExceptionCopyWith<
    $Res> implements $GeneratorProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory _$$NeitherClassNorFunctionGeneratorProviderDefinitionFormatExceptionCopyWith(
          _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException value,
          $Res Function(
                  _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException)
              then) =
      __$$NeitherClassNorFunctionGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
          $Res>;
  @override
  @useResult
  $Res call({Element element});
}

/// @nodoc
class __$$NeitherClassNorFunctionGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
        $Res>
    extends _$GeneratorProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException>
    implements
        _$$NeitherClassNorFunctionGeneratorProviderDefinitionFormatExceptionCopyWith<
            $Res> {
  __$$NeitherClassNorFunctionGeneratorProviderDefinitionFormatExceptionCopyWithImpl(
      _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
          _value,
      $Res Function(
              _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? element = null,
  }) {
    return _then(
        _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException(
      null == element
          ? _value.element
          : element // ignore: cast_nullable_to_non_nullable
              as Element,
    ));
  }
}

/// @nodoc

class _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
    implements
        NeitherClassNorFunctionGeneratorProviderDefinitionFormatException {
  _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException(
      this.element);

  @override
  final Element element;

  @override
  String toString() {
    return 'GeneratorProviderDefinitionFormatException.neitherClassNorFunction(element: $element)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException &&
            (identical(other.element, element) || other.element == element));
  }

  @override
  int get hashCode => Object.hash(runtimeType, element);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NeitherClassNorFunctionGeneratorProviderDefinitionFormatExceptionCopyWith<
          _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException>
      get copyWith =>
          __$$NeitherClassNorFunctionGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
                  _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Element element) notAProvider,
    required TResult Function(Element element) neitherClassNorFunction,
    required TResult Function(Element element) tooManyAnnotations,
    required TResult Function(Element element) noBuildMethod,
  }) {
    return neitherClassNorFunction(element);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Element element)? notAProvider,
    TResult? Function(Element element)? neitherClassNorFunction,
    TResult? Function(Element element)? tooManyAnnotations,
    TResult? Function(Element element)? noBuildMethod,
  }) {
    return neitherClassNorFunction?.call(element);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Element element)? notAProvider,
    TResult Function(Element element)? neitherClassNorFunction,
    TResult Function(Element element)? tooManyAnnotations,
    TResult Function(Element element)? noBuildMethod,
    required TResult orElse(),
  }) {
    if (neitherClassNorFunction != null) {
      return neitherClassNorFunction(element);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)
        notAProvider,
    required TResult Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)
        neitherClassNorFunction,
    required TResult Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)
        tooManyAnnotations,
    required TResult Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)
        noBuildMethod,
  }) {
    return neitherClassNorFunction(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)?
        notAProvider,
    TResult? Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)?
        neitherClassNorFunction,
    TResult? Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)?
        tooManyAnnotations,
    TResult? Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)?
        noBuildMethod,
  }) {
    return neitherClassNorFunction?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)?
        notAProvider,
    TResult Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)?
        neitherClassNorFunction,
    TResult Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)?
        tooManyAnnotations,
    TResult Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)?
        noBuildMethod,
    required TResult orElse(),
  }) {
    if (neitherClassNorFunction != null) {
      return neitherClassNorFunction(this);
    }
    return orElse();
  }
}

abstract class NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
    implements GeneratorProviderDefinitionFormatException {
  factory NeitherClassNorFunctionGeneratorProviderDefinitionFormatException(
          final Element element) =
      _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException;

  @override
  Element get element;
  @override
  @JsonKey(ignore: true)
  _$$NeitherClassNorFunctionGeneratorProviderDefinitionFormatExceptionCopyWith<
          _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TooManyAnnotationGeneratorProviderDefinitionFormatExceptionCopyWith<
    $Res> implements $GeneratorProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory _$$TooManyAnnotationGeneratorProviderDefinitionFormatExceptionCopyWith(
          _$TooManyAnnotationGeneratorProviderDefinitionFormatException value,
          $Res Function(
                  _$TooManyAnnotationGeneratorProviderDefinitionFormatException)
              then) =
      __$$TooManyAnnotationGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
          $Res>;
  @override
  @useResult
  $Res call({Element element});
}

/// @nodoc
class __$$TooManyAnnotationGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
        $Res>
    extends _$GeneratorProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        _$TooManyAnnotationGeneratorProviderDefinitionFormatException>
    implements
        _$$TooManyAnnotationGeneratorProviderDefinitionFormatExceptionCopyWith<
            $Res> {
  __$$TooManyAnnotationGeneratorProviderDefinitionFormatExceptionCopyWithImpl(
      _$TooManyAnnotationGeneratorProviderDefinitionFormatException _value,
      $Res Function(
              _$TooManyAnnotationGeneratorProviderDefinitionFormatException)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? element = null,
  }) {
    return _then(_$TooManyAnnotationGeneratorProviderDefinitionFormatException(
      null == element
          ? _value.element
          : element // ignore: cast_nullable_to_non_nullable
              as Element,
    ));
  }
}

/// @nodoc

class _$TooManyAnnotationGeneratorProviderDefinitionFormatException
    implements TooManyAnnotationGeneratorProviderDefinitionFormatException {
  _$TooManyAnnotationGeneratorProviderDefinitionFormatException(this.element);

  @override
  final Element element;

  @override
  String toString() {
    return 'GeneratorProviderDefinitionFormatException.tooManyAnnotations(element: $element)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$TooManyAnnotationGeneratorProviderDefinitionFormatException &&
            (identical(other.element, element) || other.element == element));
  }

  @override
  int get hashCode => Object.hash(runtimeType, element);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TooManyAnnotationGeneratorProviderDefinitionFormatExceptionCopyWith<
          _$TooManyAnnotationGeneratorProviderDefinitionFormatException>
      get copyWith =>
          __$$TooManyAnnotationGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
                  _$TooManyAnnotationGeneratorProviderDefinitionFormatException>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Element element) notAProvider,
    required TResult Function(Element element) neitherClassNorFunction,
    required TResult Function(Element element) tooManyAnnotations,
    required TResult Function(Element element) noBuildMethod,
  }) {
    return tooManyAnnotations(element);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Element element)? notAProvider,
    TResult? Function(Element element)? neitherClassNorFunction,
    TResult? Function(Element element)? tooManyAnnotations,
    TResult? Function(Element element)? noBuildMethod,
  }) {
    return tooManyAnnotations?.call(element);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Element element)? notAProvider,
    TResult Function(Element element)? neitherClassNorFunction,
    TResult Function(Element element)? tooManyAnnotations,
    TResult Function(Element element)? noBuildMethod,
    required TResult orElse(),
  }) {
    if (tooManyAnnotations != null) {
      return tooManyAnnotations(element);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)
        notAProvider,
    required TResult Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)
        neitherClassNorFunction,
    required TResult Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)
        tooManyAnnotations,
    required TResult Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)
        noBuildMethod,
  }) {
    return tooManyAnnotations(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)?
        notAProvider,
    TResult? Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)?
        neitherClassNorFunction,
    TResult? Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)?
        tooManyAnnotations,
    TResult? Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)?
        noBuildMethod,
  }) {
    return tooManyAnnotations?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)?
        notAProvider,
    TResult Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)?
        neitherClassNorFunction,
    TResult Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)?
        tooManyAnnotations,
    TResult Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)?
        noBuildMethod,
    required TResult orElse(),
  }) {
    if (tooManyAnnotations != null) {
      return tooManyAnnotations(this);
    }
    return orElse();
  }
}

abstract class TooManyAnnotationGeneratorProviderDefinitionFormatException
    implements GeneratorProviderDefinitionFormatException {
  factory TooManyAnnotationGeneratorProviderDefinitionFormatException(
          final Element element) =
      _$TooManyAnnotationGeneratorProviderDefinitionFormatException;

  @override
  Element get element;
  @override
  @JsonKey(ignore: true)
  _$$TooManyAnnotationGeneratorProviderDefinitionFormatExceptionCopyWith<
          _$TooManyAnnotationGeneratorProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NoBuildMethodGeneratorProviderDefinitionFormatExceptionCopyWith<
    $Res> implements $GeneratorProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory _$$NoBuildMethodGeneratorProviderDefinitionFormatExceptionCopyWith(
          _$NoBuildMethodGeneratorProviderDefinitionFormatException value,
          $Res Function(
                  _$NoBuildMethodGeneratorProviderDefinitionFormatException)
              then) =
      __$$NoBuildMethodGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
          $Res>;
  @override
  @useResult
  $Res call({Element element});
}

/// @nodoc
class __$$NoBuildMethodGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
        $Res>
    extends _$GeneratorProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        _$NoBuildMethodGeneratorProviderDefinitionFormatException>
    implements
        _$$NoBuildMethodGeneratorProviderDefinitionFormatExceptionCopyWith<
            $Res> {
  __$$NoBuildMethodGeneratorProviderDefinitionFormatExceptionCopyWithImpl(
      _$NoBuildMethodGeneratorProviderDefinitionFormatException _value,
      $Res Function(_$NoBuildMethodGeneratorProviderDefinitionFormatException)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? element = null,
  }) {
    return _then(_$NoBuildMethodGeneratorProviderDefinitionFormatException(
      null == element
          ? _value.element
          : element // ignore: cast_nullable_to_non_nullable
              as Element,
    ));
  }
}

/// @nodoc

class _$NoBuildMethodGeneratorProviderDefinitionFormatException
    implements NoBuildMethodGeneratorProviderDefinitionFormatException {
  _$NoBuildMethodGeneratorProviderDefinitionFormatException(this.element);

  @override
  final Element element;

  @override
  String toString() {
    return 'GeneratorProviderDefinitionFormatException.noBuildMethod(element: $element)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$NoBuildMethodGeneratorProviderDefinitionFormatException &&
            (identical(other.element, element) || other.element == element));
  }

  @override
  int get hashCode => Object.hash(runtimeType, element);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoBuildMethodGeneratorProviderDefinitionFormatExceptionCopyWith<
          _$NoBuildMethodGeneratorProviderDefinitionFormatException>
      get copyWith =>
          __$$NoBuildMethodGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
                  _$NoBuildMethodGeneratorProviderDefinitionFormatException>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Element element) notAProvider,
    required TResult Function(Element element) neitherClassNorFunction,
    required TResult Function(Element element) tooManyAnnotations,
    required TResult Function(Element element) noBuildMethod,
  }) {
    return noBuildMethod(element);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Element element)? notAProvider,
    TResult? Function(Element element)? neitherClassNorFunction,
    TResult? Function(Element element)? tooManyAnnotations,
    TResult? Function(Element element)? noBuildMethod,
  }) {
    return noBuildMethod?.call(element);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Element element)? notAProvider,
    TResult Function(Element element)? neitherClassNorFunction,
    TResult Function(Element element)? tooManyAnnotations,
    TResult Function(Element element)? noBuildMethod,
    required TResult orElse(),
  }) {
    if (noBuildMethod != null) {
      return noBuildMethod(element);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)
        notAProvider,
    required TResult Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)
        neitherClassNorFunction,
    required TResult Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)
        tooManyAnnotations,
    required TResult Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)
        noBuildMethod,
  }) {
    return noBuildMethod(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)?
        notAProvider,
    TResult? Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)?
        neitherClassNorFunction,
    TResult? Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)?
        tooManyAnnotations,
    TResult? Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)?
        noBuildMethod,
  }) {
    return noBuildMethod?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            NotAProviderGeneratorProviderDefinitionFormatException value)?
        notAProvider,
    TResult Function(
            NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
                value)?
        neitherClassNorFunction,
    TResult Function(
            TooManyAnnotationGeneratorProviderDefinitionFormatException value)?
        tooManyAnnotations,
    TResult Function(
            NoBuildMethodGeneratorProviderDefinitionFormatException value)?
        noBuildMethod,
    required TResult orElse(),
  }) {
    if (noBuildMethod != null) {
      return noBuildMethod(this);
    }
    return orElse();
  }
}

abstract class NoBuildMethodGeneratorProviderDefinitionFormatException
    implements GeneratorProviderDefinitionFormatException {
  factory NoBuildMethodGeneratorProviderDefinitionFormatException(
          final Element element) =
      _$NoBuildMethodGeneratorProviderDefinitionFormatException;

  @override
  Element get element;
  @override
  @JsonKey(ignore: true)
  _$$NoBuildMethodGeneratorProviderDefinitionFormatExceptionCopyWith<
          _$NoBuildMethodGeneratorProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LegacyProviderDefinitionFormatException {
  Element get element => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Element element) notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Element element)? notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Element element)? notAProvider,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            NotAProviderLegacyProviderDefinitionFormatException value)
        notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            NotAProviderLegacyProviderDefinitionFormatException value)?
        notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotAProviderLegacyProviderDefinitionFormatException value)?
        notAProvider,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LegacyProviderDefinitionFormatExceptionCopyWith<
          LegacyProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LegacyProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory $LegacyProviderDefinitionFormatExceptionCopyWith(
          LegacyProviderDefinitionFormatException value,
          $Res Function(LegacyProviderDefinitionFormatException) then) =
      _$LegacyProviderDefinitionFormatExceptionCopyWithImpl<$Res,
          LegacyProviderDefinitionFormatException>;
  @useResult
  $Res call({Element element});
}

/// @nodoc
class _$LegacyProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        $Val extends LegacyProviderDefinitionFormatException>
    implements $LegacyProviderDefinitionFormatExceptionCopyWith<$Res> {
  _$LegacyProviderDefinitionFormatExceptionCopyWithImpl(
      this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? element = null,
  }) {
    return _then(_value.copyWith(
      element: null == element
          ? _value.element
          : element // ignore: cast_nullable_to_non_nullable
              as Element,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotAProviderLegacyProviderDefinitionFormatExceptionCopyWith<
    $Res> implements $LegacyProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory _$$NotAProviderLegacyProviderDefinitionFormatExceptionCopyWith(
          _$NotAProviderLegacyProviderDefinitionFormatException value,
          $Res Function(_$NotAProviderLegacyProviderDefinitionFormatException)
              then) =
      __$$NotAProviderLegacyProviderDefinitionFormatExceptionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Element element});
}

/// @nodoc
class __$$NotAProviderLegacyProviderDefinitionFormatExceptionCopyWithImpl<$Res>
    extends _$LegacyProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        _$NotAProviderLegacyProviderDefinitionFormatException>
    implements
        _$$NotAProviderLegacyProviderDefinitionFormatExceptionCopyWith<$Res> {
  __$$NotAProviderLegacyProviderDefinitionFormatExceptionCopyWithImpl(
      _$NotAProviderLegacyProviderDefinitionFormatException _value,
      $Res Function(_$NotAProviderLegacyProviderDefinitionFormatException)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? element = null,
  }) {
    return _then(_$NotAProviderLegacyProviderDefinitionFormatException(
      null == element
          ? _value.element
          : element // ignore: cast_nullable_to_non_nullable
              as Element,
    ));
  }
}

/// @nodoc

class _$NotAProviderLegacyProviderDefinitionFormatException
    extends NotAProviderLegacyProviderDefinitionFormatException {
  _$NotAProviderLegacyProviderDefinitionFormatException(this.element)
      : super._();

  @override
  final Element element;

  @override
  String toString() {
    return 'LegacyProviderDefinitionFormatException.notAProvider(element: $element)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotAProviderLegacyProviderDefinitionFormatException &&
            (identical(other.element, element) || other.element == element));
  }

  @override
  int get hashCode => Object.hash(runtimeType, element);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotAProviderLegacyProviderDefinitionFormatExceptionCopyWith<
          _$NotAProviderLegacyProviderDefinitionFormatException>
      get copyWith =>
          __$$NotAProviderLegacyProviderDefinitionFormatExceptionCopyWithImpl<
                  _$NotAProviderLegacyProviderDefinitionFormatException>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Element element) notAProvider,
  }) {
    return notAProvider(element);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Element element)? notAProvider,
  }) {
    return notAProvider?.call(element);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Element element)? notAProvider,
    required TResult orElse(),
  }) {
    if (notAProvider != null) {
      return notAProvider(element);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            NotAProviderLegacyProviderDefinitionFormatException value)
        notAProvider,
  }) {
    return notAProvider(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            NotAProviderLegacyProviderDefinitionFormatException value)?
        notAProvider,
  }) {
    return notAProvider?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotAProviderLegacyProviderDefinitionFormatException value)?
        notAProvider,
    required TResult orElse(),
  }) {
    if (notAProvider != null) {
      return notAProvider(this);
    }
    return orElse();
  }
}

abstract class NotAProviderLegacyProviderDefinitionFormatException
    extends LegacyProviderDefinitionFormatException {
  factory NotAProviderLegacyProviderDefinitionFormatException(
          final Element element) =
      _$NotAProviderLegacyProviderDefinitionFormatException;
  NotAProviderLegacyProviderDefinitionFormatException._() : super._();

  @override
  Element get element;
  @override
  @JsonKey(ignore: true)
  _$$NotAProviderLegacyProviderDefinitionFormatExceptionCopyWith<
          _$NotAProviderLegacyProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}
