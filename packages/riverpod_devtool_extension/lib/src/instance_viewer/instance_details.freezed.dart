// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'instance_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PathToPropertyTearOff {
  const _$PathToPropertyTearOff();

  ListIndexPath listIndex(int index) {
    return ListIndexPath(
      index,
    );
  }

  MapKeyPath mapKey({required String? ref}) {
    return MapKeyPath(
      ref: ref,
    );
  }

  PropertyPath objectProperty(
      {required String name,
      required String ownerUri,
      required String ownerName}) {
    return PropertyPath(
      name: name,
      ownerUri: ownerUri,
      ownerName: ownerName,
    );
  }
}

/// @nodoc
const $PathToProperty = _$PathToPropertyTearOff();

/// @nodoc
mixin _$PathToProperty {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) listIndex,
    required TResult Function(String? ref) mapKey,
    required TResult Function(String name, String ownerUri, String ownerName)
        objectProperty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int index)? listIndex,
    TResult Function(String? ref)? mapKey,
    TResult Function(String name, String ownerUri, String ownerName)?
        objectProperty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? listIndex,
    TResult Function(String? ref)? mapKey,
    TResult Function(String name, String ownerUri, String ownerName)?
        objectProperty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ListIndexPath value) listIndex,
    required TResult Function(MapKeyPath value) mapKey,
    required TResult Function(PropertyPath value) objectProperty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ListIndexPath value)? listIndex,
    TResult Function(MapKeyPath value)? mapKey,
    TResult Function(PropertyPath value)? objectProperty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ListIndexPath value)? listIndex,
    TResult Function(MapKeyPath value)? mapKey,
    TResult Function(PropertyPath value)? objectProperty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PathToPropertyCopyWith<$Res> {
  factory $PathToPropertyCopyWith(
          PathToProperty value, $Res Function(PathToProperty) then) =
      _$PathToPropertyCopyWithImpl<$Res>;
}

/// @nodoc
class _$PathToPropertyCopyWithImpl<$Res>
    implements $PathToPropertyCopyWith<$Res> {
  _$PathToPropertyCopyWithImpl(this._value, this._then);

  final PathToProperty _value;
  // ignore: unused_field
  final $Res Function(PathToProperty) _then;
}

/// @nodoc
abstract class $ListIndexPathCopyWith<$Res> {
  factory $ListIndexPathCopyWith(
          ListIndexPath value, $Res Function(ListIndexPath) then) =
      _$ListIndexPathCopyWithImpl<$Res>;
  $Res call({int index});
}

/// @nodoc
class _$ListIndexPathCopyWithImpl<$Res>
    extends _$PathToPropertyCopyWithImpl<$Res>
    implements $ListIndexPathCopyWith<$Res> {
  _$ListIndexPathCopyWithImpl(
      ListIndexPath _value, $Res Function(ListIndexPath) _then)
      : super(_value, (v) => _then(v as ListIndexPath));

  @override
  ListIndexPath get _value => super._value as ListIndexPath;

  @override
  $Res call({
    Object? index = freezed,
  }) {
    return _then(ListIndexPath(
      index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ListIndexPath with DiagnosticableTreeMixin implements ListIndexPath {
  const _$ListIndexPath(this.index);

  @override
  final int index;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PathToProperty.listIndex(index: $index)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PathToProperty.listIndex'))
      ..add(DiagnosticsProperty('index', index));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListIndexPath &&
            const DeepCollectionEquality().equals(other.index, index));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(index));

  @JsonKey(ignore: true)
  @override
  $ListIndexPathCopyWith<ListIndexPath> get copyWith =>
      _$ListIndexPathCopyWithImpl<ListIndexPath>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) listIndex,
    required TResult Function(String? ref) mapKey,
    required TResult Function(String name, String ownerUri, String ownerName)
        objectProperty,
  }) {
    return listIndex(index);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int index)? listIndex,
    TResult Function(String? ref)? mapKey,
    TResult Function(String name, String ownerUri, String ownerName)?
        objectProperty,
  }) {
    return listIndex?.call(index);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? listIndex,
    TResult Function(String? ref)? mapKey,
    TResult Function(String name, String ownerUri, String ownerName)?
        objectProperty,
    required TResult orElse(),
  }) {
    if (listIndex != null) {
      return listIndex(index);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ListIndexPath value) listIndex,
    required TResult Function(MapKeyPath value) mapKey,
    required TResult Function(PropertyPath value) objectProperty,
  }) {
    return listIndex(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ListIndexPath value)? listIndex,
    TResult Function(MapKeyPath value)? mapKey,
    TResult Function(PropertyPath value)? objectProperty,
  }) {
    return listIndex?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ListIndexPath value)? listIndex,
    TResult Function(MapKeyPath value)? mapKey,
    TResult Function(PropertyPath value)? objectProperty,
    required TResult orElse(),
  }) {
    if (listIndex != null) {
      return listIndex(this);
    }
    return orElse();
  }
}

abstract class ListIndexPath implements PathToProperty {
  const factory ListIndexPath(int index) = _$ListIndexPath;

  int get index;
  @JsonKey(ignore: true)
  $ListIndexPathCopyWith<ListIndexPath> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapKeyPathCopyWith<$Res> {
  factory $MapKeyPathCopyWith(
          MapKeyPath value, $Res Function(MapKeyPath) then) =
      _$MapKeyPathCopyWithImpl<$Res>;
  $Res call({String? ref});
}

/// @nodoc
class _$MapKeyPathCopyWithImpl<$Res> extends _$PathToPropertyCopyWithImpl<$Res>
    implements $MapKeyPathCopyWith<$Res> {
  _$MapKeyPathCopyWithImpl(MapKeyPath _value, $Res Function(MapKeyPath) _then)
      : super(_value, (v) => _then(v as MapKeyPath));

  @override
  MapKeyPath get _value => super._value as MapKeyPath;

  @override
  $Res call({
    Object? ref = freezed,
  }) {
    return _then(MapKeyPath(
      ref: ref == freezed
          ? _value.ref
          : ref // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MapKeyPath with DiagnosticableTreeMixin implements MapKeyPath {
  const _$MapKeyPath({required this.ref});

  @override
  final String? ref;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PathToProperty.mapKey(ref: $ref)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PathToProperty.mapKey'))
      ..add(DiagnosticsProperty('ref', ref));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MapKeyPath &&
            const DeepCollectionEquality().equals(other.ref, ref));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(ref));

  @JsonKey(ignore: true)
  @override
  $MapKeyPathCopyWith<MapKeyPath> get copyWith =>
      _$MapKeyPathCopyWithImpl<MapKeyPath>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) listIndex,
    required TResult Function(String? ref) mapKey,
    required TResult Function(String name, String ownerUri, String ownerName)
        objectProperty,
  }) {
    return mapKey(ref);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int index)? listIndex,
    TResult Function(String? ref)? mapKey,
    TResult Function(String name, String ownerUri, String ownerName)?
        objectProperty,
  }) {
    return mapKey?.call(ref);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? listIndex,
    TResult Function(String? ref)? mapKey,
    TResult Function(String name, String ownerUri, String ownerName)?
        objectProperty,
    required TResult orElse(),
  }) {
    if (mapKey != null) {
      return mapKey(ref);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ListIndexPath value) listIndex,
    required TResult Function(MapKeyPath value) mapKey,
    required TResult Function(PropertyPath value) objectProperty,
  }) {
    return mapKey(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ListIndexPath value)? listIndex,
    TResult Function(MapKeyPath value)? mapKey,
    TResult Function(PropertyPath value)? objectProperty,
  }) {
    return mapKey?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ListIndexPath value)? listIndex,
    TResult Function(MapKeyPath value)? mapKey,
    TResult Function(PropertyPath value)? objectProperty,
    required TResult orElse(),
  }) {
    if (mapKey != null) {
      return mapKey(this);
    }
    return orElse();
  }
}

abstract class MapKeyPath implements PathToProperty {
  const factory MapKeyPath({required String? ref}) = _$MapKeyPath;

  String? get ref;
  @JsonKey(ignore: true)
  $MapKeyPathCopyWith<MapKeyPath> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyPathCopyWith<$Res> {
  factory $PropertyPathCopyWith(
          PropertyPath value, $Res Function(PropertyPath) then) =
      _$PropertyPathCopyWithImpl<$Res>;
  $Res call({String name, String ownerUri, String ownerName});
}

/// @nodoc
class _$PropertyPathCopyWithImpl<$Res>
    extends _$PathToPropertyCopyWithImpl<$Res>
    implements $PropertyPathCopyWith<$Res> {
  _$PropertyPathCopyWithImpl(
      PropertyPath _value, $Res Function(PropertyPath) _then)
      : super(_value, (v) => _then(v as PropertyPath));

  @override
  PropertyPath get _value => super._value as PropertyPath;

  @override
  $Res call({
    Object? name = freezed,
    Object? ownerUri = freezed,
    Object? ownerName = freezed,
  }) {
    return _then(PropertyPath(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ownerUri: ownerUri == freezed
          ? _value.ownerUri
          : ownerUri // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: ownerName == freezed
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PropertyPath with DiagnosticableTreeMixin implements PropertyPath {
  const _$PropertyPath(
      {required this.name, required this.ownerUri, required this.ownerName});

  @override
  final String name;
  @override

  /// Path to the class/mixin that defined this property
  final String ownerUri;
  @override

  /// Name of the class/mixin that defined this property
  final String ownerName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PathToProperty.objectProperty(name: $name, ownerUri: $ownerUri, ownerName: $ownerName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PathToProperty.objectProperty'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('ownerUri', ownerUri))
      ..add(DiagnosticsProperty('ownerName', ownerName));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PropertyPath &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.ownerUri, ownerUri) &&
            const DeepCollectionEquality().equals(other.ownerName, ownerName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(ownerUri),
      const DeepCollectionEquality().hash(ownerName));

  @JsonKey(ignore: true)
  @override
  $PropertyPathCopyWith<PropertyPath> get copyWith =>
      _$PropertyPathCopyWithImpl<PropertyPath>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) listIndex,
    required TResult Function(String? ref) mapKey,
    required TResult Function(String name, String ownerUri, String ownerName)
        objectProperty,
  }) {
    return objectProperty(name, ownerUri, ownerName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int index)? listIndex,
    TResult Function(String? ref)? mapKey,
    TResult Function(String name, String ownerUri, String ownerName)?
        objectProperty,
  }) {
    return objectProperty?.call(name, ownerUri, ownerName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? listIndex,
    TResult Function(String? ref)? mapKey,
    TResult Function(String name, String ownerUri, String ownerName)?
        objectProperty,
    required TResult orElse(),
  }) {
    if (objectProperty != null) {
      return objectProperty(name, ownerUri, ownerName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ListIndexPath value) listIndex,
    required TResult Function(MapKeyPath value) mapKey,
    required TResult Function(PropertyPath value) objectProperty,
  }) {
    return objectProperty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ListIndexPath value)? listIndex,
    TResult Function(MapKeyPath value)? mapKey,
    TResult Function(PropertyPath value)? objectProperty,
  }) {
    return objectProperty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ListIndexPath value)? listIndex,
    TResult Function(MapKeyPath value)? mapKey,
    TResult Function(PropertyPath value)? objectProperty,
    required TResult orElse(),
  }) {
    if (objectProperty != null) {
      return objectProperty(this);
    }
    return orElse();
  }
}

abstract class PropertyPath implements PathToProperty {
  const factory PropertyPath(
      {required String name,
      required String ownerUri,
      required String ownerName}) = _$PropertyPath;

  String get name;

  /// Path to the class/mixin that defined this property
  String get ownerUri;

  /// Name of the class/mixin that defined this property
  String get ownerName;
  @JsonKey(ignore: true)
  $PropertyPathCopyWith<PropertyPath> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$ObjectFieldTearOff {
  const _$ObjectFieldTearOff();

  _ObjectField call(
      {required String name,
      required bool isFinal,
      required String ownerName,
      required String ownerUri,
      required Result<InstanceRef> ref,
      required EvalOnDartLibrary eval,
      required bool isDefinedByDependency}) {
    return _ObjectField(
      name: name,
      isFinal: isFinal,
      ownerName: ownerName,
      ownerUri: ownerUri,
      ref: ref,
      eval: eval,
      isDefinedByDependency: isDefinedByDependency,
    );
  }
}

/// @nodoc
const $ObjectField = _$ObjectFieldTearOff();

/// @nodoc
mixin _$ObjectField {
  String get name => throw _privateConstructorUsedError;
  bool get isFinal => throw _privateConstructorUsedError;
  String get ownerName => throw _privateConstructorUsedError;
  String get ownerUri => throw _privateConstructorUsedError;
  Result<InstanceRef> get ref => throw _privateConstructorUsedError;

  /// An [EvalOnDartLibrary] that can access this field from the owner object
  EvalOnDartLibrary get eval => throw _privateConstructorUsedError;

  /// Whether this field was defined by the inspected app or by one of its dependencies
  ///
  /// This is used by the UI to hide variables that are not useful for the user.
  bool get isDefinedByDependency => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ObjectFieldCopyWith<ObjectField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ObjectFieldCopyWith<$Res> {
  factory $ObjectFieldCopyWith(
          ObjectField value, $Res Function(ObjectField) then) =
      _$ObjectFieldCopyWithImpl<$Res>;
  $Res call(
      {String name,
      bool isFinal,
      String ownerName,
      String ownerUri,
      Result<InstanceRef> ref,
      EvalOnDartLibrary eval,
      bool isDefinedByDependency});

  $ResultCopyWith<InstanceRef, $Res> get ref;
}

/// @nodoc
class _$ObjectFieldCopyWithImpl<$Res> implements $ObjectFieldCopyWith<$Res> {
  _$ObjectFieldCopyWithImpl(this._value, this._then);

  final ObjectField _value;
  // ignore: unused_field
  final $Res Function(ObjectField) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? isFinal = freezed,
    Object? ownerName = freezed,
    Object? ownerUri = freezed,
    Object? ref = freezed,
    Object? eval = freezed,
    Object? isDefinedByDependency = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isFinal: isFinal == freezed
          ? _value.isFinal
          : isFinal // ignore: cast_nullable_to_non_nullable
              as bool,
      ownerName: ownerName == freezed
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      ownerUri: ownerUri == freezed
          ? _value.ownerUri
          : ownerUri // ignore: cast_nullable_to_non_nullable
              as String,
      ref: ref == freezed
          ? _value.ref
          : ref // ignore: cast_nullable_to_non_nullable
              as Result<InstanceRef>,
      eval: eval == freezed
          ? _value.eval
          : eval // ignore: cast_nullable_to_non_nullable
              as EvalOnDartLibrary,
      isDefinedByDependency: isDefinedByDependency == freezed
          ? _value.isDefinedByDependency
          : isDefinedByDependency // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $ResultCopyWith<InstanceRef, $Res> get ref {
    return $ResultCopyWith<InstanceRef, $Res>(_value.ref, (value) {
      return _then(_value.copyWith(ref: value));
    });
  }
}

/// @nodoc
abstract class _$ObjectFieldCopyWith<$Res>
    implements $ObjectFieldCopyWith<$Res> {
  factory _$ObjectFieldCopyWith(
          _ObjectField value, $Res Function(_ObjectField) then) =
      __$ObjectFieldCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      bool isFinal,
      String ownerName,
      String ownerUri,
      Result<InstanceRef> ref,
      EvalOnDartLibrary eval,
      bool isDefinedByDependency});

  @override
  $ResultCopyWith<InstanceRef, $Res> get ref;
}

/// @nodoc
class __$ObjectFieldCopyWithImpl<$Res> extends _$ObjectFieldCopyWithImpl<$Res>
    implements _$ObjectFieldCopyWith<$Res> {
  __$ObjectFieldCopyWithImpl(
      _ObjectField _value, $Res Function(_ObjectField) _then)
      : super(_value, (v) => _then(v as _ObjectField));

  @override
  _ObjectField get _value => super._value as _ObjectField;

  @override
  $Res call({
    Object? name = freezed,
    Object? isFinal = freezed,
    Object? ownerName = freezed,
    Object? ownerUri = freezed,
    Object? ref = freezed,
    Object? eval = freezed,
    Object? isDefinedByDependency = freezed,
  }) {
    return _then(_ObjectField(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isFinal: isFinal == freezed
          ? _value.isFinal
          : isFinal // ignore: cast_nullable_to_non_nullable
              as bool,
      ownerName: ownerName == freezed
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      ownerUri: ownerUri == freezed
          ? _value.ownerUri
          : ownerUri // ignore: cast_nullable_to_non_nullable
              as String,
      ref: ref == freezed
          ? _value.ref
          : ref // ignore: cast_nullable_to_non_nullable
              as Result<InstanceRef>,
      eval: eval == freezed
          ? _value.eval
          : eval // ignore: cast_nullable_to_non_nullable
              as EvalOnDartLibrary,
      isDefinedByDependency: isDefinedByDependency == freezed
          ? _value.isDefinedByDependency
          : isDefinedByDependency // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ObjectField extends _ObjectField with DiagnosticableTreeMixin {
  _$_ObjectField(
      {required this.name,
      required this.isFinal,
      required this.ownerName,
      required this.ownerUri,
      required this.ref,
      required this.eval,
      required this.isDefinedByDependency})
      : super._();

  @override
  final String name;
  @override
  final bool isFinal;
  @override
  final String ownerName;
  @override
  final String ownerUri;
  @override
  final Result<InstanceRef> ref;
  @override

  /// An [EvalOnDartLibrary] that can access this field from the owner object
  final EvalOnDartLibrary eval;
  @override

  /// Whether this field was defined by the inspected app or by one of its dependencies
  ///
  /// This is used by the UI to hide variables that are not useful for the user.
  final bool isDefinedByDependency;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ObjectField(name: $name, isFinal: $isFinal, ownerName: $ownerName, ownerUri: $ownerUri, ref: $ref, eval: $eval, isDefinedByDependency: $isDefinedByDependency)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ObjectField'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('isFinal', isFinal))
      ..add(DiagnosticsProperty('ownerName', ownerName))
      ..add(DiagnosticsProperty('ownerUri', ownerUri))
      ..add(DiagnosticsProperty('ref', ref))
      ..add(DiagnosticsProperty('eval', eval))
      ..add(
          DiagnosticsProperty('isDefinedByDependency', isDefinedByDependency));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ObjectField &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.isFinal, isFinal) &&
            const DeepCollectionEquality().equals(other.ownerName, ownerName) &&
            const DeepCollectionEquality().equals(other.ownerUri, ownerUri) &&
            const DeepCollectionEquality().equals(other.ref, ref) &&
            const DeepCollectionEquality().equals(other.eval, eval) &&
            const DeepCollectionEquality()
                .equals(other.isDefinedByDependency, isDefinedByDependency));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(isFinal),
      const DeepCollectionEquality().hash(ownerName),
      const DeepCollectionEquality().hash(ownerUri),
      const DeepCollectionEquality().hash(ref),
      const DeepCollectionEquality().hash(eval),
      const DeepCollectionEquality().hash(isDefinedByDependency));

  @JsonKey(ignore: true)
  @override
  _$ObjectFieldCopyWith<_ObjectField> get copyWith =>
      __$ObjectFieldCopyWithImpl<_ObjectField>(this, _$identity);
}

abstract class _ObjectField extends ObjectField {
  factory _ObjectField(
      {required String name,
      required bool isFinal,
      required String ownerName,
      required String ownerUri,
      required Result<InstanceRef> ref,
      required EvalOnDartLibrary eval,
      required bool isDefinedByDependency}) = _$_ObjectField;
  _ObjectField._() : super._();

  @override
  String get name;
  @override
  bool get isFinal;
  @override
  String get ownerName;
  @override
  String get ownerUri;
  @override
  Result<InstanceRef> get ref;
  @override

  /// An [EvalOnDartLibrary] that can access this field from the owner object
  EvalOnDartLibrary get eval;
  @override

  /// Whether this field was defined by the inspected app or by one of its dependencies
  ///
  /// This is used by the UI to hide variables that are not useful for the user.
  bool get isDefinedByDependency;
  @override
  @JsonKey(ignore: true)
  _$ObjectFieldCopyWith<_ObjectField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$InstanceDetailsTearOff {
  const _$InstanceDetailsTearOff();

  NullInstance nill({required Setter? setter}) {
    return NullInstance(
      setter: setter,
    );
  }

  BoolInstance boolean(String displayString,
      {required String instanceRefId, required Setter? setter}) {
    return BoolInstance(
      displayString,
      instanceRefId: instanceRefId,
      setter: setter,
    );
  }

  NumInstance number(String displayString,
      {required String instanceRefId, required Setter? setter}) {
    return NumInstance(
      displayString,
      instanceRefId: instanceRefId,
      setter: setter,
    );
  }

  StringInstance string(String displayString,
      {required String instanceRefId, required Setter? setter}) {
    return StringInstance(
      displayString,
      instanceRefId: instanceRefId,
      setter: setter,
    );
  }

  MapInstance map(List<InstanceDetails> keys,
      {required int hash,
      required String instanceRefId,
      required Setter? setter}) {
    return MapInstance(
      keys,
      hash: hash,
      instanceRefId: instanceRefId,
      setter: setter,
    );
  }

  ListInstance list(
      {required int length,
      required int hash,
      required String instanceRefId,
      required Setter? setter}) {
    return ListInstance(
      length: length,
      hash: hash,
      instanceRefId: instanceRefId,
      setter: setter,
    );
  }

  ObjectInstance object(List<ObjectField> fields,
      {required String type,
      required int hash,
      required String instanceRefId,
      required Setter? setter,
      required EvalOnDartLibrary evalForInstance}) {
    return ObjectInstance(
      fields,
      type: type,
      hash: hash,
      instanceRefId: instanceRefId,
      setter: setter,
      evalForInstance: evalForInstance,
    );
  }

  EnumInstance enumeration(
      {required String type,
      required String value,
      required Setter? setter,
      required String instanceRefId}) {
    return EnumInstance(
      type: type,
      value: value,
      setter: setter,
      instanceRefId: instanceRefId,
    );
  }
}

/// @nodoc
const $InstanceDetails = _$InstanceDetailsTearOff();

/// @nodoc
mixin _$InstanceDetails {
  Setter? get setter => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Setter? setter) nill,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        boolean,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        number,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        string,
    required TResult Function(List<InstanceDetails> keys, int hash,
            String instanceRefId, Setter? setter)
        map,
    required TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)
        list,
    required TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)
        object,
    required TResult Function(
            String type, String value, Setter? setter, String instanceRefId)
        enumeration,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NullInstance value) nill,
    required TResult Function(BoolInstance value) boolean,
    required TResult Function(NumInstance value) number,
    required TResult Function(StringInstance value) string,
    required TResult Function(MapInstance value) map,
    required TResult Function(ListInstance value) list,
    required TResult Function(ObjectInstance value) object,
    required TResult Function(EnumInstance value) enumeration,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InstanceDetailsCopyWith<InstanceDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstanceDetailsCopyWith<$Res> {
  factory $InstanceDetailsCopyWith(
          InstanceDetails value, $Res Function(InstanceDetails) then) =
      _$InstanceDetailsCopyWithImpl<$Res>;
  $Res call({Setter? setter});
}

/// @nodoc
class _$InstanceDetailsCopyWithImpl<$Res>
    implements $InstanceDetailsCopyWith<$Res> {
  _$InstanceDetailsCopyWithImpl(this._value, this._then);

  final InstanceDetails _value;
  // ignore: unused_field
  final $Res Function(InstanceDetails) _then;

  @override
  $Res call({
    Object? setter = freezed,
  }) {
    return _then(_value.copyWith(
      setter: setter == freezed
          ? _value.setter
          : setter // ignore: cast_nullable_to_non_nullable
              as Setter?,
    ));
  }
}

/// @nodoc
abstract class $NullInstanceCopyWith<$Res>
    implements $InstanceDetailsCopyWith<$Res> {
  factory $NullInstanceCopyWith(
          NullInstance value, $Res Function(NullInstance) then) =
      _$NullInstanceCopyWithImpl<$Res>;
  @override
  $Res call({Setter? setter});
}

/// @nodoc
class _$NullInstanceCopyWithImpl<$Res>
    extends _$InstanceDetailsCopyWithImpl<$Res>
    implements $NullInstanceCopyWith<$Res> {
  _$NullInstanceCopyWithImpl(
      NullInstance _value, $Res Function(NullInstance) _then)
      : super(_value, (v) => _then(v as NullInstance));

  @override
  NullInstance get _value => super._value as NullInstance;

  @override
  $Res call({
    Object? setter = freezed,
  }) {
    return _then(NullInstance(
      setter: setter == freezed
          ? _value.setter
          : setter // ignore: cast_nullable_to_non_nullable
              as Setter?,
    ));
  }
}

/// @nodoc

class _$NullInstance extends NullInstance with DiagnosticableTreeMixin {
  _$NullInstance({required this.setter}) : super._();

  @override
  final Setter? setter;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InstanceDetails.nill(setter: $setter)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InstanceDetails.nill'))
      ..add(DiagnosticsProperty('setter', setter));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NullInstance &&
            (identical(other.setter, setter) || other.setter == setter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, setter);

  @JsonKey(ignore: true)
  @override
  $NullInstanceCopyWith<NullInstance> get copyWith =>
      _$NullInstanceCopyWithImpl<NullInstance>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Setter? setter) nill,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        boolean,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        number,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        string,
    required TResult Function(List<InstanceDetails> keys, int hash,
            String instanceRefId, Setter? setter)
        map,
    required TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)
        list,
    required TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)
        object,
    required TResult Function(
            String type, String value, Setter? setter, String instanceRefId)
        enumeration,
  }) {
    return nill(setter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
  }) {
    return nill?.call(setter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
    required TResult orElse(),
  }) {
    if (nill != null) {
      return nill(setter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NullInstance value) nill,
    required TResult Function(BoolInstance value) boolean,
    required TResult Function(NumInstance value) number,
    required TResult Function(StringInstance value) string,
    required TResult Function(MapInstance value) map,
    required TResult Function(ListInstance value) list,
    required TResult Function(ObjectInstance value) object,
    required TResult Function(EnumInstance value) enumeration,
  }) {
    return nill(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
  }) {
    return nill?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
    required TResult orElse(),
  }) {
    if (nill != null) {
      return nill(this);
    }
    return orElse();
  }
}

abstract class NullInstance extends InstanceDetails {
  factory NullInstance({required Setter? setter}) = _$NullInstance;
  NullInstance._() : super._();

  @override
  Setter? get setter;
  @override
  @JsonKey(ignore: true)
  $NullInstanceCopyWith<NullInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoolInstanceCopyWith<$Res>
    implements $InstanceDetailsCopyWith<$Res> {
  factory $BoolInstanceCopyWith(
          BoolInstance value, $Res Function(BoolInstance) then) =
      _$BoolInstanceCopyWithImpl<$Res>;
  @override
  $Res call({String displayString, String instanceRefId, Setter? setter});
}

/// @nodoc
class _$BoolInstanceCopyWithImpl<$Res>
    extends _$InstanceDetailsCopyWithImpl<$Res>
    implements $BoolInstanceCopyWith<$Res> {
  _$BoolInstanceCopyWithImpl(
      BoolInstance _value, $Res Function(BoolInstance) _then)
      : super(_value, (v) => _then(v as BoolInstance));

  @override
  BoolInstance get _value => super._value as BoolInstance;

  @override
  $Res call({
    Object? displayString = freezed,
    Object? instanceRefId = freezed,
    Object? setter = freezed,
  }) {
    return _then(BoolInstance(
      displayString == freezed
          ? _value.displayString
          : displayString // ignore: cast_nullable_to_non_nullable
              as String,
      instanceRefId: instanceRefId == freezed
          ? _value.instanceRefId
          : instanceRefId // ignore: cast_nullable_to_non_nullable
              as String,
      setter: setter == freezed
          ? _value.setter
          : setter // ignore: cast_nullable_to_non_nullable
              as Setter?,
    ));
  }
}

/// @nodoc

class _$BoolInstance extends BoolInstance with DiagnosticableTreeMixin {
  _$BoolInstance(this.displayString,
      {required this.instanceRefId, required this.setter})
      : super._();

  @override
  final String displayString;
  @override
  final String instanceRefId;
  @override
  final Setter? setter;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InstanceDetails.boolean(displayString: $displayString, instanceRefId: $instanceRefId, setter: $setter)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InstanceDetails.boolean'))
      ..add(DiagnosticsProperty('displayString', displayString))
      ..add(DiagnosticsProperty('instanceRefId', instanceRefId))
      ..add(DiagnosticsProperty('setter', setter));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BoolInstance &&
            const DeepCollectionEquality()
                .equals(other.displayString, displayString) &&
            const DeepCollectionEquality()
                .equals(other.instanceRefId, instanceRefId) &&
            (identical(other.setter, setter) || other.setter == setter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(displayString),
      const DeepCollectionEquality().hash(instanceRefId),
      setter);

  @JsonKey(ignore: true)
  @override
  $BoolInstanceCopyWith<BoolInstance> get copyWith =>
      _$BoolInstanceCopyWithImpl<BoolInstance>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Setter? setter) nill,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        boolean,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        number,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        string,
    required TResult Function(List<InstanceDetails> keys, int hash,
            String instanceRefId, Setter? setter)
        map,
    required TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)
        list,
    required TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)
        object,
    required TResult Function(
            String type, String value, Setter? setter, String instanceRefId)
        enumeration,
  }) {
    return boolean(displayString, instanceRefId, setter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
  }) {
    return boolean?.call(displayString, instanceRefId, setter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
    required TResult orElse(),
  }) {
    if (boolean != null) {
      return boolean(displayString, instanceRefId, setter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NullInstance value) nill,
    required TResult Function(BoolInstance value) boolean,
    required TResult Function(NumInstance value) number,
    required TResult Function(StringInstance value) string,
    required TResult Function(MapInstance value) map,
    required TResult Function(ListInstance value) list,
    required TResult Function(ObjectInstance value) object,
    required TResult Function(EnumInstance value) enumeration,
  }) {
    return boolean(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
  }) {
    return boolean?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
    required TResult orElse(),
  }) {
    if (boolean != null) {
      return boolean(this);
    }
    return orElse();
  }
}

abstract class BoolInstance extends InstanceDetails {
  factory BoolInstance(String displayString,
      {required String instanceRefId,
      required Setter? setter}) = _$BoolInstance;
  BoolInstance._() : super._();

  String get displayString;
  String get instanceRefId;
  @override
  Setter? get setter;
  @override
  @JsonKey(ignore: true)
  $BoolInstanceCopyWith<BoolInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NumInstanceCopyWith<$Res>
    implements $InstanceDetailsCopyWith<$Res> {
  factory $NumInstanceCopyWith(
          NumInstance value, $Res Function(NumInstance) then) =
      _$NumInstanceCopyWithImpl<$Res>;
  @override
  $Res call({String displayString, String instanceRefId, Setter? setter});
}

/// @nodoc
class _$NumInstanceCopyWithImpl<$Res>
    extends _$InstanceDetailsCopyWithImpl<$Res>
    implements $NumInstanceCopyWith<$Res> {
  _$NumInstanceCopyWithImpl(
      NumInstance _value, $Res Function(NumInstance) _then)
      : super(_value, (v) => _then(v as NumInstance));

  @override
  NumInstance get _value => super._value as NumInstance;

  @override
  $Res call({
    Object? displayString = freezed,
    Object? instanceRefId = freezed,
    Object? setter = freezed,
  }) {
    return _then(NumInstance(
      displayString == freezed
          ? _value.displayString
          : displayString // ignore: cast_nullable_to_non_nullable
              as String,
      instanceRefId: instanceRefId == freezed
          ? _value.instanceRefId
          : instanceRefId // ignore: cast_nullable_to_non_nullable
              as String,
      setter: setter == freezed
          ? _value.setter
          : setter // ignore: cast_nullable_to_non_nullable
              as Setter?,
    ));
  }
}

/// @nodoc

class _$NumInstance extends NumInstance with DiagnosticableTreeMixin {
  _$NumInstance(this.displayString,
      {required this.instanceRefId, required this.setter})
      : super._();

  @override
  final String displayString;
  @override
  final String instanceRefId;
  @override
  final Setter? setter;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InstanceDetails.number(displayString: $displayString, instanceRefId: $instanceRefId, setter: $setter)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InstanceDetails.number'))
      ..add(DiagnosticsProperty('displayString', displayString))
      ..add(DiagnosticsProperty('instanceRefId', instanceRefId))
      ..add(DiagnosticsProperty('setter', setter));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NumInstance &&
            const DeepCollectionEquality()
                .equals(other.displayString, displayString) &&
            const DeepCollectionEquality()
                .equals(other.instanceRefId, instanceRefId) &&
            (identical(other.setter, setter) || other.setter == setter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(displayString),
      const DeepCollectionEquality().hash(instanceRefId),
      setter);

  @JsonKey(ignore: true)
  @override
  $NumInstanceCopyWith<NumInstance> get copyWith =>
      _$NumInstanceCopyWithImpl<NumInstance>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Setter? setter) nill,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        boolean,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        number,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        string,
    required TResult Function(List<InstanceDetails> keys, int hash,
            String instanceRefId, Setter? setter)
        map,
    required TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)
        list,
    required TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)
        object,
    required TResult Function(
            String type, String value, Setter? setter, String instanceRefId)
        enumeration,
  }) {
    return number(displayString, instanceRefId, setter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
  }) {
    return number?.call(displayString, instanceRefId, setter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
    required TResult orElse(),
  }) {
    if (number != null) {
      return number(displayString, instanceRefId, setter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NullInstance value) nill,
    required TResult Function(BoolInstance value) boolean,
    required TResult Function(NumInstance value) number,
    required TResult Function(StringInstance value) string,
    required TResult Function(MapInstance value) map,
    required TResult Function(ListInstance value) list,
    required TResult Function(ObjectInstance value) object,
    required TResult Function(EnumInstance value) enumeration,
  }) {
    return number(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
  }) {
    return number?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
    required TResult orElse(),
  }) {
    if (number != null) {
      return number(this);
    }
    return orElse();
  }
}

abstract class NumInstance extends InstanceDetails {
  factory NumInstance(String displayString,
      {required String instanceRefId, required Setter? setter}) = _$NumInstance;
  NumInstance._() : super._();

  String get displayString;
  String get instanceRefId;
  @override
  Setter? get setter;
  @override
  @JsonKey(ignore: true)
  $NumInstanceCopyWith<NumInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StringInstanceCopyWith<$Res>
    implements $InstanceDetailsCopyWith<$Res> {
  factory $StringInstanceCopyWith(
          StringInstance value, $Res Function(StringInstance) then) =
      _$StringInstanceCopyWithImpl<$Res>;
  @override
  $Res call({String displayString, String instanceRefId, Setter? setter});
}

/// @nodoc
class _$StringInstanceCopyWithImpl<$Res>
    extends _$InstanceDetailsCopyWithImpl<$Res>
    implements $StringInstanceCopyWith<$Res> {
  _$StringInstanceCopyWithImpl(
      StringInstance _value, $Res Function(StringInstance) _then)
      : super(_value, (v) => _then(v as StringInstance));

  @override
  StringInstance get _value => super._value as StringInstance;

  @override
  $Res call({
    Object? displayString = freezed,
    Object? instanceRefId = freezed,
    Object? setter = freezed,
  }) {
    return _then(StringInstance(
      displayString == freezed
          ? _value.displayString
          : displayString // ignore: cast_nullable_to_non_nullable
              as String,
      instanceRefId: instanceRefId == freezed
          ? _value.instanceRefId
          : instanceRefId // ignore: cast_nullable_to_non_nullable
              as String,
      setter: setter == freezed
          ? _value.setter
          : setter // ignore: cast_nullable_to_non_nullable
              as Setter?,
    ));
  }
}

/// @nodoc

class _$StringInstance extends StringInstance with DiagnosticableTreeMixin {
  _$StringInstance(this.displayString,
      {required this.instanceRefId, required this.setter})
      : super._();

  @override
  final String displayString;
  @override
  final String instanceRefId;
  @override
  final Setter? setter;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InstanceDetails.string(displayString: $displayString, instanceRefId: $instanceRefId, setter: $setter)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InstanceDetails.string'))
      ..add(DiagnosticsProperty('displayString', displayString))
      ..add(DiagnosticsProperty('instanceRefId', instanceRefId))
      ..add(DiagnosticsProperty('setter', setter));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StringInstance &&
            const DeepCollectionEquality()
                .equals(other.displayString, displayString) &&
            const DeepCollectionEquality()
                .equals(other.instanceRefId, instanceRefId) &&
            (identical(other.setter, setter) || other.setter == setter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(displayString),
      const DeepCollectionEquality().hash(instanceRefId),
      setter);

  @JsonKey(ignore: true)
  @override
  $StringInstanceCopyWith<StringInstance> get copyWith =>
      _$StringInstanceCopyWithImpl<StringInstance>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Setter? setter) nill,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        boolean,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        number,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        string,
    required TResult Function(List<InstanceDetails> keys, int hash,
            String instanceRefId, Setter? setter)
        map,
    required TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)
        list,
    required TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)
        object,
    required TResult Function(
            String type, String value, Setter? setter, String instanceRefId)
        enumeration,
  }) {
    return string(displayString, instanceRefId, setter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
  }) {
    return string?.call(displayString, instanceRefId, setter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(displayString, instanceRefId, setter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NullInstance value) nill,
    required TResult Function(BoolInstance value) boolean,
    required TResult Function(NumInstance value) number,
    required TResult Function(StringInstance value) string,
    required TResult Function(MapInstance value) map,
    required TResult Function(ListInstance value) list,
    required TResult Function(ObjectInstance value) object,
    required TResult Function(EnumInstance value) enumeration,
  }) {
    return string(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
  }) {
    return string?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(this);
    }
    return orElse();
  }
}

abstract class StringInstance extends InstanceDetails {
  factory StringInstance(String displayString,
      {required String instanceRefId,
      required Setter? setter}) = _$StringInstance;
  StringInstance._() : super._();

  String get displayString;
  String get instanceRefId;
  @override
  Setter? get setter;
  @override
  @JsonKey(ignore: true)
  $StringInstanceCopyWith<StringInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapInstanceCopyWith<$Res>
    implements $InstanceDetailsCopyWith<$Res> {
  factory $MapInstanceCopyWith(
          MapInstance value, $Res Function(MapInstance) then) =
      _$MapInstanceCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<InstanceDetails> keys,
      int hash,
      String instanceRefId,
      Setter? setter});
}

/// @nodoc
class _$MapInstanceCopyWithImpl<$Res>
    extends _$InstanceDetailsCopyWithImpl<$Res>
    implements $MapInstanceCopyWith<$Res> {
  _$MapInstanceCopyWithImpl(
      MapInstance _value, $Res Function(MapInstance) _then)
      : super(_value, (v) => _then(v as MapInstance));

  @override
  MapInstance get _value => super._value as MapInstance;

  @override
  $Res call({
    Object? keys = freezed,
    Object? hash = freezed,
    Object? instanceRefId = freezed,
    Object? setter = freezed,
  }) {
    return _then(MapInstance(
      keys == freezed
          ? _value.keys
          : keys // ignore: cast_nullable_to_non_nullable
              as List<InstanceDetails>,
      hash: hash == freezed
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as int,
      instanceRefId: instanceRefId == freezed
          ? _value.instanceRefId
          : instanceRefId // ignore: cast_nullable_to_non_nullable
              as String,
      setter: setter == freezed
          ? _value.setter
          : setter // ignore: cast_nullable_to_non_nullable
              as Setter?,
    ));
  }
}

/// @nodoc

class _$MapInstance extends MapInstance with DiagnosticableTreeMixin {
  _$MapInstance(this.keys,
      {required this.hash, required this.instanceRefId, required this.setter})
      : super._();

  @override
  final List<InstanceDetails> keys;
  @override
  final int hash;
  @override
  final String instanceRefId;
  @override
  final Setter? setter;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InstanceDetails.map(keys: $keys, hash: $hash, instanceRefId: $instanceRefId, setter: $setter)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InstanceDetails.map'))
      ..add(DiagnosticsProperty('keys', keys))
      ..add(DiagnosticsProperty('hash', hash))
      ..add(DiagnosticsProperty('instanceRefId', instanceRefId))
      ..add(DiagnosticsProperty('setter', setter));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MapInstance &&
            const DeepCollectionEquality().equals(other.keys, keys) &&
            const DeepCollectionEquality().equals(other.hash, hash) &&
            const DeepCollectionEquality()
                .equals(other.instanceRefId, instanceRefId) &&
            (identical(other.setter, setter) || other.setter == setter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(keys),
      const DeepCollectionEquality().hash(hash),
      const DeepCollectionEquality().hash(instanceRefId),
      setter);

  @JsonKey(ignore: true)
  @override
  $MapInstanceCopyWith<MapInstance> get copyWith =>
      _$MapInstanceCopyWithImpl<MapInstance>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Setter? setter) nill,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        boolean,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        number,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        string,
    required TResult Function(List<InstanceDetails> keys, int hash,
            String instanceRefId, Setter? setter)
        map,
    required TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)
        list,
    required TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)
        object,
    required TResult Function(
            String type, String value, Setter? setter, String instanceRefId)
        enumeration,
  }) {
    return map(keys, hash, instanceRefId, setter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
  }) {
    return map?.call(keys, hash, instanceRefId, setter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
    required TResult orElse(),
  }) {
    if (map != null) {
      return map(keys, hash, instanceRefId, setter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NullInstance value) nill,
    required TResult Function(BoolInstance value) boolean,
    required TResult Function(NumInstance value) number,
    required TResult Function(StringInstance value) string,
    required TResult Function(MapInstance value) map,
    required TResult Function(ListInstance value) list,
    required TResult Function(ObjectInstance value) object,
    required TResult Function(EnumInstance value) enumeration,
  }) {
    return map(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
  }) {
    return map?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
    required TResult orElse(),
  }) {
    if (map != null) {
      return map(this);
    }
    return orElse();
  }
}

abstract class MapInstance extends InstanceDetails {
  factory MapInstance(List<InstanceDetails> keys,
      {required int hash,
      required String instanceRefId,
      required Setter? setter}) = _$MapInstance;
  MapInstance._() : super._();

  List<InstanceDetails> get keys;
  int get hash;
  String get instanceRefId;
  @override
  Setter? get setter;
  @override
  @JsonKey(ignore: true)
  $MapInstanceCopyWith<MapInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListInstanceCopyWith<$Res>
    implements $InstanceDetailsCopyWith<$Res> {
  factory $ListInstanceCopyWith(
          ListInstance value, $Res Function(ListInstance) then) =
      _$ListInstanceCopyWithImpl<$Res>;
  @override
  $Res call({int length, int hash, String instanceRefId, Setter? setter});
}

/// @nodoc
class _$ListInstanceCopyWithImpl<$Res>
    extends _$InstanceDetailsCopyWithImpl<$Res>
    implements $ListInstanceCopyWith<$Res> {
  _$ListInstanceCopyWithImpl(
      ListInstance _value, $Res Function(ListInstance) _then)
      : super(_value, (v) => _then(v as ListInstance));

  @override
  ListInstance get _value => super._value as ListInstance;

  @override
  $Res call({
    Object? length = freezed,
    Object? hash = freezed,
    Object? instanceRefId = freezed,
    Object? setter = freezed,
  }) {
    return _then(ListInstance(
      length: length == freezed
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int,
      hash: hash == freezed
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as int,
      instanceRefId: instanceRefId == freezed
          ? _value.instanceRefId
          : instanceRefId // ignore: cast_nullable_to_non_nullable
              as String,
      setter: setter == freezed
          ? _value.setter
          : setter // ignore: cast_nullable_to_non_nullable
              as Setter?,
    ));
  }
}

/// @nodoc

class _$ListInstance extends ListInstance with DiagnosticableTreeMixin {
  _$ListInstance(
      {required this.length,
      required this.hash,
      required this.instanceRefId,
      required this.setter})
      : super._();

  @override
  final int length;
  @override
  final int hash;
  @override
  final String instanceRefId;
  @override
  final Setter? setter;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InstanceDetails.list(length: $length, hash: $hash, instanceRefId: $instanceRefId, setter: $setter)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InstanceDetails.list'))
      ..add(DiagnosticsProperty('length', length))
      ..add(DiagnosticsProperty('hash', hash))
      ..add(DiagnosticsProperty('instanceRefId', instanceRefId))
      ..add(DiagnosticsProperty('setter', setter));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListInstance &&
            const DeepCollectionEquality().equals(other.length, length) &&
            const DeepCollectionEquality().equals(other.hash, hash) &&
            const DeepCollectionEquality()
                .equals(other.instanceRefId, instanceRefId) &&
            (identical(other.setter, setter) || other.setter == setter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(length),
      const DeepCollectionEquality().hash(hash),
      const DeepCollectionEquality().hash(instanceRefId),
      setter);

  @JsonKey(ignore: true)
  @override
  $ListInstanceCopyWith<ListInstance> get copyWith =>
      _$ListInstanceCopyWithImpl<ListInstance>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Setter? setter) nill,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        boolean,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        number,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        string,
    required TResult Function(List<InstanceDetails> keys, int hash,
            String instanceRefId, Setter? setter)
        map,
    required TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)
        list,
    required TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)
        object,
    required TResult Function(
            String type, String value, Setter? setter, String instanceRefId)
        enumeration,
  }) {
    return list(length, hash, instanceRefId, setter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
  }) {
    return list?.call(length, hash, instanceRefId, setter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
    required TResult orElse(),
  }) {
    if (list != null) {
      return list(length, hash, instanceRefId, setter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NullInstance value) nill,
    required TResult Function(BoolInstance value) boolean,
    required TResult Function(NumInstance value) number,
    required TResult Function(StringInstance value) string,
    required TResult Function(MapInstance value) map,
    required TResult Function(ListInstance value) list,
    required TResult Function(ObjectInstance value) object,
    required TResult Function(EnumInstance value) enumeration,
  }) {
    return list(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
  }) {
    return list?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
    required TResult orElse(),
  }) {
    if (list != null) {
      return list(this);
    }
    return orElse();
  }
}

abstract class ListInstance extends InstanceDetails {
  factory ListInstance(
      {required int length,
      required int hash,
      required String instanceRefId,
      required Setter? setter}) = _$ListInstance;
  ListInstance._() : super._();

  int get length;
  int get hash;
  String get instanceRefId;
  @override
  Setter? get setter;
  @override
  @JsonKey(ignore: true)
  $ListInstanceCopyWith<ListInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ObjectInstanceCopyWith<$Res>
    implements $InstanceDetailsCopyWith<$Res> {
  factory $ObjectInstanceCopyWith(
          ObjectInstance value, $Res Function(ObjectInstance) then) =
      _$ObjectInstanceCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<ObjectField> fields,
      String type,
      int hash,
      String instanceRefId,
      Setter? setter,
      EvalOnDartLibrary evalForInstance});
}

/// @nodoc
class _$ObjectInstanceCopyWithImpl<$Res>
    extends _$InstanceDetailsCopyWithImpl<$Res>
    implements $ObjectInstanceCopyWith<$Res> {
  _$ObjectInstanceCopyWithImpl(
      ObjectInstance _value, $Res Function(ObjectInstance) _then)
      : super(_value, (v) => _then(v as ObjectInstance));

  @override
  ObjectInstance get _value => super._value as ObjectInstance;

  @override
  $Res call({
    Object? fields = freezed,
    Object? type = freezed,
    Object? hash = freezed,
    Object? instanceRefId = freezed,
    Object? setter = freezed,
    Object? evalForInstance = freezed,
  }) {
    return _then(ObjectInstance(
      fields == freezed
          ? _value.fields
          : fields // ignore: cast_nullable_to_non_nullable
              as List<ObjectField>,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      hash: hash == freezed
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as int,
      instanceRefId: instanceRefId == freezed
          ? _value.instanceRefId
          : instanceRefId // ignore: cast_nullable_to_non_nullable
              as String,
      setter: setter == freezed
          ? _value.setter
          : setter // ignore: cast_nullable_to_non_nullable
              as Setter?,
      evalForInstance: evalForInstance == freezed
          ? _value.evalForInstance
          : evalForInstance // ignore: cast_nullable_to_non_nullable
              as EvalOnDartLibrary,
    ));
  }
}

/// @nodoc

class _$ObjectInstance extends ObjectInstance with DiagnosticableTreeMixin {
  _$ObjectInstance(this.fields,
      {required this.type,
      required this.hash,
      required this.instanceRefId,
      required this.setter,
      required this.evalForInstance})
      : super._();

  @override
  final List<ObjectField> fields;
  @override
  final String type;
  @override
  final int hash;
  @override
  final String instanceRefId;
  @override
  final Setter? setter;
  @override

  /// An [EvalOnDartLibrary] associated with the library of this object
  ///
  /// This allows to edit private properties.
  final EvalOnDartLibrary evalForInstance;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InstanceDetails.object(fields: $fields, type: $type, hash: $hash, instanceRefId: $instanceRefId, setter: $setter, evalForInstance: $evalForInstance)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InstanceDetails.object'))
      ..add(DiagnosticsProperty('fields', fields))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('hash', hash))
      ..add(DiagnosticsProperty('instanceRefId', instanceRefId))
      ..add(DiagnosticsProperty('setter', setter))
      ..add(DiagnosticsProperty('evalForInstance', evalForInstance));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ObjectInstance &&
            const DeepCollectionEquality().equals(other.fields, fields) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.hash, hash) &&
            const DeepCollectionEquality()
                .equals(other.instanceRefId, instanceRefId) &&
            (identical(other.setter, setter) || other.setter == setter) &&
            const DeepCollectionEquality()
                .equals(other.evalForInstance, evalForInstance));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(fields),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(hash),
      const DeepCollectionEquality().hash(instanceRefId),
      setter,
      const DeepCollectionEquality().hash(evalForInstance));

  @JsonKey(ignore: true)
  @override
  $ObjectInstanceCopyWith<ObjectInstance> get copyWith =>
      _$ObjectInstanceCopyWithImpl<ObjectInstance>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Setter? setter) nill,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        boolean,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        number,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        string,
    required TResult Function(List<InstanceDetails> keys, int hash,
            String instanceRefId, Setter? setter)
        map,
    required TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)
        list,
    required TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)
        object,
    required TResult Function(
            String type, String value, Setter? setter, String instanceRefId)
        enumeration,
  }) {
    return object(fields, type, hash, instanceRefId, setter, evalForInstance);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
  }) {
    return object?.call(
        fields, type, hash, instanceRefId, setter, evalForInstance);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
    required TResult orElse(),
  }) {
    if (object != null) {
      return object(fields, type, hash, instanceRefId, setter, evalForInstance);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NullInstance value) nill,
    required TResult Function(BoolInstance value) boolean,
    required TResult Function(NumInstance value) number,
    required TResult Function(StringInstance value) string,
    required TResult Function(MapInstance value) map,
    required TResult Function(ListInstance value) list,
    required TResult Function(ObjectInstance value) object,
    required TResult Function(EnumInstance value) enumeration,
  }) {
    return object(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
  }) {
    return object?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
    required TResult orElse(),
  }) {
    if (object != null) {
      return object(this);
    }
    return orElse();
  }
}

abstract class ObjectInstance extends InstanceDetails {
  factory ObjectInstance(List<ObjectField> fields,
      {required String type,
      required int hash,
      required String instanceRefId,
      required Setter? setter,
      required EvalOnDartLibrary evalForInstance}) = _$ObjectInstance;
  ObjectInstance._() : super._();

  List<ObjectField> get fields;
  String get type;
  int get hash;
  String get instanceRefId;
  @override
  Setter? get setter;

  /// An [EvalOnDartLibrary] associated with the library of this object
  ///
  /// This allows to edit private properties.
  EvalOnDartLibrary get evalForInstance;
  @override
  @JsonKey(ignore: true)
  $ObjectInstanceCopyWith<ObjectInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnumInstanceCopyWith<$Res>
    implements $InstanceDetailsCopyWith<$Res> {
  factory $EnumInstanceCopyWith(
          EnumInstance value, $Res Function(EnumInstance) then) =
      _$EnumInstanceCopyWithImpl<$Res>;
  @override
  $Res call({String type, String value, Setter? setter, String instanceRefId});
}

/// @nodoc
class _$EnumInstanceCopyWithImpl<$Res>
    extends _$InstanceDetailsCopyWithImpl<$Res>
    implements $EnumInstanceCopyWith<$Res> {
  _$EnumInstanceCopyWithImpl(
      EnumInstance _value, $Res Function(EnumInstance) _then)
      : super(_value, (v) => _then(v as EnumInstance));

  @override
  EnumInstance get _value => super._value as EnumInstance;

  @override
  $Res call({
    Object? type = freezed,
    Object? value = freezed,
    Object? setter = freezed,
    Object? instanceRefId = freezed,
  }) {
    return _then(EnumInstance(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      setter: setter == freezed
          ? _value.setter
          : setter // ignore: cast_nullable_to_non_nullable
              as Setter?,
      instanceRefId: instanceRefId == freezed
          ? _value.instanceRefId
          : instanceRefId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$EnumInstance extends EnumInstance with DiagnosticableTreeMixin {
  _$EnumInstance(
      {required this.type,
      required this.value,
      required this.setter,
      required this.instanceRefId})
      : super._();

  @override
  final String type;
  @override
  final String value;
  @override
  final Setter? setter;
  @override
  final String instanceRefId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InstanceDetails.enumeration(type: $type, value: $value, setter: $setter, instanceRefId: $instanceRefId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InstanceDetails.enumeration'))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('value', value))
      ..add(DiagnosticsProperty('setter', setter))
      ..add(DiagnosticsProperty('instanceRefId', instanceRefId));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnumInstance &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.setter, setter) || other.setter == setter) &&
            const DeepCollectionEquality()
                .equals(other.instanceRefId, instanceRefId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(value),
      setter,
      const DeepCollectionEquality().hash(instanceRefId));

  @JsonKey(ignore: true)
  @override
  $EnumInstanceCopyWith<EnumInstance> get copyWith =>
      _$EnumInstanceCopyWithImpl<EnumInstance>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Setter? setter) nill,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        boolean,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        number,
    required TResult Function(
            String displayString, String instanceRefId, Setter? setter)
        string,
    required TResult Function(List<InstanceDetails> keys, int hash,
            String instanceRefId, Setter? setter)
        map,
    required TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)
        list,
    required TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)
        object,
    required TResult Function(
            String type, String value, Setter? setter, String instanceRefId)
        enumeration,
  }) {
    return enumeration(type, value, setter, instanceRefId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
  }) {
    return enumeration?.call(type, value, setter, instanceRefId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Setter? setter)? nill,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        boolean,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        number,
    TResult Function(
            String displayString, String instanceRefId, Setter? setter)?
        string,
    TResult Function(List<InstanceDetails> keys, int hash, String instanceRefId,
            Setter? setter)?
        map,
    TResult Function(
            int length, int hash, String instanceRefId, Setter? setter)?
        list,
    TResult Function(
            List<ObjectField> fields,
            String type,
            int hash,
            String instanceRefId,
            Setter? setter,
            EvalOnDartLibrary evalForInstance)?
        object,
    TResult Function(
            String type, String value, Setter? setter, String instanceRefId)?
        enumeration,
    required TResult orElse(),
  }) {
    if (enumeration != null) {
      return enumeration(type, value, setter, instanceRefId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NullInstance value) nill,
    required TResult Function(BoolInstance value) boolean,
    required TResult Function(NumInstance value) number,
    required TResult Function(StringInstance value) string,
    required TResult Function(MapInstance value) map,
    required TResult Function(ListInstance value) list,
    required TResult Function(ObjectInstance value) object,
    required TResult Function(EnumInstance value) enumeration,
  }) {
    return enumeration(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
  }) {
    return enumeration?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NullInstance value)? nill,
    TResult Function(BoolInstance value)? boolean,
    TResult Function(NumInstance value)? number,
    TResult Function(StringInstance value)? string,
    TResult Function(MapInstance value)? map,
    TResult Function(ListInstance value)? list,
    TResult Function(ObjectInstance value)? object,
    TResult Function(EnumInstance value)? enumeration,
    required TResult orElse(),
  }) {
    if (enumeration != null) {
      return enumeration(this);
    }
    return orElse();
  }
}

abstract class EnumInstance extends InstanceDetails {
  factory EnumInstance(
      {required String type,
      required String value,
      required Setter? setter,
      required String instanceRefId}) = _$EnumInstance;
  EnumInstance._() : super._();

  String get type;
  String get value;
  @override
  Setter? get setter;
  String get instanceRefId;
  @override
  @JsonKey(ignore: true)
  $EnumInstanceCopyWith<EnumInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$InstancePathTearOff {
  const _$InstancePathTearOff();

  _InstancePathFromInstanceId fromInstanceId(String instanceId,
      {List<PathToProperty> pathToProperty = const []}) {
    return _InstancePathFromInstanceId(
      instanceId,
      pathToProperty: pathToProperty,
    );
  }

  _InstancePathFromProviderId fromProviderId(String providerId,
      {List<PathToProperty> pathToProperty = const []}) {
    return _InstancePathFromProviderId(
      providerId,
      pathToProperty: pathToProperty,
    );
  }
}

/// @nodoc
const $InstancePath = _$InstancePathTearOff();

/// @nodoc
mixin _$InstancePath {
  List<PathToProperty> get pathToProperty => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String instanceId, List<PathToProperty> pathToProperty)
        fromInstanceId,
    required TResult Function(
            String providerId, List<PathToProperty> pathToProperty)
        fromProviderId,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String instanceId, List<PathToProperty> pathToProperty)?
        fromInstanceId,
    TResult Function(String providerId, List<PathToProperty> pathToProperty)?
        fromProviderId,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String instanceId, List<PathToProperty> pathToProperty)?
        fromInstanceId,
    TResult Function(String providerId, List<PathToProperty> pathToProperty)?
        fromProviderId,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InstancePathFromInstanceId value) fromInstanceId,
    required TResult Function(_InstancePathFromProviderId value) fromProviderId,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_InstancePathFromInstanceId value)? fromInstanceId,
    TResult Function(_InstancePathFromProviderId value)? fromProviderId,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InstancePathFromInstanceId value)? fromInstanceId,
    TResult Function(_InstancePathFromProviderId value)? fromProviderId,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InstancePathCopyWith<InstancePath> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstancePathCopyWith<$Res> {
  factory $InstancePathCopyWith(
          InstancePath value, $Res Function(InstancePath) then) =
      _$InstancePathCopyWithImpl<$Res>;
  $Res call({List<PathToProperty> pathToProperty});
}

/// @nodoc
class _$InstancePathCopyWithImpl<$Res> implements $InstancePathCopyWith<$Res> {
  _$InstancePathCopyWithImpl(this._value, this._then);

  final InstancePath _value;
  // ignore: unused_field
  final $Res Function(InstancePath) _then;

  @override
  $Res call({
    Object? pathToProperty = freezed,
  }) {
    return _then(_value.copyWith(
      pathToProperty: pathToProperty == freezed
          ? _value.pathToProperty
          : pathToProperty // ignore: cast_nullable_to_non_nullable
              as List<PathToProperty>,
    ));
  }
}

/// @nodoc
abstract class _$InstancePathFromInstanceIdCopyWith<$Res>
    implements $InstancePathCopyWith<$Res> {
  factory _$InstancePathFromInstanceIdCopyWith(
          _InstancePathFromInstanceId value,
          $Res Function(_InstancePathFromInstanceId) then) =
      __$InstancePathFromInstanceIdCopyWithImpl<$Res>;
  @override
  $Res call({String instanceId, List<PathToProperty> pathToProperty});
}

/// @nodoc
class __$InstancePathFromInstanceIdCopyWithImpl<$Res>
    extends _$InstancePathCopyWithImpl<$Res>
    implements _$InstancePathFromInstanceIdCopyWith<$Res> {
  __$InstancePathFromInstanceIdCopyWithImpl(_InstancePathFromInstanceId _value,
      $Res Function(_InstancePathFromInstanceId) _then)
      : super(_value, (v) => _then(v as _InstancePathFromInstanceId));

  @override
  _InstancePathFromInstanceId get _value =>
      super._value as _InstancePathFromInstanceId;

  @override
  $Res call({
    Object? instanceId = freezed,
    Object? pathToProperty = freezed,
  }) {
    return _then(_InstancePathFromInstanceId(
      instanceId == freezed
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      pathToProperty: pathToProperty == freezed
          ? _value.pathToProperty
          : pathToProperty // ignore: cast_nullable_to_non_nullable
              as List<PathToProperty>,
    ));
  }
}

/// @nodoc

class _$_InstancePathFromInstanceId extends _InstancePathFromInstanceId
    with DiagnosticableTreeMixin {
  const _$_InstancePathFromInstanceId(this.instanceId,
      {this.pathToProperty = const []})
      : super._();

  @override
  final String instanceId;
  @JsonKey()
  @override
  final List<PathToProperty> pathToProperty;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InstancePath.fromInstanceId(instanceId: $instanceId, pathToProperty: $pathToProperty)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InstancePath.fromInstanceId'))
      ..add(DiagnosticsProperty('instanceId', instanceId))
      ..add(DiagnosticsProperty('pathToProperty', pathToProperty));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InstancePathFromInstanceId &&
            const DeepCollectionEquality()
                .equals(other.instanceId, instanceId) &&
            const DeepCollectionEquality()
                .equals(other.pathToProperty, pathToProperty));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(instanceId),
      const DeepCollectionEquality().hash(pathToProperty));

  @JsonKey(ignore: true)
  @override
  _$InstancePathFromInstanceIdCopyWith<_InstancePathFromInstanceId>
      get copyWith => __$InstancePathFromInstanceIdCopyWithImpl<
          _InstancePathFromInstanceId>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String instanceId, List<PathToProperty> pathToProperty)
        fromInstanceId,
    required TResult Function(
            String providerId, List<PathToProperty> pathToProperty)
        fromProviderId,
  }) {
    return fromInstanceId(instanceId, pathToProperty);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String instanceId, List<PathToProperty> pathToProperty)?
        fromInstanceId,
    TResult Function(String providerId, List<PathToProperty> pathToProperty)?
        fromProviderId,
  }) {
    return fromInstanceId?.call(instanceId, pathToProperty);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String instanceId, List<PathToProperty> pathToProperty)?
        fromInstanceId,
    TResult Function(String providerId, List<PathToProperty> pathToProperty)?
        fromProviderId,
    required TResult orElse(),
  }) {
    if (fromInstanceId != null) {
      return fromInstanceId(instanceId, pathToProperty);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InstancePathFromInstanceId value) fromInstanceId,
    required TResult Function(_InstancePathFromProviderId value) fromProviderId,
  }) {
    return fromInstanceId(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_InstancePathFromInstanceId value)? fromInstanceId,
    TResult Function(_InstancePathFromProviderId value)? fromProviderId,
  }) {
    return fromInstanceId?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InstancePathFromInstanceId value)? fromInstanceId,
    TResult Function(_InstancePathFromProviderId value)? fromProviderId,
    required TResult orElse(),
  }) {
    if (fromInstanceId != null) {
      return fromInstanceId(this);
    }
    return orElse();
  }
}

abstract class _InstancePathFromInstanceId extends InstancePath {
  const factory _InstancePathFromInstanceId(String instanceId,
      {List<PathToProperty> pathToProperty}) = _$_InstancePathFromInstanceId;
  const _InstancePathFromInstanceId._() : super._();

  String get instanceId;
  @override
  List<PathToProperty> get pathToProperty;
  @override
  @JsonKey(ignore: true)
  _$InstancePathFromInstanceIdCopyWith<_InstancePathFromInstanceId>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$InstancePathFromProviderIdCopyWith<$Res>
    implements $InstancePathCopyWith<$Res> {
  factory _$InstancePathFromProviderIdCopyWith(
          _InstancePathFromProviderId value,
          $Res Function(_InstancePathFromProviderId) then) =
      __$InstancePathFromProviderIdCopyWithImpl<$Res>;
  @override
  $Res call({String providerId, List<PathToProperty> pathToProperty});
}

/// @nodoc
class __$InstancePathFromProviderIdCopyWithImpl<$Res>
    extends _$InstancePathCopyWithImpl<$Res>
    implements _$InstancePathFromProviderIdCopyWith<$Res> {
  __$InstancePathFromProviderIdCopyWithImpl(_InstancePathFromProviderId _value,
      $Res Function(_InstancePathFromProviderId) _then)
      : super(_value, (v) => _then(v as _InstancePathFromProviderId));

  @override
  _InstancePathFromProviderId get _value =>
      super._value as _InstancePathFromProviderId;

  @override
  $Res call({
    Object? providerId = freezed,
    Object? pathToProperty = freezed,
  }) {
    return _then(_InstancePathFromProviderId(
      providerId == freezed
          ? _value.providerId
          : providerId // ignore: cast_nullable_to_non_nullable
              as String,
      pathToProperty: pathToProperty == freezed
          ? _value.pathToProperty
          : pathToProperty // ignore: cast_nullable_to_non_nullable
              as List<PathToProperty>,
    ));
  }
}

/// @nodoc

class _$_InstancePathFromProviderId extends _InstancePathFromProviderId
    with DiagnosticableTreeMixin {
  const _$_InstancePathFromProviderId(this.providerId,
      {this.pathToProperty = const []})
      : super._();

  @override
  final String providerId;
  @JsonKey()
  @override
  final List<PathToProperty> pathToProperty;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InstancePath.fromProviderId(providerId: $providerId, pathToProperty: $pathToProperty)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InstancePath.fromProviderId'))
      ..add(DiagnosticsProperty('providerId', providerId))
      ..add(DiagnosticsProperty('pathToProperty', pathToProperty));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InstancePathFromProviderId &&
            const DeepCollectionEquality()
                .equals(other.providerId, providerId) &&
            const DeepCollectionEquality()
                .equals(other.pathToProperty, pathToProperty));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(providerId),
      const DeepCollectionEquality().hash(pathToProperty));

  @JsonKey(ignore: true)
  @override
  _$InstancePathFromProviderIdCopyWith<_InstancePathFromProviderId>
      get copyWith => __$InstancePathFromProviderIdCopyWithImpl<
          _InstancePathFromProviderId>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String instanceId, List<PathToProperty> pathToProperty)
        fromInstanceId,
    required TResult Function(
            String providerId, List<PathToProperty> pathToProperty)
        fromProviderId,
  }) {
    return fromProviderId(providerId, pathToProperty);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String instanceId, List<PathToProperty> pathToProperty)?
        fromInstanceId,
    TResult Function(String providerId, List<PathToProperty> pathToProperty)?
        fromProviderId,
  }) {
    return fromProviderId?.call(providerId, pathToProperty);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String instanceId, List<PathToProperty> pathToProperty)?
        fromInstanceId,
    TResult Function(String providerId, List<PathToProperty> pathToProperty)?
        fromProviderId,
    required TResult orElse(),
  }) {
    if (fromProviderId != null) {
      return fromProviderId(providerId, pathToProperty);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InstancePathFromInstanceId value) fromInstanceId,
    required TResult Function(_InstancePathFromProviderId value) fromProviderId,
  }) {
    return fromProviderId(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_InstancePathFromInstanceId value)? fromInstanceId,
    TResult Function(_InstancePathFromProviderId value)? fromProviderId,
  }) {
    return fromProviderId?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InstancePathFromInstanceId value)? fromInstanceId,
    TResult Function(_InstancePathFromProviderId value)? fromProviderId,
    required TResult orElse(),
  }) {
    if (fromProviderId != null) {
      return fromProviderId(this);
    }
    return orElse();
  }
}

abstract class _InstancePathFromProviderId extends InstancePath {
  const factory _InstancePathFromProviderId(String providerId,
      {List<PathToProperty> pathToProperty}) = _$_InstancePathFromProviderId;
  const _InstancePathFromProviderId._() : super._();

  String get providerId;
  @override
  List<PathToProperty> get pathToProperty;
  @override
  @JsonKey(ignore: true)
  _$InstancePathFromProviderIdCopyWith<_InstancePathFromProviderId>
      get copyWith => throw _privateConstructorUsedError;
}
