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
mixin _$ProviderDefinition {
  String get name => throw _privateConstructorUsedError;
  bool get isAutoDispose => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String name,
            bool isAutoDispose,
            DartType? familyArgumentType,
            LegacyProviderType providerType,
            List<int>? list)
        legacy,
    required TResult Function(String name, bool isAutoDispose) generator,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String name,
            bool isAutoDispose,
            DartType? familyArgumentType,
            LegacyProviderType providerType,
            List<int>? list)?
        legacy,
    TResult? Function(String name, bool isAutoDispose)? generator,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String name,
            bool isAutoDispose,
            DartType? familyArgumentType,
            LegacyProviderType providerType,
            List<int>? list)?
        legacy,
    TResult Function(String name, bool isAutoDispose)? generator,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LegacyProviderDefinition value) legacy,
    required TResult Function(GeneratorProviderDefinition value) generator,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LegacyProviderDefinition value)? legacy,
    TResult? Function(GeneratorProviderDefinition value)? generator,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LegacyProviderDefinition value)? legacy,
    TResult Function(GeneratorProviderDefinition value)? generator,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProviderDefinitionCopyWith<ProviderDefinition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProviderDefinitionCopyWith<$Res> {
  factory $ProviderDefinitionCopyWith(
          ProviderDefinition value, $Res Function(ProviderDefinition) then) =
      _$ProviderDefinitionCopyWithImpl<$Res, ProviderDefinition>;
  @useResult
  $Res call({String name, bool isAutoDispose});
}

/// @nodoc
class _$ProviderDefinitionCopyWithImpl<$Res, $Val extends ProviderDefinition>
    implements $ProviderDefinitionCopyWith<$Res> {
  _$ProviderDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? isAutoDispose = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LegacyProviderDefinitionCopyWith<$Res>
    implements $ProviderDefinitionCopyWith<$Res> {
  factory _$$LegacyProviderDefinitionCopyWith(_$LegacyProviderDefinition value,
          $Res Function(_$LegacyProviderDefinition) then) =
      __$$LegacyProviderDefinitionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      bool isAutoDispose,
      DartType? familyArgumentType,
      LegacyProviderType providerType,
      List<int>? list});
}

/// @nodoc
class __$$LegacyProviderDefinitionCopyWithImpl<$Res>
    extends _$ProviderDefinitionCopyWithImpl<$Res, _$LegacyProviderDefinition>
    implements _$$LegacyProviderDefinitionCopyWith<$Res> {
  __$$LegacyProviderDefinitionCopyWithImpl(_$LegacyProviderDefinition _value,
      $Res Function(_$LegacyProviderDefinition) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? isAutoDispose = null,
    Object? familyArgumentType = freezed,
    Object? providerType = null,
    Object? list = freezed,
  }) {
    return _then(_$LegacyProviderDefinition(
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
      list: freezed == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc

@internal
class _$LegacyProviderDefinition extends LegacyProviderDefinition {
  _$LegacyProviderDefinition(
      {required this.name,
      required this.isAutoDispose,
      required this.familyArgumentType,
      required this.providerType,
      final List<int>? list})
      : _list = list,
        super._();

  @override
  final String name;
  @override
  final bool isAutoDispose;
  @override
  final DartType? familyArgumentType;
  @override
  final LegacyProviderType providerType;
  final List<int>? _list;
  @override
  List<int>? get list {
    final value = _list;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ProviderDefinition.legacy(name: $name, isAutoDispose: $isAutoDispose, familyArgumentType: $familyArgumentType, providerType: $providerType, list: $list)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LegacyProviderDefinition &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isAutoDispose, isAutoDispose) ||
                other.isAutoDispose == isAutoDispose) &&
            (identical(other.familyArgumentType, familyArgumentType) ||
                other.familyArgumentType == familyArgumentType) &&
            (identical(other.providerType, providerType) ||
                other.providerType == providerType) &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      isAutoDispose,
      familyArgumentType,
      providerType,
      const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LegacyProviderDefinitionCopyWith<_$LegacyProviderDefinition>
      get copyWith =>
          __$$LegacyProviderDefinitionCopyWithImpl<_$LegacyProviderDefinition>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String name,
            bool isAutoDispose,
            DartType? familyArgumentType,
            LegacyProviderType providerType,
            List<int>? list)
        legacy,
    required TResult Function(String name, bool isAutoDispose) generator,
  }) {
    return legacy(name, isAutoDispose, familyArgumentType, providerType, list);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String name,
            bool isAutoDispose,
            DartType? familyArgumentType,
            LegacyProviderType providerType,
            List<int>? list)?
        legacy,
    TResult? Function(String name, bool isAutoDispose)? generator,
  }) {
    return legacy?.call(
        name, isAutoDispose, familyArgumentType, providerType, list);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String name,
            bool isAutoDispose,
            DartType? familyArgumentType,
            LegacyProviderType providerType,
            List<int>? list)?
        legacy,
    TResult Function(String name, bool isAutoDispose)? generator,
    required TResult orElse(),
  }) {
    if (legacy != null) {
      return legacy(
          name, isAutoDispose, familyArgumentType, providerType, list);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LegacyProviderDefinition value) legacy,
    required TResult Function(GeneratorProviderDefinition value) generator,
  }) {
    return legacy(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LegacyProviderDefinition value)? legacy,
    TResult? Function(GeneratorProviderDefinition value)? generator,
  }) {
    return legacy?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LegacyProviderDefinition value)? legacy,
    TResult Function(GeneratorProviderDefinition value)? generator,
    required TResult orElse(),
  }) {
    if (legacy != null) {
      return legacy(this);
    }
    return orElse();
  }
}

abstract class LegacyProviderDefinition extends ProviderDefinition {
  factory LegacyProviderDefinition(
      {required final String name,
      required final bool isAutoDispose,
      required final DartType? familyArgumentType,
      required final LegacyProviderType providerType,
      final List<int>? list}) = _$LegacyProviderDefinition;
  LegacyProviderDefinition._() : super._();

  @override
  String get name;
  @override
  bool get isAutoDispose;
  DartType? get familyArgumentType;
  LegacyProviderType get providerType;
  List<int>? get list;
  @override
  @JsonKey(ignore: true)
  _$$LegacyProviderDefinitionCopyWith<_$LegacyProviderDefinition>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GeneratorProviderDefinitionCopyWith<$Res>
    implements $ProviderDefinitionCopyWith<$Res> {
  factory _$$GeneratorProviderDefinitionCopyWith(
          _$GeneratorProviderDefinition value,
          $Res Function(_$GeneratorProviderDefinition) then) =
      __$$GeneratorProviderDefinitionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, bool isAutoDispose});
}

/// @nodoc
class __$$GeneratorProviderDefinitionCopyWithImpl<$Res>
    extends _$ProviderDefinitionCopyWithImpl<$Res,
        _$GeneratorProviderDefinition>
    implements _$$GeneratorProviderDefinitionCopyWith<$Res> {
  __$$GeneratorProviderDefinitionCopyWithImpl(
      _$GeneratorProviderDefinition _value,
      $Res Function(_$GeneratorProviderDefinition) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? isAutoDispose = null,
  }) {
    return _then(_$GeneratorProviderDefinition(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isAutoDispose: null == isAutoDispose
          ? _value.isAutoDispose
          : isAutoDispose // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@internal
class _$GeneratorProviderDefinition extends GeneratorProviderDefinition {
  _$GeneratorProviderDefinition(
      {required this.name, required this.isAutoDispose})
      : super._();

  @override
  final String name;
  @override
  final bool isAutoDispose;

  @override
  String toString() {
    return 'ProviderDefinition.generator(name: $name, isAutoDispose: $isAutoDispose)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneratorProviderDefinition &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isAutoDispose, isAutoDispose) ||
                other.isAutoDispose == isAutoDispose));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, isAutoDispose);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneratorProviderDefinitionCopyWith<_$GeneratorProviderDefinition>
      get copyWith => __$$GeneratorProviderDefinitionCopyWithImpl<
          _$GeneratorProviderDefinition>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String name,
            bool isAutoDispose,
            DartType? familyArgumentType,
            LegacyProviderType providerType,
            List<int>? list)
        legacy,
    required TResult Function(String name, bool isAutoDispose) generator,
  }) {
    return generator(name, isAutoDispose);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String name,
            bool isAutoDispose,
            DartType? familyArgumentType,
            LegacyProviderType providerType,
            List<int>? list)?
        legacy,
    TResult? Function(String name, bool isAutoDispose)? generator,
  }) {
    return generator?.call(name, isAutoDispose);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String name,
            bool isAutoDispose,
            DartType? familyArgumentType,
            LegacyProviderType providerType,
            List<int>? list)?
        legacy,
    TResult Function(String name, bool isAutoDispose)? generator,
    required TResult orElse(),
  }) {
    if (generator != null) {
      return generator(name, isAutoDispose);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LegacyProviderDefinition value) legacy,
    required TResult Function(GeneratorProviderDefinition value) generator,
  }) {
    return generator(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LegacyProviderDefinition value)? legacy,
    TResult? Function(GeneratorProviderDefinition value)? generator,
  }) {
    return generator?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LegacyProviderDefinition value)? legacy,
    TResult Function(GeneratorProviderDefinition value)? generator,
    required TResult orElse(),
  }) {
    if (generator != null) {
      return generator(this);
    }
    return orElse();
  }
}

abstract class GeneratorProviderDefinition extends ProviderDefinition {
  factory GeneratorProviderDefinition(
      {required final String name,
      required final bool isAutoDispose}) = _$GeneratorProviderDefinition;
  GeneratorProviderDefinition._() : super._();

  @override
  String get name;
  @override
  bool get isAutoDispose;
  @override
  @JsonKey(ignore: true)
  _$$GeneratorProviderDefinitionCopyWith<_$GeneratorProviderDefinition>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProviderDefinitionFormatException {
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
            NotAProviderProviderDefinitionFormatException value)
        notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotAProviderProviderDefinitionFormatException value)?
        notAProvider,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotAProviderProviderDefinitionFormatException value)?
        notAProvider,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProviderDefinitionFormatExceptionCopyWith<ProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory $ProviderDefinitionFormatExceptionCopyWith(
          ProviderDefinitionFormatException value,
          $Res Function(ProviderDefinitionFormatException) then) =
      _$ProviderDefinitionFormatExceptionCopyWithImpl<$Res,
          ProviderDefinitionFormatException>;
  @useResult
  $Res call({Element element});
}

/// @nodoc
class _$ProviderDefinitionFormatExceptionCopyWithImpl<$Res,
        $Val extends ProviderDefinitionFormatException>
    implements $ProviderDefinitionFormatExceptionCopyWith<$Res> {
  _$ProviderDefinitionFormatExceptionCopyWithImpl(this._value, this._then);

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
abstract class _$$NotAProviderProviderDefinitionFormatExceptionCopyWith<$Res>
    implements $ProviderDefinitionFormatExceptionCopyWith<$Res> {
  factory _$$NotAProviderProviderDefinitionFormatExceptionCopyWith(
          _$NotAProviderProviderDefinitionFormatException value,
          $Res Function(_$NotAProviderProviderDefinitionFormatException) then) =
      __$$NotAProviderProviderDefinitionFormatExceptionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Element element});
}

/// @nodoc
class __$$NotAProviderProviderDefinitionFormatExceptionCopyWithImpl<$Res>
    extends _$ProviderDefinitionFormatExceptionCopyWithImpl<$Res,
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
    return 'ProviderDefinitionFormatException.notAProvider(element: $element)';
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
            NotAProviderProviderDefinitionFormatException value)
        notAProvider,
  }) {
    return notAProvider(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotAProviderProviderDefinitionFormatException value)?
        notAProvider,
  }) {
    return notAProvider?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
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
    extends ProviderDefinitionFormatException {
  factory NotAProviderProviderDefinitionFormatException(final Element element) =
      _$NotAProviderProviderDefinitionFormatException;
  NotAProviderProviderDefinitionFormatException._() : super._();

  @override
  Element get element;
  @override
  @JsonKey(ignore: true)
  _$$NotAProviderProviderDefinitionFormatExceptionCopyWith<
          _$NotAProviderProviderDefinitionFormatException>
      get copyWith => throw _privateConstructorUsedError;
}
