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
mixin _$GeneratorProviderDependency {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GeneratorProviderDefinition definition) provider,
    required TResult Function(LegacyProviderDefinition definition) symbol,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GeneratorProviderDefinition definition)? provider,
    TResult? Function(LegacyProviderDefinition definition)? symbol,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GeneratorProviderDefinition definition)? provider,
    TResult Function(LegacyProviderDefinition definition)? symbol,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProviderGeneratorProviderDependency value)
        provider,
    required TResult Function(SymbolGeneratorProviderDependency value) symbol,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProviderGeneratorProviderDependency value)? provider,
    TResult? Function(SymbolGeneratorProviderDependency value)? symbol,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProviderGeneratorProviderDependency value)? provider,
    TResult Function(SymbolGeneratorProviderDependency value)? symbol,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneratorProviderDependencyCopyWith<$Res> {
  factory $GeneratorProviderDependencyCopyWith(
          GeneratorProviderDependency value,
          $Res Function(GeneratorProviderDependency) then) =
      _$GeneratorProviderDependencyCopyWithImpl<$Res,
          GeneratorProviderDependency>;
}

/// @nodoc
class _$GeneratorProviderDependencyCopyWithImpl<$Res,
        $Val extends GeneratorProviderDependency>
    implements $GeneratorProviderDependencyCopyWith<$Res> {
  _$GeneratorProviderDependencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ProviderGeneratorProviderDependencyCopyWith<$Res> {
  factory _$$ProviderGeneratorProviderDependencyCopyWith(
          _$ProviderGeneratorProviderDependency value,
          $Res Function(_$ProviderGeneratorProviderDependency) then) =
      __$$ProviderGeneratorProviderDependencyCopyWithImpl<$Res>;
  @useResult
  $Res call({GeneratorProviderDefinition definition});

  $GeneratorProviderDefinitionCopyWith<$Res> get definition;
}

/// @nodoc
class __$$ProviderGeneratorProviderDependencyCopyWithImpl<$Res>
    extends _$GeneratorProviderDependencyCopyWithImpl<$Res,
        _$ProviderGeneratorProviderDependency>
    implements _$$ProviderGeneratorProviderDependencyCopyWith<$Res> {
  __$$ProviderGeneratorProviderDependencyCopyWithImpl(
      _$ProviderGeneratorProviderDependency _value,
      $Res Function(_$ProviderGeneratorProviderDependency) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? definition = null,
  }) {
    return _then(_$ProviderGeneratorProviderDependency(
      null == definition
          ? _value.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as GeneratorProviderDefinition,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $GeneratorProviderDefinitionCopyWith<$Res> get definition {
    return $GeneratorProviderDefinitionCopyWith<$Res>(_value.definition,
        (value) {
      return _then(_value.copyWith(definition: value));
    });
  }
}

/// @nodoc

@internal
class _$ProviderGeneratorProviderDependency
    extends ProviderGeneratorProviderDependency {
  _$ProviderGeneratorProviderDependency(this.definition) : super._();

  @override
  final GeneratorProviderDefinition definition;

  @override
  String toString() {
    return 'GeneratorProviderDependency.provider(definition: $definition)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProviderGeneratorProviderDependency &&
            (identical(other.definition, definition) ||
                other.definition == definition));
  }

  @override
  int get hashCode => Object.hash(runtimeType, definition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProviderGeneratorProviderDependencyCopyWith<
          _$ProviderGeneratorProviderDependency>
      get copyWith => __$$ProviderGeneratorProviderDependencyCopyWithImpl<
          _$ProviderGeneratorProviderDependency>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GeneratorProviderDefinition definition) provider,
    required TResult Function(LegacyProviderDefinition definition) symbol,
  }) {
    return provider(definition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GeneratorProviderDefinition definition)? provider,
    TResult? Function(LegacyProviderDefinition definition)? symbol,
  }) {
    return provider?.call(definition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GeneratorProviderDefinition definition)? provider,
    TResult Function(LegacyProviderDefinition definition)? symbol,
    required TResult orElse(),
  }) {
    if (provider != null) {
      return provider(definition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProviderGeneratorProviderDependency value)
        provider,
    required TResult Function(SymbolGeneratorProviderDependency value) symbol,
  }) {
    return provider(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProviderGeneratorProviderDependency value)? provider,
    TResult? Function(SymbolGeneratorProviderDependency value)? symbol,
  }) {
    return provider?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProviderGeneratorProviderDependency value)? provider,
    TResult Function(SymbolGeneratorProviderDependency value)? symbol,
    required TResult orElse(),
  }) {
    if (provider != null) {
      return provider(this);
    }
    return orElse();
  }
}

abstract class ProviderGeneratorProviderDependency
    extends GeneratorProviderDependency {
  factory ProviderGeneratorProviderDependency(
          final GeneratorProviderDefinition definition) =
      _$ProviderGeneratorProviderDependency;
  ProviderGeneratorProviderDependency._() : super._();

  GeneratorProviderDefinition get definition;
  @JsonKey(ignore: true)
  _$$ProviderGeneratorProviderDependencyCopyWith<
          _$ProviderGeneratorProviderDependency>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SymbolGeneratorProviderDependencyCopyWith<$Res> {
  factory _$$SymbolGeneratorProviderDependencyCopyWith(
          _$SymbolGeneratorProviderDependency value,
          $Res Function(_$SymbolGeneratorProviderDependency) then) =
      __$$SymbolGeneratorProviderDependencyCopyWithImpl<$Res>;
  @useResult
  $Res call({LegacyProviderDefinition definition});

  $LegacyProviderDefinitionCopyWith<$Res> get definition;
}

/// @nodoc
class __$$SymbolGeneratorProviderDependencyCopyWithImpl<$Res>
    extends _$GeneratorProviderDependencyCopyWithImpl<$Res,
        _$SymbolGeneratorProviderDependency>
    implements _$$SymbolGeneratorProviderDependencyCopyWith<$Res> {
  __$$SymbolGeneratorProviderDependencyCopyWithImpl(
      _$SymbolGeneratorProviderDependency _value,
      $Res Function(_$SymbolGeneratorProviderDependency) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? definition = null,
  }) {
    return _then(_$SymbolGeneratorProviderDependency(
      null == definition
          ? _value.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as LegacyProviderDefinition,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $LegacyProviderDefinitionCopyWith<$Res> get definition {
    return $LegacyProviderDefinitionCopyWith<$Res>(_value.definition, (value) {
      return _then(_value.copyWith(definition: value));
    });
  }
}

/// @nodoc

@internal
class _$SymbolGeneratorProviderDependency
    extends SymbolGeneratorProviderDependency {
  _$SymbolGeneratorProviderDependency(this.definition) : super._();

  @override
  final LegacyProviderDefinition definition;

  @override
  String toString() {
    return 'GeneratorProviderDependency.symbol(definition: $definition)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SymbolGeneratorProviderDependency &&
            (identical(other.definition, definition) ||
                other.definition == definition));
  }

  @override
  int get hashCode => Object.hash(runtimeType, definition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SymbolGeneratorProviderDependencyCopyWith<
          _$SymbolGeneratorProviderDependency>
      get copyWith => __$$SymbolGeneratorProviderDependencyCopyWithImpl<
          _$SymbolGeneratorProviderDependency>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GeneratorProviderDefinition definition) provider,
    required TResult Function(LegacyProviderDefinition definition) symbol,
  }) {
    return symbol(definition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GeneratorProviderDefinition definition)? provider,
    TResult? Function(LegacyProviderDefinition definition)? symbol,
  }) {
    return symbol?.call(definition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GeneratorProviderDefinition definition)? provider,
    TResult Function(LegacyProviderDefinition definition)? symbol,
    required TResult orElse(),
  }) {
    if (symbol != null) {
      return symbol(definition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProviderGeneratorProviderDependency value)
        provider,
    required TResult Function(SymbolGeneratorProviderDependency value) symbol,
  }) {
    return symbol(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProviderGeneratorProviderDependency value)? provider,
    TResult? Function(SymbolGeneratorProviderDependency value)? symbol,
  }) {
    return symbol?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProviderGeneratorProviderDependency value)? provider,
    TResult Function(SymbolGeneratorProviderDependency value)? symbol,
    required TResult orElse(),
  }) {
    if (symbol != null) {
      return symbol(this);
    }
    return orElse();
  }
}

abstract class SymbolGeneratorProviderDependency
    extends GeneratorProviderDependency {
  factory SymbolGeneratorProviderDependency(
          final LegacyProviderDefinition definition) =
      _$SymbolGeneratorProviderDependency;
  SymbolGeneratorProviderDependency._() : super._();

  LegacyProviderDefinition get definition;
  @JsonKey(ignore: true)
  _$$SymbolGeneratorProviderDependencyCopyWith<
          _$SymbolGeneratorProviderDependency>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GeneratorCreatedType {
  DartType get stateType => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(DartType createdType, DartType stateType) $default, {
    required TResult Function(InterfaceType createdType, DartType stateType)
        future,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DartType createdType, DartType stateType)? $default, {
    TResult? Function(InterfaceType createdType, DartType stateType)? future,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DartType createdType, DartType stateType)? $default, {
    TResult Function(InterfaceType createdType, DartType stateType)? future,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(PlainGeneratorCreatedType value) $default, {
    required TResult Function(FutureOrGeneratorCreatedType value) future,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(PlainGeneratorCreatedType value)? $default, {
    TResult? Function(FutureOrGeneratorCreatedType value)? future,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(PlainGeneratorCreatedType value)? $default, {
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
        future,
  }) {
    return $default(createdType, stateType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DartType createdType, DartType stateType)? $default, {
    TResult? Function(InterfaceType createdType, DartType stateType)? future,
  }) {
    return $default?.call(createdType, stateType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DartType createdType, DartType stateType)? $default, {
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
    required TResult Function(FutureOrGeneratorCreatedType value) future,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(PlainGeneratorCreatedType value)? $default, {
    TResult? Function(FutureOrGeneratorCreatedType value)? future,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(PlainGeneratorCreatedType value)? $default, {
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
        future,
  }) {
    return future(createdType, stateType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DartType createdType, DartType stateType)? $default, {
    TResult? Function(InterfaceType createdType, DartType stateType)? future,
  }) {
    return future?.call(createdType, stateType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DartType createdType, DartType stateType)? $default, {
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
    required TResult Function(FutureOrGeneratorCreatedType value) future,
  }) {
    return future(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(PlainGeneratorCreatedType value)? $default, {
    TResult? Function(FutureOrGeneratorCreatedType value)? future,
  }) {
    return future?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(PlainGeneratorCreatedType value)? $default, {
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
  String? get docs => throw _privateConstructorUsedError;
  List<GeneratorProviderDependency>? get dependencies =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)
        functional,
    required TResult Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)
        notifier,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)?
        functional,
    TResult? Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)?
        notifier,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)?
        functional,
    TResult Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)?
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
      List<ParameterElement> parameters,
      String? docs,
      List<GeneratorProviderDependency>? dependencies});

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
    Object? docs = freezed,
    Object? dependencies = freezed,
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
      docs: freezed == docs
          ? _value.docs
          : docs // ignore: cast_nullable_to_non_nullable
              as String?,
      dependencies: freezed == dependencies
          ? _value.dependencies
          : dependencies // ignore: cast_nullable_to_non_nullable
              as List<GeneratorProviderDependency>?,
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
      List<ParameterElement> parameters,
      String? docs,
      List<GeneratorProviderDependency>? dependencies});

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
    Object? docs = freezed,
    Object? dependencies = freezed,
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
      docs: freezed == docs
          ? _value.docs
          : docs // ignore: cast_nullable_to_non_nullable
              as String?,
      dependencies: freezed == dependencies
          ? _value._dependencies
          : dependencies // ignore: cast_nullable_to_non_nullable
              as List<GeneratorProviderDependency>?,
    ));
  }
}

/// @nodoc

@internal
class _$FunctionalGeneratorProviderDefinition
    extends FunctionalGeneratorProviderDefinition {
  _$FunctionalGeneratorProviderDefinition(
      {required this.name,
      required this.type,
      required this.isAutoDispose,
      required final List<ParameterElement> parameters,
      required this.docs,
      required final List<GeneratorProviderDependency>? dependencies})
      : _parameters = parameters,
        _dependencies = dependencies,
        super._();

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
  final String? docs;
  final List<GeneratorProviderDependency>? _dependencies;
  @override
  List<GeneratorProviderDependency>? get dependencies {
    final value = _dependencies;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GeneratorProviderDefinition.functional(name: $name, type: $type, isAutoDispose: $isAutoDispose, parameters: $parameters, docs: $docs, dependencies: $dependencies)';
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
                .equals(other._parameters, _parameters) &&
            (identical(other.docs, docs) || other.docs == docs) &&
            const DeepCollectionEquality()
                .equals(other._dependencies, _dependencies));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      type,
      isAutoDispose,
      const DeepCollectionEquality().hash(_parameters),
      docs,
      const DeepCollectionEquality().hash(_dependencies));

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
    required TResult Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)
        functional,
    required TResult Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)
        notifier,
  }) {
    return functional(
        name, type, isAutoDispose, parameters, docs, dependencies);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)?
        functional,
    TResult? Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)?
        notifier,
  }) {
    return functional?.call(
        name, type, isAutoDispose, parameters, docs, dependencies);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)?
        functional,
    TResult Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)?
        notifier,
    required TResult orElse(),
  }) {
    if (functional != null) {
      return functional(
          name, type, isAutoDispose, parameters, docs, dependencies);
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
    extends GeneratorProviderDefinition {
  factory FunctionalGeneratorProviderDefinition(
          {required final String name,
          required final GeneratorCreatedType type,
          required final bool isAutoDispose,
          required final List<ParameterElement> parameters,
          required final String? docs,
          required final List<GeneratorProviderDependency>? dependencies}) =
      _$FunctionalGeneratorProviderDefinition;
  FunctionalGeneratorProviderDefinition._() : super._();

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
  String? get docs;
  @override
  List<GeneratorProviderDependency>? get dependencies;
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
      List<ParameterElement> parameters,
      String? docs,
      List<GeneratorProviderDependency>? dependencies});

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
    Object? docs = freezed,
    Object? dependencies = freezed,
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
      docs: freezed == docs
          ? _value.docs
          : docs // ignore: cast_nullable_to_non_nullable
              as String?,
      dependencies: freezed == dependencies
          ? _value._dependencies
          : dependencies // ignore: cast_nullable_to_non_nullable
              as List<GeneratorProviderDependency>?,
    ));
  }
}

/// @nodoc

@internal
class _$NotifierGeneratorProviderDefinition
    extends NotifierGeneratorProviderDefinition {
  _$NotifierGeneratorProviderDefinition(
      {required this.name,
      required this.type,
      required this.isAutoDispose,
      required final List<ParameterElement> parameters,
      required this.docs,
      required final List<GeneratorProviderDependency>? dependencies})
      : _parameters = parameters,
        _dependencies = dependencies,
        super._();

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
  final String? docs;
  final List<GeneratorProviderDependency>? _dependencies;
  @override
  List<GeneratorProviderDependency>? get dependencies {
    final value = _dependencies;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GeneratorProviderDefinition.notifier(name: $name, type: $type, isAutoDispose: $isAutoDispose, parameters: $parameters, docs: $docs, dependencies: $dependencies)';
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
                .equals(other._parameters, _parameters) &&
            (identical(other.docs, docs) || other.docs == docs) &&
            const DeepCollectionEquality()
                .equals(other._dependencies, _dependencies));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      type,
      isAutoDispose,
      const DeepCollectionEquality().hash(_parameters),
      docs,
      const DeepCollectionEquality().hash(_dependencies));

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
    required TResult Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)
        functional,
    required TResult Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)
        notifier,
  }) {
    return notifier(name, type, isAutoDispose, parameters, docs, dependencies);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)?
        functional,
    TResult? Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)?
        notifier,
  }) {
    return notifier?.call(
        name, type, isAutoDispose, parameters, docs, dependencies);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)?
        functional,
    TResult Function(
            String name,
            GeneratorCreatedType type,
            bool isAutoDispose,
            List<ParameterElement> parameters,
            String? docs,
            List<GeneratorProviderDependency>? dependencies)?
        notifier,
    required TResult orElse(),
  }) {
    if (notifier != null) {
      return notifier(
          name, type, isAutoDispose, parameters, docs, dependencies);
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
    extends GeneratorProviderDefinition {
  factory NotifierGeneratorProviderDefinition(
          {required final String name,
          required final GeneratorCreatedType type,
          required final bool isAutoDispose,
          required final List<ParameterElement> parameters,
          required final String? docs,
          required final List<GeneratorProviderDependency>? dependencies}) =
      _$NotifierGeneratorProviderDefinition;
  NotifierGeneratorProviderDefinition._() : super._();

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
  String? get docs;
  @override
  List<GeneratorProviderDependency>? get dependencies;
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
    required TResult Function() notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GeneratorProviderDefinitionFormatException exception)?
        generatorException,
    TResult? Function(LegacyProviderDefinitionFormatException exception)?
        legacyException,
    TResult? Function()? notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GeneratorProviderDefinitionFormatException exception)?
        generatorException,
    TResult Function(LegacyProviderDefinitionFormatException exception)?
        legacyException,
    TResult Function()? notAProvider,
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
    required TResult Function() notAProvider,
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
    TResult? Function()? notAProvider,
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
    TResult Function()? notAProvider,
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
    required TResult Function() notAProvider,
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
    TResult? Function()? notAProvider,
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
    TResult Function()? notAProvider,
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
}

/// @nodoc

class _$NotAProviderProviderDefinitionFormatException
    extends NotAProviderProviderDefinitionFormatException {
  _$NotAProviderProviderDefinitionFormatException() : super._();

  @override
  String toString() {
    return 'AnyProviderDefinitionFormatException.notAProvider()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotAProviderProviderDefinitionFormatException);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            GeneratorProviderDefinitionFormatException exception)
        generatorException,
    required TResult Function(LegacyProviderDefinitionFormatException exception)
        legacyException,
    required TResult Function() notAProvider,
  }) {
    return notAProvider();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GeneratorProviderDefinitionFormatException exception)?
        generatorException,
    TResult? Function(LegacyProviderDefinitionFormatException exception)?
        legacyException,
    TResult? Function()? notAProvider,
  }) {
    return notAProvider?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GeneratorProviderDefinitionFormatException exception)?
        generatorException,
    TResult Function(LegacyProviderDefinitionFormatException exception)?
        legacyException,
    TResult Function()? notAProvider,
    required TResult orElse(),
  }) {
    if (notAProvider != null) {
      return notAProvider();
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
  factory NotAProviderProviderDefinitionFormatException() =
      _$NotAProviderProviderDefinitionFormatException;
  NotAProviderProviderDefinitionFormatException._() : super._();
}

/// @nodoc
mixin _$GeneratorProviderDefinitionFormatException {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAProvider,
    required TResult Function() neitherClassNorFunction,
    required TResult Function() tooManyAnnotations,
    required TResult Function() noBuildMethod,
    required TResult Function(Object? error, StackTrace? stackTrace)
        failedToParseDependency,
    required TResult Function() notAProviderDependency,
    required TResult Function(String dependency, LibraryElement scope)
        symbolDependencyNotFoundInScope,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAProvider,
    TResult? Function()? neitherClassNorFunction,
    TResult? Function()? tooManyAnnotations,
    TResult? Function()? noBuildMethod,
    TResult? Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult? Function()? notAProviderDependency,
    TResult? Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAProvider,
    TResult Function()? neitherClassNorFunction,
    TResult Function()? tooManyAnnotations,
    TResult Function()? noBuildMethod,
    TResult Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult Function()? notAProviderDependency,
    TResult Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
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
    required TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)
        failedToParseDependency,
    required TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)
        notAProviderDependency,
    required TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)
        symbolDependencyNotFoundInScope,
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
    TResult? Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult? Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult? Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
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
    TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneratorProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory $GeneratorProviderDefinitionFormatExceptionCopyWith(
          GeneratorProviderDefinitionFormatException value,
          $Res Function(GeneratorProviderDefinitionFormatException) then) =
      _$GeneratorProviderDefinitionFormatExceptionCopyWithImpl<$Res,
          GeneratorProviderDefinitionFormatException>;
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
}

/// @nodoc
abstract class _$$NotAProviderGeneratorProviderDefinitionFormatExceptionCopyWith<
    $Res> {
  factory _$$NotAProviderGeneratorProviderDefinitionFormatExceptionCopyWith(
          _$NotAProviderGeneratorProviderDefinitionFormatException value,
          $Res Function(
                  _$NotAProviderGeneratorProviderDefinitionFormatException)
              then) =
      __$$NotAProviderGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
          $Res>;
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
}

/// @nodoc

class _$NotAProviderGeneratorProviderDefinitionFormatException
    implements NotAProviderGeneratorProviderDefinitionFormatException {
  _$NotAProviderGeneratorProviderDefinitionFormatException();

  @override
  String toString() {
    return 'GeneratorProviderDefinitionFormatException.notAProvider()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotAProviderGeneratorProviderDefinitionFormatException);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAProvider,
    required TResult Function() neitherClassNorFunction,
    required TResult Function() tooManyAnnotations,
    required TResult Function() noBuildMethod,
    required TResult Function(Object? error, StackTrace? stackTrace)
        failedToParseDependency,
    required TResult Function() notAProviderDependency,
    required TResult Function(String dependency, LibraryElement scope)
        symbolDependencyNotFoundInScope,
  }) {
    return notAProvider();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAProvider,
    TResult? Function()? neitherClassNorFunction,
    TResult? Function()? tooManyAnnotations,
    TResult? Function()? noBuildMethod,
    TResult? Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult? Function()? notAProviderDependency,
    TResult? Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
  }) {
    return notAProvider?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAProvider,
    TResult Function()? neitherClassNorFunction,
    TResult Function()? tooManyAnnotations,
    TResult Function()? noBuildMethod,
    TResult Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult Function()? notAProviderDependency,
    TResult Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
    required TResult orElse(),
  }) {
    if (notAProvider != null) {
      return notAProvider();
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
    required TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)
        failedToParseDependency,
    required TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)
        notAProviderDependency,
    required TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)
        symbolDependencyNotFoundInScope,
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
    TResult? Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult? Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult? Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
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
    TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
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
  factory NotAProviderGeneratorProviderDefinitionFormatException() =
      _$NotAProviderGeneratorProviderDefinitionFormatException;
}

/// @nodoc
abstract class _$$NeitherClassNorFunctionGeneratorProviderDefinitionFormatExceptionCopyWith<
    $Res> {
  factory _$$NeitherClassNorFunctionGeneratorProviderDefinitionFormatExceptionCopyWith(
          _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException value,
          $Res Function(
                  _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException)
              then) =
      __$$NeitherClassNorFunctionGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
          $Res>;
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
}

/// @nodoc

class _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException
    implements
        NeitherClassNorFunctionGeneratorProviderDefinitionFormatException {
  _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException();

  @override
  String toString() {
    return 'GeneratorProviderDefinitionFormatException.neitherClassNorFunction()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAProvider,
    required TResult Function() neitherClassNorFunction,
    required TResult Function() tooManyAnnotations,
    required TResult Function() noBuildMethod,
    required TResult Function(Object? error, StackTrace? stackTrace)
        failedToParseDependency,
    required TResult Function() notAProviderDependency,
    required TResult Function(String dependency, LibraryElement scope)
        symbolDependencyNotFoundInScope,
  }) {
    return neitherClassNorFunction();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAProvider,
    TResult? Function()? neitherClassNorFunction,
    TResult? Function()? tooManyAnnotations,
    TResult? Function()? noBuildMethod,
    TResult? Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult? Function()? notAProviderDependency,
    TResult? Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
  }) {
    return neitherClassNorFunction?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAProvider,
    TResult Function()? neitherClassNorFunction,
    TResult Function()? tooManyAnnotations,
    TResult Function()? noBuildMethod,
    TResult Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult Function()? notAProviderDependency,
    TResult Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
    required TResult orElse(),
  }) {
    if (neitherClassNorFunction != null) {
      return neitherClassNorFunction();
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
    required TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)
        failedToParseDependency,
    required TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)
        notAProviderDependency,
    required TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)
        symbolDependencyNotFoundInScope,
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
    TResult? Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult? Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult? Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
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
    TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
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
  factory NeitherClassNorFunctionGeneratorProviderDefinitionFormatException() =
      _$NeitherClassNorFunctionGeneratorProviderDefinitionFormatException;
}

/// @nodoc
abstract class _$$TooManyAnnotationGeneratorProviderDefinitionFormatExceptionCopyWith<
    $Res> {
  factory _$$TooManyAnnotationGeneratorProviderDefinitionFormatExceptionCopyWith(
          _$TooManyAnnotationGeneratorProviderDefinitionFormatException value,
          $Res Function(
                  _$TooManyAnnotationGeneratorProviderDefinitionFormatException)
              then) =
      __$$TooManyAnnotationGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
          $Res>;
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
}

/// @nodoc

class _$TooManyAnnotationGeneratorProviderDefinitionFormatException
    implements TooManyAnnotationGeneratorProviderDefinitionFormatException {
  _$TooManyAnnotationGeneratorProviderDefinitionFormatException();

  @override
  String toString() {
    return 'GeneratorProviderDefinitionFormatException.tooManyAnnotations()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$TooManyAnnotationGeneratorProviderDefinitionFormatException);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAProvider,
    required TResult Function() neitherClassNorFunction,
    required TResult Function() tooManyAnnotations,
    required TResult Function() noBuildMethod,
    required TResult Function(Object? error, StackTrace? stackTrace)
        failedToParseDependency,
    required TResult Function() notAProviderDependency,
    required TResult Function(String dependency, LibraryElement scope)
        symbolDependencyNotFoundInScope,
  }) {
    return tooManyAnnotations();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAProvider,
    TResult? Function()? neitherClassNorFunction,
    TResult? Function()? tooManyAnnotations,
    TResult? Function()? noBuildMethod,
    TResult? Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult? Function()? notAProviderDependency,
    TResult? Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
  }) {
    return tooManyAnnotations?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAProvider,
    TResult Function()? neitherClassNorFunction,
    TResult Function()? tooManyAnnotations,
    TResult Function()? noBuildMethod,
    TResult Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult Function()? notAProviderDependency,
    TResult Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
    required TResult orElse(),
  }) {
    if (tooManyAnnotations != null) {
      return tooManyAnnotations();
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
    required TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)
        failedToParseDependency,
    required TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)
        notAProviderDependency,
    required TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)
        symbolDependencyNotFoundInScope,
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
    TResult? Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult? Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult? Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
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
    TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
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
  factory TooManyAnnotationGeneratorProviderDefinitionFormatException() =
      _$TooManyAnnotationGeneratorProviderDefinitionFormatException;
}

/// @nodoc
abstract class _$$NoBuildMethodGeneratorProviderDefinitionFormatExceptionCopyWith<
    $Res> {
  factory _$$NoBuildMethodGeneratorProviderDefinitionFormatExceptionCopyWith(
          _$NoBuildMethodGeneratorProviderDefinitionFormatException value,
          $Res Function(
                  _$NoBuildMethodGeneratorProviderDefinitionFormatException)
              then) =
      __$$NoBuildMethodGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
          $Res>;
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
}

/// @nodoc

class _$NoBuildMethodGeneratorProviderDefinitionFormatException
    implements NoBuildMethodGeneratorProviderDefinitionFormatException {
  _$NoBuildMethodGeneratorProviderDefinitionFormatException();

  @override
  String toString() {
    return 'GeneratorProviderDefinitionFormatException.noBuildMethod()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoBuildMethodGeneratorProviderDefinitionFormatException);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAProvider,
    required TResult Function() neitherClassNorFunction,
    required TResult Function() tooManyAnnotations,
    required TResult Function() noBuildMethod,
    required TResult Function(Object? error, StackTrace? stackTrace)
        failedToParseDependency,
    required TResult Function() notAProviderDependency,
    required TResult Function(String dependency, LibraryElement scope)
        symbolDependencyNotFoundInScope,
  }) {
    return noBuildMethod();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAProvider,
    TResult? Function()? neitherClassNorFunction,
    TResult? Function()? tooManyAnnotations,
    TResult? Function()? noBuildMethod,
    TResult? Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult? Function()? notAProviderDependency,
    TResult? Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
  }) {
    return noBuildMethod?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAProvider,
    TResult Function()? neitherClassNorFunction,
    TResult Function()? tooManyAnnotations,
    TResult Function()? noBuildMethod,
    TResult Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult Function()? notAProviderDependency,
    TResult Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
    required TResult orElse(),
  }) {
    if (noBuildMethod != null) {
      return noBuildMethod();
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
    required TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)
        failedToParseDependency,
    required TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)
        notAProviderDependency,
    required TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)
        symbolDependencyNotFoundInScope,
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
    TResult? Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult? Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult? Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
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
    TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
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
  factory NoBuildMethodGeneratorProviderDefinitionFormatException() =
      _$NoBuildMethodGeneratorProviderDefinitionFormatException;
}

/// @nodoc
abstract class _$$FailedToParseDependencyGeneratorProviderDefinitionFormatExceptionCopyWith<
    $Res> {
  factory _$$FailedToParseDependencyGeneratorProviderDefinitionFormatExceptionCopyWith(
          _$FailedToParseDependencyGeneratorProviderDefinitionFormatException value,
          $Res Function(
                  _$FailedToParseDependencyGeneratorProviderDefinitionFormatException)
              then) =
      __$$FailedToParseDependencyGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
          $Res>;
  @useResult
  $Res call({Object? error, StackTrace? stackTrace});
}

/// @nodoc
class __$$FailedToParseDependencyGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
        $Res>
    extends _$GeneratorProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        _$FailedToParseDependencyGeneratorProviderDefinitionFormatException>
    implements
        _$$FailedToParseDependencyGeneratorProviderDefinitionFormatExceptionCopyWith<
            $Res> {
  __$$FailedToParseDependencyGeneratorProviderDefinitionFormatExceptionCopyWithImpl(
      _$FailedToParseDependencyGeneratorProviderDefinitionFormatException
          _value,
      $Res Function(
              _$FailedToParseDependencyGeneratorProviderDefinitionFormatException)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(
        _$FailedToParseDependencyGeneratorProviderDefinitionFormatException(
      error: freezed == error ? _value.error : error,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _$FailedToParseDependencyGeneratorProviderDefinitionFormatException
    implements
        FailedToParseDependencyGeneratorProviderDefinitionFormatException {
  _$FailedToParseDependencyGeneratorProviderDefinitionFormatException(
      {this.error, this.stackTrace})
      : assert(
            (error == null && stackTrace == null) ||
                (error != null && stackTrace != null),
            'If error is specified, stackTrace must be specified too');

  @override
  final Object? error;
  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'GeneratorProviderDefinitionFormatException.failedToParseDependency(error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$FailedToParseDependencyGeneratorProviderDefinitionFormatException &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(error), stackTrace);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FailedToParseDependencyGeneratorProviderDefinitionFormatExceptionCopyWith<
          _$FailedToParseDependencyGeneratorProviderDefinitionFormatException>
      get copyWith =>
          __$$FailedToParseDependencyGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
                  _$FailedToParseDependencyGeneratorProviderDefinitionFormatException>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAProvider,
    required TResult Function() neitherClassNorFunction,
    required TResult Function() tooManyAnnotations,
    required TResult Function() noBuildMethod,
    required TResult Function(Object? error, StackTrace? stackTrace)
        failedToParseDependency,
    required TResult Function() notAProviderDependency,
    required TResult Function(String dependency, LibraryElement scope)
        symbolDependencyNotFoundInScope,
  }) {
    return failedToParseDependency(error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAProvider,
    TResult? Function()? neitherClassNorFunction,
    TResult? Function()? tooManyAnnotations,
    TResult? Function()? noBuildMethod,
    TResult? Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult? Function()? notAProviderDependency,
    TResult? Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
  }) {
    return failedToParseDependency?.call(error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAProvider,
    TResult Function()? neitherClassNorFunction,
    TResult Function()? tooManyAnnotations,
    TResult Function()? noBuildMethod,
    TResult Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult Function()? notAProviderDependency,
    TResult Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
    required TResult orElse(),
  }) {
    if (failedToParseDependency != null) {
      return failedToParseDependency(error, stackTrace);
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
    required TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)
        failedToParseDependency,
    required TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)
        notAProviderDependency,
    required TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)
        symbolDependencyNotFoundInScope,
  }) {
    return failedToParseDependency(this);
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
    TResult? Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult? Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult? Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
  }) {
    return failedToParseDependency?.call(this);
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
    TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
    required TResult orElse(),
  }) {
    if (failedToParseDependency != null) {
      return failedToParseDependency(this);
    }
    return orElse();
  }
}

abstract class FailedToParseDependencyGeneratorProviderDefinitionFormatException
    implements GeneratorProviderDefinitionFormatException {
  factory FailedToParseDependencyGeneratorProviderDefinitionFormatException(
          {final Object? error, final StackTrace? stackTrace}) =
      _$FailedToParseDependencyGeneratorProviderDefinitionFormatException;

  Object? get error;
  StackTrace? get stackTrace;
  @JsonKey(ignore: true)
  _$$FailedToParseDependencyGeneratorProviderDefinitionFormatExceptionCopyWith<
          _$FailedToParseDependencyGeneratorProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotAProviderDependencyGeneratorProviderDefinitionFormatExceptionCopyWith<
    $Res> {
  factory _$$NotAProviderDependencyGeneratorProviderDefinitionFormatExceptionCopyWith(
          _$NotAProviderDependencyGeneratorProviderDefinitionFormatException value,
          $Res Function(
                  _$NotAProviderDependencyGeneratorProviderDefinitionFormatException)
              then) =
      __$$NotAProviderDependencyGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$NotAProviderDependencyGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
        $Res>
    extends _$GeneratorProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        _$NotAProviderDependencyGeneratorProviderDefinitionFormatException>
    implements
        _$$NotAProviderDependencyGeneratorProviderDefinitionFormatExceptionCopyWith<
            $Res> {
  __$$NotAProviderDependencyGeneratorProviderDefinitionFormatExceptionCopyWithImpl(
      _$NotAProviderDependencyGeneratorProviderDefinitionFormatException _value,
      $Res Function(
              _$NotAProviderDependencyGeneratorProviderDefinitionFormatException)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$NotAProviderDependencyGeneratorProviderDefinitionFormatException
    implements
        NotAProviderDependencyGeneratorProviderDefinitionFormatException {
  _$NotAProviderDependencyGeneratorProviderDefinitionFormatException();

  @override
  String toString() {
    return 'GeneratorProviderDefinitionFormatException.notAProviderDependency()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$NotAProviderDependencyGeneratorProviderDefinitionFormatException);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAProvider,
    required TResult Function() neitherClassNorFunction,
    required TResult Function() tooManyAnnotations,
    required TResult Function() noBuildMethod,
    required TResult Function(Object? error, StackTrace? stackTrace)
        failedToParseDependency,
    required TResult Function() notAProviderDependency,
    required TResult Function(String dependency, LibraryElement scope)
        symbolDependencyNotFoundInScope,
  }) {
    return notAProviderDependency();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAProvider,
    TResult? Function()? neitherClassNorFunction,
    TResult? Function()? tooManyAnnotations,
    TResult? Function()? noBuildMethod,
    TResult? Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult? Function()? notAProviderDependency,
    TResult? Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
  }) {
    return notAProviderDependency?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAProvider,
    TResult Function()? neitherClassNorFunction,
    TResult Function()? tooManyAnnotations,
    TResult Function()? noBuildMethod,
    TResult Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult Function()? notAProviderDependency,
    TResult Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
    required TResult orElse(),
  }) {
    if (notAProviderDependency != null) {
      return notAProviderDependency();
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
    required TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)
        failedToParseDependency,
    required TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)
        notAProviderDependency,
    required TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)
        symbolDependencyNotFoundInScope,
  }) {
    return notAProviderDependency(this);
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
    TResult? Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult? Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult? Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
  }) {
    return notAProviderDependency?.call(this);
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
    TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
    required TResult orElse(),
  }) {
    if (notAProviderDependency != null) {
      return notAProviderDependency(this);
    }
    return orElse();
  }
}

abstract class NotAProviderDependencyGeneratorProviderDefinitionFormatException
    implements GeneratorProviderDefinitionFormatException {
  factory NotAProviderDependencyGeneratorProviderDefinitionFormatException() =
      _$NotAProviderDependencyGeneratorProviderDefinitionFormatException;
}

/// @nodoc
abstract class _$$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatExceptionCopyWith<
    $Res> {
  factory _$$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatExceptionCopyWith(
          _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
              value,
          $Res Function(
                  _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException)
              then) =
      __$$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
          $Res>;
  @useResult
  $Res call({String dependency, LibraryElement scope});
}

/// @nodoc
class __$$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
        $Res>
    extends _$GeneratorProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException>
    implements
        _$$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatExceptionCopyWith<
            $Res> {
  __$$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatExceptionCopyWithImpl(
      _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
          _value,
      $Res Function(
              _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dependency = null,
    Object? scope = null,
  }) {
    return _then(
        _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException(
      null == dependency
          ? _value.dependency
          : dependency // ignore: cast_nullable_to_non_nullable
              as String,
      null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as LibraryElement,
    ));
  }
}

/// @nodoc

class _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
    implements
        SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException {
  _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException(
      this.dependency, this.scope);

  @override
  final String dependency;
  @override
  final LibraryElement scope;

  @override
  String toString() {
    return 'GeneratorProviderDefinitionFormatException.symbolDependencyNotFoundInScope(dependency: $dependency, scope: $scope)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException &&
            (identical(other.dependency, dependency) ||
                other.dependency == dependency) &&
            (identical(other.scope, scope) || other.scope == scope));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dependency, scope);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatExceptionCopyWith<
          _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException>
      get copyWith =>
          __$$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatExceptionCopyWithImpl<
                  _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAProvider,
    required TResult Function() neitherClassNorFunction,
    required TResult Function() tooManyAnnotations,
    required TResult Function() noBuildMethod,
    required TResult Function(Object? error, StackTrace? stackTrace)
        failedToParseDependency,
    required TResult Function() notAProviderDependency,
    required TResult Function(String dependency, LibraryElement scope)
        symbolDependencyNotFoundInScope,
  }) {
    return symbolDependencyNotFoundInScope(dependency, scope);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAProvider,
    TResult? Function()? neitherClassNorFunction,
    TResult? Function()? tooManyAnnotations,
    TResult? Function()? noBuildMethod,
    TResult? Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult? Function()? notAProviderDependency,
    TResult? Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
  }) {
    return symbolDependencyNotFoundInScope?.call(dependency, scope);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAProvider,
    TResult Function()? neitherClassNorFunction,
    TResult Function()? tooManyAnnotations,
    TResult Function()? noBuildMethod,
    TResult Function(Object? error, StackTrace? stackTrace)?
        failedToParseDependency,
    TResult Function()? notAProviderDependency,
    TResult Function(String dependency, LibraryElement scope)?
        symbolDependencyNotFoundInScope,
    required TResult orElse(),
  }) {
    if (symbolDependencyNotFoundInScope != null) {
      return symbolDependencyNotFoundInScope(dependency, scope);
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
    required TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)
        failedToParseDependency,
    required TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)
        notAProviderDependency,
    required TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)
        symbolDependencyNotFoundInScope,
  }) {
    return symbolDependencyNotFoundInScope(this);
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
    TResult? Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult? Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult? Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
  }) {
    return symbolDependencyNotFoundInScope?.call(this);
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
    TResult Function(
            FailedToParseDependencyGeneratorProviderDefinitionFormatException
                value)?
        failedToParseDependency,
    TResult Function(
            NotAProviderDependencyGeneratorProviderDefinitionFormatException
                value)?
        notAProviderDependency,
    TResult Function(
            SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
                value)?
        symbolDependencyNotFoundInScope,
    required TResult orElse(),
  }) {
    if (symbolDependencyNotFoundInScope != null) {
      return symbolDependencyNotFoundInScope(this);
    }
    return orElse();
  }
}

abstract class SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException
    implements GeneratorProviderDefinitionFormatException {
  factory SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException(
          final String dependency, final LibraryElement scope) =
      _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException;

  String get dependency;
  LibraryElement get scope;
  @JsonKey(ignore: true)
  _$$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatExceptionCopyWith<
          _$SymbolDependencyNotFoundInScopeGeneratorProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LegacyProviderDefinitionFormatException {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAProvider,
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
}

/// @nodoc
abstract class $LegacyProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory $LegacyProviderDefinitionFormatExceptionCopyWith(
          LegacyProviderDefinitionFormatException value,
          $Res Function(LegacyProviderDefinitionFormatException) then) =
      _$LegacyProviderDefinitionFormatExceptionCopyWithImpl<$Res,
          LegacyProviderDefinitionFormatException>;
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
}

/// @nodoc
abstract class _$$NotAProviderLegacyProviderDefinitionFormatExceptionCopyWith<
    $Res> {
  factory _$$NotAProviderLegacyProviderDefinitionFormatExceptionCopyWith(
          _$NotAProviderLegacyProviderDefinitionFormatException value,
          $Res Function(_$NotAProviderLegacyProviderDefinitionFormatException)
              then) =
      __$$NotAProviderLegacyProviderDefinitionFormatExceptionCopyWithImpl<$Res>;
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
}

/// @nodoc

class _$NotAProviderLegacyProviderDefinitionFormatException
    extends NotAProviderLegacyProviderDefinitionFormatException {
  _$NotAProviderLegacyProviderDefinitionFormatException() : super._();

  @override
  String toString() {
    return 'LegacyProviderDefinitionFormatException.notAProvider()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotAProviderLegacyProviderDefinitionFormatException);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notAProvider,
  }) {
    return notAProvider();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? notAProvider,
  }) {
    return notAProvider?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notAProvider,
    required TResult orElse(),
  }) {
    if (notAProvider != null) {
      return notAProvider();
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
  factory NotAProviderLegacyProviderDefinitionFormatException() =
      _$NotAProviderLegacyProviderDefinitionFormatException;
  NotAProviderLegacyProviderDefinitionFormatException._() : super._();
}
