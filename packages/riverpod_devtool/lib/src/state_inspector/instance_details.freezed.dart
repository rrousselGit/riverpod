// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instance_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PathToProperty implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PathToProperty'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PathToProperty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PathToProperty()';
}


}

/// @nodoc
class $PathToPropertyCopyWith<$Res>  {
$PathToPropertyCopyWith(PathToProperty _, $Res Function(PathToProperty) __);
}


/// Adds pattern-matching-related methods to [PathToProperty].
extension PathToPropertyPatterns on PathToProperty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ListIndexPath value)?  listIndex,TResult Function( MapKeyPath value)?  mapKey,TResult Function( PropertyPath value)?  objectProperty,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ListIndexPath() when listIndex != null:
return listIndex(_that);case MapKeyPath() when mapKey != null:
return mapKey(_that);case PropertyPath() when objectProperty != null:
return objectProperty(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ListIndexPath value)  listIndex,required TResult Function( MapKeyPath value)  mapKey,required TResult Function( PropertyPath value)  objectProperty,}){
final _that = this;
switch (_that) {
case ListIndexPath():
return listIndex(_that);case MapKeyPath():
return mapKey(_that);case PropertyPath():
return objectProperty(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ListIndexPath value)?  listIndex,TResult? Function( MapKeyPath value)?  mapKey,TResult? Function( PropertyPath value)?  objectProperty,}){
final _that = this;
switch (_that) {
case ListIndexPath() when listIndex != null:
return listIndex(_that);case MapKeyPath() when mapKey != null:
return mapKey(_that);case PropertyPath() when objectProperty != null:
return objectProperty(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int index)?  listIndex,TResult Function( String? ref)?  mapKey,TResult Function( String name,  String ownerUri,  String ownerName)?  objectProperty,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ListIndexPath() when listIndex != null:
return listIndex(_that.index);case MapKeyPath() when mapKey != null:
return mapKey(_that.ref);case PropertyPath() when objectProperty != null:
return objectProperty(_that.name,_that.ownerUri,_that.ownerName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int index)  listIndex,required TResult Function( String? ref)  mapKey,required TResult Function( String name,  String ownerUri,  String ownerName)  objectProperty,}) {final _that = this;
switch (_that) {
case ListIndexPath():
return listIndex(_that.index);case MapKeyPath():
return mapKey(_that.ref);case PropertyPath():
return objectProperty(_that.name,_that.ownerUri,_that.ownerName);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int index)?  listIndex,TResult? Function( String? ref)?  mapKey,TResult? Function( String name,  String ownerUri,  String ownerName)?  objectProperty,}) {final _that = this;
switch (_that) {
case ListIndexPath() when listIndex != null:
return listIndex(_that.index);case MapKeyPath() when mapKey != null:
return mapKey(_that.ref);case PropertyPath() when objectProperty != null:
return objectProperty(_that.name,_that.ownerUri,_that.ownerName);case _:
  return null;

}
}

}

/// @nodoc


class ListIndexPath with DiagnosticableTreeMixin implements PathToProperty {
  const ListIndexPath(this.index);
  

 final  int index;

/// Create a copy of PathToProperty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListIndexPathCopyWith<ListIndexPath> get copyWith => _$ListIndexPathCopyWithImpl<ListIndexPath>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PathToProperty.listIndex'))
    ..add(DiagnosticsProperty('index', index));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListIndexPath&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PathToProperty.listIndex(index: $index)';
}


}

/// @nodoc
abstract mixin class $ListIndexPathCopyWith<$Res> implements $PathToPropertyCopyWith<$Res> {
  factory $ListIndexPathCopyWith(ListIndexPath value, $Res Function(ListIndexPath) _then) = _$ListIndexPathCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$ListIndexPathCopyWithImpl<$Res>
    implements $ListIndexPathCopyWith<$Res> {
  _$ListIndexPathCopyWithImpl(this._self, this._then);

  final ListIndexPath _self;
  final $Res Function(ListIndexPath) _then;

/// Create a copy of PathToProperty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(ListIndexPath(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class MapKeyPath with DiagnosticableTreeMixin implements PathToProperty {
  const MapKeyPath({required this.ref});
  

 final  String? ref;

/// Create a copy of PathToProperty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapKeyPathCopyWith<MapKeyPath> get copyWith => _$MapKeyPathCopyWithImpl<MapKeyPath>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PathToProperty.mapKey'))
    ..add(DiagnosticsProperty('ref', ref));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapKeyPath&&(identical(other.ref, ref) || other.ref == ref));
}


@override
int get hashCode => Object.hash(runtimeType,ref);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PathToProperty.mapKey(ref: $ref)';
}


}

/// @nodoc
abstract mixin class $MapKeyPathCopyWith<$Res> implements $PathToPropertyCopyWith<$Res> {
  factory $MapKeyPathCopyWith(MapKeyPath value, $Res Function(MapKeyPath) _then) = _$MapKeyPathCopyWithImpl;
@useResult
$Res call({
 String? ref
});




}
/// @nodoc
class _$MapKeyPathCopyWithImpl<$Res>
    implements $MapKeyPathCopyWith<$Res> {
  _$MapKeyPathCopyWithImpl(this._self, this._then);

  final MapKeyPath _self;
  final $Res Function(MapKeyPath) _then;

/// Create a copy of PathToProperty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ref = freezed,}) {
  return _then(MapKeyPath(
ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class PropertyPath with DiagnosticableTreeMixin implements PathToProperty {
  const PropertyPath({required this.name, required this.ownerUri, required this.ownerName});
  

 final  String name;
/// Path to the class/mixin that defined this property
 final  String ownerUri;
/// Name of the class/mixin that defined this property
 final  String ownerName;

/// Create a copy of PathToProperty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyPathCopyWith<PropertyPath> get copyWith => _$PropertyPathCopyWithImpl<PropertyPath>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PathToProperty.objectProperty'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('ownerUri', ownerUri))..add(DiagnosticsProperty('ownerName', ownerName));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyPath&&(identical(other.name, name) || other.name == name)&&(identical(other.ownerUri, ownerUri) || other.ownerUri == ownerUri)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName));
}


@override
int get hashCode => Object.hash(runtimeType,name,ownerUri,ownerName);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PathToProperty.objectProperty(name: $name, ownerUri: $ownerUri, ownerName: $ownerName)';
}


}

/// @nodoc
abstract mixin class $PropertyPathCopyWith<$Res> implements $PathToPropertyCopyWith<$Res> {
  factory $PropertyPathCopyWith(PropertyPath value, $Res Function(PropertyPath) _then) = _$PropertyPathCopyWithImpl;
@useResult
$Res call({
 String name, String ownerUri, String ownerName
});




}
/// @nodoc
class _$PropertyPathCopyWithImpl<$Res>
    implements $PropertyPathCopyWith<$Res> {
  _$PropertyPathCopyWithImpl(this._self, this._then);

  final PropertyPath _self;
  final $Res Function(PropertyPath) _then;

/// Create a copy of PathToProperty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? ownerUri = null,Object? ownerName = null,}) {
  return _then(PropertyPath(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ownerUri: null == ownerUri ? _self.ownerUri : ownerUri // ignore: cast_nullable_to_non_nullable
as String,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ObjectField implements DiagnosticableTreeMixin {

 String get name; bool get isFinal; String get ownerName; String get ownerUri; Result<InstanceRef> get ref;/// An [EvalOnDartLibrary] that can access this field from the owner object
 EvalOnDartLibrary get eval;/// Whether this field was defined by the inspected app or by one of its dependencies
///
/// This is used by the UI to hide variables that are not useful for the user.
 bool get isDefinedByDependency;
/// Create a copy of ObjectField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObjectFieldCopyWith<ObjectField> get copyWith => _$ObjectFieldCopyWithImpl<ObjectField>(this as ObjectField, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ObjectField'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('isFinal', isFinal))..add(DiagnosticsProperty('ownerName', ownerName))..add(DiagnosticsProperty('ownerUri', ownerUri))..add(DiagnosticsProperty('ref', ref))..add(DiagnosticsProperty('eval', eval))..add(DiagnosticsProperty('isDefinedByDependency', isDefinedByDependency));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObjectField&&(identical(other.name, name) || other.name == name)&&(identical(other.isFinal, isFinal) || other.isFinal == isFinal)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.ownerUri, ownerUri) || other.ownerUri == ownerUri)&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.eval, eval) || other.eval == eval)&&(identical(other.isDefinedByDependency, isDefinedByDependency) || other.isDefinedByDependency == isDefinedByDependency));
}


@override
int get hashCode => Object.hash(runtimeType,name,isFinal,ownerName,ownerUri,ref,eval,isDefinedByDependency);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ObjectField(name: $name, isFinal: $isFinal, ownerName: $ownerName, ownerUri: $ownerUri, ref: $ref, eval: $eval, isDefinedByDependency: $isDefinedByDependency)';
}


}

/// @nodoc
abstract mixin class $ObjectFieldCopyWith<$Res>  {
  factory $ObjectFieldCopyWith(ObjectField value, $Res Function(ObjectField) _then) = _$ObjectFieldCopyWithImpl;
@useResult
$Res call({
 String name, bool isFinal, String ownerName, String ownerUri, Result<InstanceRef> ref, EvalOnDartLibrary eval, bool isDefinedByDependency
});




}
/// @nodoc
class _$ObjectFieldCopyWithImpl<$Res>
    implements $ObjectFieldCopyWith<$Res> {
  _$ObjectFieldCopyWithImpl(this._self, this._then);

  final ObjectField _self;
  final $Res Function(ObjectField) _then;

/// Create a copy of ObjectField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? isFinal = null,Object? ownerName = null,Object? ownerUri = null,Object? ref = null,Object? eval = null,Object? isDefinedByDependency = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isFinal: null == isFinal ? _self.isFinal : isFinal // ignore: cast_nullable_to_non_nullable
as bool,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,ownerUri: null == ownerUri ? _self.ownerUri : ownerUri // ignore: cast_nullable_to_non_nullable
as String,ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as Result<InstanceRef>,eval: null == eval ? _self.eval : eval // ignore: cast_nullable_to_non_nullable
as EvalOnDartLibrary,isDefinedByDependency: null == isDefinedByDependency ? _self.isDefinedByDependency : isDefinedByDependency // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ObjectField].
extension ObjectFieldPatterns on ObjectField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ObjectField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ObjectField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ObjectField value)  $default,){
final _that = this;
switch (_that) {
case _ObjectField():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ObjectField value)?  $default,){
final _that = this;
switch (_that) {
case _ObjectField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool isFinal,  String ownerName,  String ownerUri,  Result<InstanceRef> ref,  EvalOnDartLibrary eval,  bool isDefinedByDependency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ObjectField() when $default != null:
return $default(_that.name,_that.isFinal,_that.ownerName,_that.ownerUri,_that.ref,_that.eval,_that.isDefinedByDependency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool isFinal,  String ownerName,  String ownerUri,  Result<InstanceRef> ref,  EvalOnDartLibrary eval,  bool isDefinedByDependency)  $default,) {final _that = this;
switch (_that) {
case _ObjectField():
return $default(_that.name,_that.isFinal,_that.ownerName,_that.ownerUri,_that.ref,_that.eval,_that.isDefinedByDependency);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool isFinal,  String ownerName,  String ownerUri,  Result<InstanceRef> ref,  EvalOnDartLibrary eval,  bool isDefinedByDependency)?  $default,) {final _that = this;
switch (_that) {
case _ObjectField() when $default != null:
return $default(_that.name,_that.isFinal,_that.ownerName,_that.ownerUri,_that.ref,_that.eval,_that.isDefinedByDependency);case _:
  return null;

}
}

}

/// @nodoc


class _ObjectField extends ObjectField with DiagnosticableTreeMixin {
   _ObjectField({required this.name, required this.isFinal, required this.ownerName, required this.ownerUri, required this.ref, required this.eval, required this.isDefinedByDependency}): super._();
  

@override final  String name;
@override final  bool isFinal;
@override final  String ownerName;
@override final  String ownerUri;
@override final  Result<InstanceRef> ref;
/// An [EvalOnDartLibrary] that can access this field from the owner object
@override final  EvalOnDartLibrary eval;
/// Whether this field was defined by the inspected app or by one of its dependencies
///
/// This is used by the UI to hide variables that are not useful for the user.
@override final  bool isDefinedByDependency;

/// Create a copy of ObjectField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ObjectFieldCopyWith<_ObjectField> get copyWith => __$ObjectFieldCopyWithImpl<_ObjectField>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ObjectField'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('isFinal', isFinal))..add(DiagnosticsProperty('ownerName', ownerName))..add(DiagnosticsProperty('ownerUri', ownerUri))..add(DiagnosticsProperty('ref', ref))..add(DiagnosticsProperty('eval', eval))..add(DiagnosticsProperty('isDefinedByDependency', isDefinedByDependency));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ObjectField&&(identical(other.name, name) || other.name == name)&&(identical(other.isFinal, isFinal) || other.isFinal == isFinal)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.ownerUri, ownerUri) || other.ownerUri == ownerUri)&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.eval, eval) || other.eval == eval)&&(identical(other.isDefinedByDependency, isDefinedByDependency) || other.isDefinedByDependency == isDefinedByDependency));
}


@override
int get hashCode => Object.hash(runtimeType,name,isFinal,ownerName,ownerUri,ref,eval,isDefinedByDependency);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ObjectField(name: $name, isFinal: $isFinal, ownerName: $ownerName, ownerUri: $ownerUri, ref: $ref, eval: $eval, isDefinedByDependency: $isDefinedByDependency)';
}


}

/// @nodoc
abstract mixin class _$ObjectFieldCopyWith<$Res> implements $ObjectFieldCopyWith<$Res> {
  factory _$ObjectFieldCopyWith(_ObjectField value, $Res Function(_ObjectField) _then) = __$ObjectFieldCopyWithImpl;
@override @useResult
$Res call({
 String name, bool isFinal, String ownerName, String ownerUri, Result<InstanceRef> ref, EvalOnDartLibrary eval, bool isDefinedByDependency
});




}
/// @nodoc
class __$ObjectFieldCopyWithImpl<$Res>
    implements _$ObjectFieldCopyWith<$Res> {
  __$ObjectFieldCopyWithImpl(this._self, this._then);

  final _ObjectField _self;
  final $Res Function(_ObjectField) _then;

/// Create a copy of ObjectField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? isFinal = null,Object? ownerName = null,Object? ownerUri = null,Object? ref = null,Object? eval = null,Object? isDefinedByDependency = null,}) {
  return _then(_ObjectField(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isFinal: null == isFinal ? _self.isFinal : isFinal // ignore: cast_nullable_to_non_nullable
as bool,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,ownerUri: null == ownerUri ? _self.ownerUri : ownerUri // ignore: cast_nullable_to_non_nullable
as String,ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as Result<InstanceRef>,eval: null == eval ? _self.eval : eval // ignore: cast_nullable_to_non_nullable
as EvalOnDartLibrary,isDefinedByDependency: null == isDefinedByDependency ? _self.isDefinedByDependency : isDefinedByDependency // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$InstanceDetails implements DiagnosticableTreeMixin {

 Setter? get setter;
/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstanceDetailsCopyWith<InstanceDetails> get copyWith => _$InstanceDetailsCopyWithImpl<InstanceDetails>(this as InstanceDetails, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InstanceDetails'))
    ..add(DiagnosticsProperty('setter', setter));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstanceDetails&&(identical(other.setter, setter) || other.setter == setter));
}


@override
int get hashCode => Object.hash(runtimeType,setter);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InstanceDetails(setter: $setter)';
}


}

/// @nodoc
abstract mixin class $InstanceDetailsCopyWith<$Res>  {
  factory $InstanceDetailsCopyWith(InstanceDetails value, $Res Function(InstanceDetails) _then) = _$InstanceDetailsCopyWithImpl;
@useResult
$Res call({
 Future<void> Function(String)? setter
});




}
/// @nodoc
class _$InstanceDetailsCopyWithImpl<$Res>
    implements $InstanceDetailsCopyWith<$Res> {
  _$InstanceDetailsCopyWithImpl(this._self, this._then);

  final InstanceDetails _self;
  final $Res Function(InstanceDetails) _then;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? setter = freezed,}) {
  return _then(_self.copyWith(
setter: freezed == setter ? _self.setter : setter // ignore: cast_nullable_to_non_nullable
as Future<void> Function(String)?,
  ));
}

}


/// Adds pattern-matching-related methods to [InstanceDetails].
extension InstanceDetailsPatterns on InstanceDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NullInstance value)?  nill,TResult Function( BoolInstance value)?  boolean,TResult Function( NumInstance value)?  number,TResult Function( StringInstance value)?  string,TResult Function( MapInstance value)?  map,TResult Function( ListInstance value)?  list,TResult Function( ObjectInstance value)?  object,TResult Function( EnumInstance value)?  enumeration,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NullInstance() when nill != null:
return nill(_that);case BoolInstance() when boolean != null:
return boolean(_that);case NumInstance() when number != null:
return number(_that);case StringInstance() when string != null:
return string(_that);case MapInstance() when map != null:
return map(_that);case ListInstance() when list != null:
return list(_that);case ObjectInstance() when object != null:
return object(_that);case EnumInstance() when enumeration != null:
return enumeration(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NullInstance value)  nill,required TResult Function( BoolInstance value)  boolean,required TResult Function( NumInstance value)  number,required TResult Function( StringInstance value)  string,required TResult Function( MapInstance value)  map,required TResult Function( ListInstance value)  list,required TResult Function( ObjectInstance value)  object,required TResult Function( EnumInstance value)  enumeration,}){
final _that = this;
switch (_that) {
case NullInstance():
return nill(_that);case BoolInstance():
return boolean(_that);case NumInstance():
return number(_that);case StringInstance():
return string(_that);case MapInstance():
return map(_that);case ListInstance():
return list(_that);case ObjectInstance():
return object(_that);case EnumInstance():
return enumeration(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NullInstance value)?  nill,TResult? Function( BoolInstance value)?  boolean,TResult? Function( NumInstance value)?  number,TResult? Function( StringInstance value)?  string,TResult? Function( MapInstance value)?  map,TResult? Function( ListInstance value)?  list,TResult? Function( ObjectInstance value)?  object,TResult? Function( EnumInstance value)?  enumeration,}){
final _that = this;
switch (_that) {
case NullInstance() when nill != null:
return nill(_that);case BoolInstance() when boolean != null:
return boolean(_that);case NumInstance() when number != null:
return number(_that);case StringInstance() when string != null:
return string(_that);case MapInstance() when map != null:
return map(_that);case ListInstance() when list != null:
return list(_that);case ObjectInstance() when object != null:
return object(_that);case EnumInstance() when enumeration != null:
return enumeration(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Setter? setter)?  nill,TResult Function( String displayString,  String instanceRefId,  Setter? setter)?  boolean,TResult Function( String displayString,  String instanceRefId,  Setter? setter)?  number,TResult Function( String displayString,  String instanceRefId,  Setter? setter)?  string,TResult Function( List<InstanceDetails> keys,  int hash,  String instanceRefId,  Setter? setter)?  map,TResult Function( int length,  int hash,  String instanceRefId,  Setter? setter)?  list,TResult Function( List<ObjectField> fields,  String type,  int hash,  String instanceRefId,  Setter? setter,  EvalOnDartLibrary evalForInstance)?  object,TResult Function( String type,  String value,  Setter? setter,  String instanceRefId)?  enumeration,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NullInstance() when nill != null:
return nill(_that.setter);case BoolInstance() when boolean != null:
return boolean(_that.displayString,_that.instanceRefId,_that.setter);case NumInstance() when number != null:
return number(_that.displayString,_that.instanceRefId,_that.setter);case StringInstance() when string != null:
return string(_that.displayString,_that.instanceRefId,_that.setter);case MapInstance() when map != null:
return map(_that.keys,_that.hash,_that.instanceRefId,_that.setter);case ListInstance() when list != null:
return list(_that.length,_that.hash,_that.instanceRefId,_that.setter);case ObjectInstance() when object != null:
return object(_that.fields,_that.type,_that.hash,_that.instanceRefId,_that.setter,_that.evalForInstance);case EnumInstance() when enumeration != null:
return enumeration(_that.type,_that.value,_that.setter,_that.instanceRefId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Setter? setter)  nill,required TResult Function( String displayString,  String instanceRefId,  Setter? setter)  boolean,required TResult Function( String displayString,  String instanceRefId,  Setter? setter)  number,required TResult Function( String displayString,  String instanceRefId,  Setter? setter)  string,required TResult Function( List<InstanceDetails> keys,  int hash,  String instanceRefId,  Setter? setter)  map,required TResult Function( int length,  int hash,  String instanceRefId,  Setter? setter)  list,required TResult Function( List<ObjectField> fields,  String type,  int hash,  String instanceRefId,  Setter? setter,  EvalOnDartLibrary evalForInstance)  object,required TResult Function( String type,  String value,  Setter? setter,  String instanceRefId)  enumeration,}) {final _that = this;
switch (_that) {
case NullInstance():
return nill(_that.setter);case BoolInstance():
return boolean(_that.displayString,_that.instanceRefId,_that.setter);case NumInstance():
return number(_that.displayString,_that.instanceRefId,_that.setter);case StringInstance():
return string(_that.displayString,_that.instanceRefId,_that.setter);case MapInstance():
return map(_that.keys,_that.hash,_that.instanceRefId,_that.setter);case ListInstance():
return list(_that.length,_that.hash,_that.instanceRefId,_that.setter);case ObjectInstance():
return object(_that.fields,_that.type,_that.hash,_that.instanceRefId,_that.setter,_that.evalForInstance);case EnumInstance():
return enumeration(_that.type,_that.value,_that.setter,_that.instanceRefId);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Setter? setter)?  nill,TResult? Function( String displayString,  String instanceRefId,  Setter? setter)?  boolean,TResult? Function( String displayString,  String instanceRefId,  Setter? setter)?  number,TResult? Function( String displayString,  String instanceRefId,  Setter? setter)?  string,TResult? Function( List<InstanceDetails> keys,  int hash,  String instanceRefId,  Setter? setter)?  map,TResult? Function( int length,  int hash,  String instanceRefId,  Setter? setter)?  list,TResult? Function( List<ObjectField> fields,  String type,  int hash,  String instanceRefId,  Setter? setter,  EvalOnDartLibrary evalForInstance)?  object,TResult? Function( String type,  String value,  Setter? setter,  String instanceRefId)?  enumeration,}) {final _that = this;
switch (_that) {
case NullInstance() when nill != null:
return nill(_that.setter);case BoolInstance() when boolean != null:
return boolean(_that.displayString,_that.instanceRefId,_that.setter);case NumInstance() when number != null:
return number(_that.displayString,_that.instanceRefId,_that.setter);case StringInstance() when string != null:
return string(_that.displayString,_that.instanceRefId,_that.setter);case MapInstance() when map != null:
return map(_that.keys,_that.hash,_that.instanceRefId,_that.setter);case ListInstance() when list != null:
return list(_that.length,_that.hash,_that.instanceRefId,_that.setter);case ObjectInstance() when object != null:
return object(_that.fields,_that.type,_that.hash,_that.instanceRefId,_that.setter,_that.evalForInstance);case EnumInstance() when enumeration != null:
return enumeration(_that.type,_that.value,_that.setter,_that.instanceRefId);case _:
  return null;

}
}

}

/// @nodoc


class NullInstance extends InstanceDetails with DiagnosticableTreeMixin {
   NullInstance({required this.setter}): super._();
  

@override final  Setter? setter;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NullInstanceCopyWith<NullInstance> get copyWith => _$NullInstanceCopyWithImpl<NullInstance>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InstanceDetails.nill'))
    ..add(DiagnosticsProperty('setter', setter));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NullInstance&&(identical(other.setter, setter) || other.setter == setter));
}


@override
int get hashCode => Object.hash(runtimeType,setter);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InstanceDetails.nill(setter: $setter)';
}


}

/// @nodoc
abstract mixin class $NullInstanceCopyWith<$Res> implements $InstanceDetailsCopyWith<$Res> {
  factory $NullInstanceCopyWith(NullInstance value, $Res Function(NullInstance) _then) = _$NullInstanceCopyWithImpl;
@override @useResult
$Res call({
 Setter? setter
});




}
/// @nodoc
class _$NullInstanceCopyWithImpl<$Res>
    implements $NullInstanceCopyWith<$Res> {
  _$NullInstanceCopyWithImpl(this._self, this._then);

  final NullInstance _self;
  final $Res Function(NullInstance) _then;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? setter = freezed,}) {
  return _then(NullInstance(
setter: freezed == setter ? _self.setter : setter // ignore: cast_nullable_to_non_nullable
as Setter?,
  ));
}


}

/// @nodoc


class BoolInstance extends InstanceDetails with DiagnosticableTreeMixin {
   BoolInstance(this.displayString, {required this.instanceRefId, required this.setter}): super._();
  

 final  String displayString;
 final  String instanceRefId;
@override final  Setter? setter;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoolInstanceCopyWith<BoolInstance> get copyWith => _$BoolInstanceCopyWithImpl<BoolInstance>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InstanceDetails.boolean'))
    ..add(DiagnosticsProperty('displayString', displayString))..add(DiagnosticsProperty('instanceRefId', instanceRefId))..add(DiagnosticsProperty('setter', setter));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoolInstance&&(identical(other.displayString, displayString) || other.displayString == displayString)&&(identical(other.instanceRefId, instanceRefId) || other.instanceRefId == instanceRefId)&&(identical(other.setter, setter) || other.setter == setter));
}


@override
int get hashCode => Object.hash(runtimeType,displayString,instanceRefId,setter);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InstanceDetails.boolean(displayString: $displayString, instanceRefId: $instanceRefId, setter: $setter)';
}


}

/// @nodoc
abstract mixin class $BoolInstanceCopyWith<$Res> implements $InstanceDetailsCopyWith<$Res> {
  factory $BoolInstanceCopyWith(BoolInstance value, $Res Function(BoolInstance) _then) = _$BoolInstanceCopyWithImpl;
@override @useResult
$Res call({
 String displayString, String instanceRefId, Setter? setter
});




}
/// @nodoc
class _$BoolInstanceCopyWithImpl<$Res>
    implements $BoolInstanceCopyWith<$Res> {
  _$BoolInstanceCopyWithImpl(this._self, this._then);

  final BoolInstance _self;
  final $Res Function(BoolInstance) _then;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayString = null,Object? instanceRefId = null,Object? setter = freezed,}) {
  return _then(BoolInstance(
null == displayString ? _self.displayString : displayString // ignore: cast_nullable_to_non_nullable
as String,instanceRefId: null == instanceRefId ? _self.instanceRefId : instanceRefId // ignore: cast_nullable_to_non_nullable
as String,setter: freezed == setter ? _self.setter : setter // ignore: cast_nullable_to_non_nullable
as Setter?,
  ));
}


}

/// @nodoc


class NumInstance extends InstanceDetails with DiagnosticableTreeMixin {
   NumInstance(this.displayString, {required this.instanceRefId, required this.setter}): super._();
  

 final  String displayString;
 final  String instanceRefId;
@override final  Setter? setter;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NumInstanceCopyWith<NumInstance> get copyWith => _$NumInstanceCopyWithImpl<NumInstance>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InstanceDetails.number'))
    ..add(DiagnosticsProperty('displayString', displayString))..add(DiagnosticsProperty('instanceRefId', instanceRefId))..add(DiagnosticsProperty('setter', setter));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NumInstance&&(identical(other.displayString, displayString) || other.displayString == displayString)&&(identical(other.instanceRefId, instanceRefId) || other.instanceRefId == instanceRefId)&&(identical(other.setter, setter) || other.setter == setter));
}


@override
int get hashCode => Object.hash(runtimeType,displayString,instanceRefId,setter);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InstanceDetails.number(displayString: $displayString, instanceRefId: $instanceRefId, setter: $setter)';
}


}

/// @nodoc
abstract mixin class $NumInstanceCopyWith<$Res> implements $InstanceDetailsCopyWith<$Res> {
  factory $NumInstanceCopyWith(NumInstance value, $Res Function(NumInstance) _then) = _$NumInstanceCopyWithImpl;
@override @useResult
$Res call({
 String displayString, String instanceRefId, Setter? setter
});




}
/// @nodoc
class _$NumInstanceCopyWithImpl<$Res>
    implements $NumInstanceCopyWith<$Res> {
  _$NumInstanceCopyWithImpl(this._self, this._then);

  final NumInstance _self;
  final $Res Function(NumInstance) _then;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayString = null,Object? instanceRefId = null,Object? setter = freezed,}) {
  return _then(NumInstance(
null == displayString ? _self.displayString : displayString // ignore: cast_nullable_to_non_nullable
as String,instanceRefId: null == instanceRefId ? _self.instanceRefId : instanceRefId // ignore: cast_nullable_to_non_nullable
as String,setter: freezed == setter ? _self.setter : setter // ignore: cast_nullable_to_non_nullable
as Setter?,
  ));
}


}

/// @nodoc


class StringInstance extends InstanceDetails with DiagnosticableTreeMixin {
   StringInstance(this.displayString, {required this.instanceRefId, required this.setter}): super._();
  

 final  String displayString;
 final  String instanceRefId;
@override final  Setter? setter;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringInstanceCopyWith<StringInstance> get copyWith => _$StringInstanceCopyWithImpl<StringInstance>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InstanceDetails.string'))
    ..add(DiagnosticsProperty('displayString', displayString))..add(DiagnosticsProperty('instanceRefId', instanceRefId))..add(DiagnosticsProperty('setter', setter));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringInstance&&(identical(other.displayString, displayString) || other.displayString == displayString)&&(identical(other.instanceRefId, instanceRefId) || other.instanceRefId == instanceRefId)&&(identical(other.setter, setter) || other.setter == setter));
}


@override
int get hashCode => Object.hash(runtimeType,displayString,instanceRefId,setter);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InstanceDetails.string(displayString: $displayString, instanceRefId: $instanceRefId, setter: $setter)';
}


}

/// @nodoc
abstract mixin class $StringInstanceCopyWith<$Res> implements $InstanceDetailsCopyWith<$Res> {
  factory $StringInstanceCopyWith(StringInstance value, $Res Function(StringInstance) _then) = _$StringInstanceCopyWithImpl;
@override @useResult
$Res call({
 String displayString, String instanceRefId, Setter? setter
});




}
/// @nodoc
class _$StringInstanceCopyWithImpl<$Res>
    implements $StringInstanceCopyWith<$Res> {
  _$StringInstanceCopyWithImpl(this._self, this._then);

  final StringInstance _self;
  final $Res Function(StringInstance) _then;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayString = null,Object? instanceRefId = null,Object? setter = freezed,}) {
  return _then(StringInstance(
null == displayString ? _self.displayString : displayString // ignore: cast_nullable_to_non_nullable
as String,instanceRefId: null == instanceRefId ? _self.instanceRefId : instanceRefId // ignore: cast_nullable_to_non_nullable
as String,setter: freezed == setter ? _self.setter : setter // ignore: cast_nullable_to_non_nullable
as Setter?,
  ));
}


}

/// @nodoc


class MapInstance extends InstanceDetails with DiagnosticableTreeMixin {
   MapInstance(final  List<InstanceDetails> keys, {required this.hash, required this.instanceRefId, required this.setter}): _keys = keys,super._();
  

 final  List<InstanceDetails> _keys;
 List<InstanceDetails> get keys {
  if (_keys is EqualUnmodifiableListView) return _keys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keys);
}

 final  int hash;
 final  String instanceRefId;
@override final  Setter? setter;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapInstanceCopyWith<MapInstance> get copyWith => _$MapInstanceCopyWithImpl<MapInstance>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InstanceDetails.map'))
    ..add(DiagnosticsProperty('keys', keys))..add(DiagnosticsProperty('hash', hash))..add(DiagnosticsProperty('instanceRefId', instanceRefId))..add(DiagnosticsProperty('setter', setter));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapInstance&&const DeepCollectionEquality().equals(other._keys, _keys)&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.instanceRefId, instanceRefId) || other.instanceRefId == instanceRefId)&&(identical(other.setter, setter) || other.setter == setter));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_keys),hash,instanceRefId,setter);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InstanceDetails.map(keys: $keys, hash: $hash, instanceRefId: $instanceRefId, setter: $setter)';
}


}

/// @nodoc
abstract mixin class $MapInstanceCopyWith<$Res> implements $InstanceDetailsCopyWith<$Res> {
  factory $MapInstanceCopyWith(MapInstance value, $Res Function(MapInstance) _then) = _$MapInstanceCopyWithImpl;
@override @useResult
$Res call({
 List<InstanceDetails> keys, int hash, String instanceRefId, Setter? setter
});




}
/// @nodoc
class _$MapInstanceCopyWithImpl<$Res>
    implements $MapInstanceCopyWith<$Res> {
  _$MapInstanceCopyWithImpl(this._self, this._then);

  final MapInstance _self;
  final $Res Function(MapInstance) _then;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keys = null,Object? hash = null,Object? instanceRefId = null,Object? setter = freezed,}) {
  return _then(MapInstance(
null == keys ? _self._keys : keys // ignore: cast_nullable_to_non_nullable
as List<InstanceDetails>,hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as int,instanceRefId: null == instanceRefId ? _self.instanceRefId : instanceRefId // ignore: cast_nullable_to_non_nullable
as String,setter: freezed == setter ? _self.setter : setter // ignore: cast_nullable_to_non_nullable
as Setter?,
  ));
}


}

/// @nodoc


class ListInstance extends InstanceDetails with DiagnosticableTreeMixin {
   ListInstance({required this.length, required this.hash, required this.instanceRefId, required this.setter}): super._();
  

 final  int length;
 final  int hash;
 final  String instanceRefId;
@override final  Setter? setter;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListInstanceCopyWith<ListInstance> get copyWith => _$ListInstanceCopyWithImpl<ListInstance>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InstanceDetails.list'))
    ..add(DiagnosticsProperty('length', length))..add(DiagnosticsProperty('hash', hash))..add(DiagnosticsProperty('instanceRefId', instanceRefId))..add(DiagnosticsProperty('setter', setter));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListInstance&&(identical(other.length, length) || other.length == length)&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.instanceRefId, instanceRefId) || other.instanceRefId == instanceRefId)&&(identical(other.setter, setter) || other.setter == setter));
}


@override
int get hashCode => Object.hash(runtimeType,length,hash,instanceRefId,setter);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InstanceDetails.list(length: $length, hash: $hash, instanceRefId: $instanceRefId, setter: $setter)';
}


}

/// @nodoc
abstract mixin class $ListInstanceCopyWith<$Res> implements $InstanceDetailsCopyWith<$Res> {
  factory $ListInstanceCopyWith(ListInstance value, $Res Function(ListInstance) _then) = _$ListInstanceCopyWithImpl;
@override @useResult
$Res call({
 int length, int hash, String instanceRefId, Setter? setter
});




}
/// @nodoc
class _$ListInstanceCopyWithImpl<$Res>
    implements $ListInstanceCopyWith<$Res> {
  _$ListInstanceCopyWithImpl(this._self, this._then);

  final ListInstance _self;
  final $Res Function(ListInstance) _then;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? length = null,Object? hash = null,Object? instanceRefId = null,Object? setter = freezed,}) {
  return _then(ListInstance(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as int,instanceRefId: null == instanceRefId ? _self.instanceRefId : instanceRefId // ignore: cast_nullable_to_non_nullable
as String,setter: freezed == setter ? _self.setter : setter // ignore: cast_nullable_to_non_nullable
as Setter?,
  ));
}


}

/// @nodoc


class ObjectInstance extends InstanceDetails with DiagnosticableTreeMixin {
   ObjectInstance(final  List<ObjectField> fields, {required this.type, required this.hash, required this.instanceRefId, required this.setter, required this.evalForInstance}): _fields = fields,super._();
  

 final  List<ObjectField> _fields;
 List<ObjectField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}

 final  String type;
 final  int hash;
 final  String instanceRefId;
@override final  Setter? setter;
/// An [EvalOnDartLibrary] associated with the library of this object
///
/// This allows to edit private properties.
 final  EvalOnDartLibrary evalForInstance;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObjectInstanceCopyWith<ObjectInstance> get copyWith => _$ObjectInstanceCopyWithImpl<ObjectInstance>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InstanceDetails.object'))
    ..add(DiagnosticsProperty('fields', fields))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('hash', hash))..add(DiagnosticsProperty('instanceRefId', instanceRefId))..add(DiagnosticsProperty('setter', setter))..add(DiagnosticsProperty('evalForInstance', evalForInstance));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObjectInstance&&const DeepCollectionEquality().equals(other._fields, _fields)&&(identical(other.type, type) || other.type == type)&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.instanceRefId, instanceRefId) || other.instanceRefId == instanceRefId)&&(identical(other.setter, setter) || other.setter == setter)&&(identical(other.evalForInstance, evalForInstance) || other.evalForInstance == evalForInstance));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_fields),type,hash,instanceRefId,setter,evalForInstance);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InstanceDetails.object(fields: $fields, type: $type, hash: $hash, instanceRefId: $instanceRefId, setter: $setter, evalForInstance: $evalForInstance)';
}


}

/// @nodoc
abstract mixin class $ObjectInstanceCopyWith<$Res> implements $InstanceDetailsCopyWith<$Res> {
  factory $ObjectInstanceCopyWith(ObjectInstance value, $Res Function(ObjectInstance) _then) = _$ObjectInstanceCopyWithImpl;
@override @useResult
$Res call({
 List<ObjectField> fields, String type, int hash, String instanceRefId, Setter? setter, EvalOnDartLibrary evalForInstance
});




}
/// @nodoc
class _$ObjectInstanceCopyWithImpl<$Res>
    implements $ObjectInstanceCopyWith<$Res> {
  _$ObjectInstanceCopyWithImpl(this._self, this._then);

  final ObjectInstance _self;
  final $Res Function(ObjectInstance) _then;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fields = null,Object? type = null,Object? hash = null,Object? instanceRefId = null,Object? setter = freezed,Object? evalForInstance = null,}) {
  return _then(ObjectInstance(
null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<ObjectField>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as int,instanceRefId: null == instanceRefId ? _self.instanceRefId : instanceRefId // ignore: cast_nullable_to_non_nullable
as String,setter: freezed == setter ? _self.setter : setter // ignore: cast_nullable_to_non_nullable
as Setter?,evalForInstance: null == evalForInstance ? _self.evalForInstance : evalForInstance // ignore: cast_nullable_to_non_nullable
as EvalOnDartLibrary,
  ));
}


}

/// @nodoc


class EnumInstance extends InstanceDetails with DiagnosticableTreeMixin {
   EnumInstance({required this.type, required this.value, required this.setter, required this.instanceRefId}): super._();
  

 final  String type;
 final  String value;
@override final  Setter? setter;
 final  String instanceRefId;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnumInstanceCopyWith<EnumInstance> get copyWith => _$EnumInstanceCopyWithImpl<EnumInstance>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InstanceDetails.enumeration'))
    ..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('value', value))..add(DiagnosticsProperty('setter', setter))..add(DiagnosticsProperty('instanceRefId', instanceRefId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnumInstance&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.setter, setter) || other.setter == setter)&&(identical(other.instanceRefId, instanceRefId) || other.instanceRefId == instanceRefId));
}


@override
int get hashCode => Object.hash(runtimeType,type,value,setter,instanceRefId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InstanceDetails.enumeration(type: $type, value: $value, setter: $setter, instanceRefId: $instanceRefId)';
}


}

/// @nodoc
abstract mixin class $EnumInstanceCopyWith<$Res> implements $InstanceDetailsCopyWith<$Res> {
  factory $EnumInstanceCopyWith(EnumInstance value, $Res Function(EnumInstance) _then) = _$EnumInstanceCopyWithImpl;
@override @useResult
$Res call({
 String type, String value, Setter? setter, String instanceRefId
});




}
/// @nodoc
class _$EnumInstanceCopyWithImpl<$Res>
    implements $EnumInstanceCopyWith<$Res> {
  _$EnumInstanceCopyWithImpl(this._self, this._then);

  final EnumInstance _self;
  final $Res Function(EnumInstance) _then;

/// Create a copy of InstanceDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? value = null,Object? setter = freezed,Object? instanceRefId = null,}) {
  return _then(EnumInstance(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,setter: freezed == setter ? _self.setter : setter // ignore: cast_nullable_to_non_nullable
as Setter?,instanceRefId: null == instanceRefId ? _self.instanceRefId : instanceRefId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$InstancePath implements DiagnosticableTreeMixin {

 List<PathToProperty> get pathToProperty;
/// Create a copy of InstancePath
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstancePathCopyWith<InstancePath> get copyWith => _$InstancePathCopyWithImpl<InstancePath>(this as InstancePath, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InstancePath'))
    ..add(DiagnosticsProperty('pathToProperty', pathToProperty));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstancePath&&const DeepCollectionEquality().equals(other.pathToProperty, pathToProperty));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pathToProperty));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InstancePath(pathToProperty: $pathToProperty)';
}


}

/// @nodoc
abstract mixin class $InstancePathCopyWith<$Res>  {
  factory $InstancePathCopyWith(InstancePath value, $Res Function(InstancePath) _then) = _$InstancePathCopyWithImpl;
@useResult
$Res call({
 List<PathToProperty> pathToProperty
});




}
/// @nodoc
class _$InstancePathCopyWithImpl<$Res>
    implements $InstancePathCopyWith<$Res> {
  _$InstancePathCopyWithImpl(this._self, this._then);

  final InstancePath _self;
  final $Res Function(InstancePath) _then;

/// Create a copy of InstancePath
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pathToProperty = null,}) {
  return _then(_self.copyWith(
pathToProperty: null == pathToProperty ? _self.pathToProperty : pathToProperty // ignore: cast_nullable_to_non_nullable
as List<PathToProperty>,
  ));
}

}


/// Adds pattern-matching-related methods to [InstancePath].
extension InstancePathPatterns on InstancePath {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _InstancePathFromInstanceId value)?  fromInstanceId,TResult Function( _InstancePathFromProviderId value)?  fromProviderId,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstancePathFromInstanceId() when fromInstanceId != null:
return fromInstanceId(_that);case _InstancePathFromProviderId() when fromProviderId != null:
return fromProviderId(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _InstancePathFromInstanceId value)  fromInstanceId,required TResult Function( _InstancePathFromProviderId value)  fromProviderId,}){
final _that = this;
switch (_that) {
case _InstancePathFromInstanceId():
return fromInstanceId(_that);case _InstancePathFromProviderId():
return fromProviderId(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _InstancePathFromInstanceId value)?  fromInstanceId,TResult? Function( _InstancePathFromProviderId value)?  fromProviderId,}){
final _that = this;
switch (_that) {
case _InstancePathFromInstanceId() when fromInstanceId != null:
return fromInstanceId(_that);case _InstancePathFromProviderId() when fromProviderId != null:
return fromProviderId(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String instanceId,  List<PathToProperty> pathToProperty)?  fromInstanceId,TResult Function( String providerId,  List<PathToProperty> pathToProperty)?  fromProviderId,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstancePathFromInstanceId() when fromInstanceId != null:
return fromInstanceId(_that.instanceId,_that.pathToProperty);case _InstancePathFromProviderId() when fromProviderId != null:
return fromProviderId(_that.providerId,_that.pathToProperty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String instanceId,  List<PathToProperty> pathToProperty)  fromInstanceId,required TResult Function( String providerId,  List<PathToProperty> pathToProperty)  fromProviderId,}) {final _that = this;
switch (_that) {
case _InstancePathFromInstanceId():
return fromInstanceId(_that.instanceId,_that.pathToProperty);case _InstancePathFromProviderId():
return fromProviderId(_that.providerId,_that.pathToProperty);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String instanceId,  List<PathToProperty> pathToProperty)?  fromInstanceId,TResult? Function( String providerId,  List<PathToProperty> pathToProperty)?  fromProviderId,}) {final _that = this;
switch (_that) {
case _InstancePathFromInstanceId() when fromInstanceId != null:
return fromInstanceId(_that.instanceId,_that.pathToProperty);case _InstancePathFromProviderId() when fromProviderId != null:
return fromProviderId(_that.providerId,_that.pathToProperty);case _:
  return null;

}
}

}

/// @nodoc


class _InstancePathFromInstanceId extends InstancePath with DiagnosticableTreeMixin {
  const _InstancePathFromInstanceId(this.instanceId, {final  List<PathToProperty> pathToProperty = const []}): _pathToProperty = pathToProperty,super._();
  

 final  String instanceId;
 final  List<PathToProperty> _pathToProperty;
@override@JsonKey() List<PathToProperty> get pathToProperty {
  if (_pathToProperty is EqualUnmodifiableListView) return _pathToProperty;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pathToProperty);
}


/// Create a copy of InstancePath
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstancePathFromInstanceIdCopyWith<_InstancePathFromInstanceId> get copyWith => __$InstancePathFromInstanceIdCopyWithImpl<_InstancePathFromInstanceId>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InstancePath.fromInstanceId'))
    ..add(DiagnosticsProperty('instanceId', instanceId))..add(DiagnosticsProperty('pathToProperty', pathToProperty));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstancePathFromInstanceId&&(identical(other.instanceId, instanceId) || other.instanceId == instanceId)&&const DeepCollectionEquality().equals(other._pathToProperty, _pathToProperty));
}


@override
int get hashCode => Object.hash(runtimeType,instanceId,const DeepCollectionEquality().hash(_pathToProperty));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InstancePath.fromInstanceId(instanceId: $instanceId, pathToProperty: $pathToProperty)';
}


}

/// @nodoc
abstract mixin class _$InstancePathFromInstanceIdCopyWith<$Res> implements $InstancePathCopyWith<$Res> {
  factory _$InstancePathFromInstanceIdCopyWith(_InstancePathFromInstanceId value, $Res Function(_InstancePathFromInstanceId) _then) = __$InstancePathFromInstanceIdCopyWithImpl;
@override @useResult
$Res call({
 String instanceId, List<PathToProperty> pathToProperty
});




}
/// @nodoc
class __$InstancePathFromInstanceIdCopyWithImpl<$Res>
    implements _$InstancePathFromInstanceIdCopyWith<$Res> {
  __$InstancePathFromInstanceIdCopyWithImpl(this._self, this._then);

  final _InstancePathFromInstanceId _self;
  final $Res Function(_InstancePathFromInstanceId) _then;

/// Create a copy of InstancePath
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instanceId = null,Object? pathToProperty = null,}) {
  return _then(_InstancePathFromInstanceId(
null == instanceId ? _self.instanceId : instanceId // ignore: cast_nullable_to_non_nullable
as String,pathToProperty: null == pathToProperty ? _self._pathToProperty : pathToProperty // ignore: cast_nullable_to_non_nullable
as List<PathToProperty>,
  ));
}


}

/// @nodoc


class _InstancePathFromProviderId extends InstancePath with DiagnosticableTreeMixin {
  const _InstancePathFromProviderId(this.providerId, {final  List<PathToProperty> pathToProperty = const []}): _pathToProperty = pathToProperty,super._();
  

 final  String providerId;
 final  List<PathToProperty> _pathToProperty;
@override@JsonKey() List<PathToProperty> get pathToProperty {
  if (_pathToProperty is EqualUnmodifiableListView) return _pathToProperty;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pathToProperty);
}


/// Create a copy of InstancePath
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstancePathFromProviderIdCopyWith<_InstancePathFromProviderId> get copyWith => __$InstancePathFromProviderIdCopyWithImpl<_InstancePathFromProviderId>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InstancePath.fromProviderId'))
    ..add(DiagnosticsProperty('providerId', providerId))..add(DiagnosticsProperty('pathToProperty', pathToProperty));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstancePathFromProviderId&&(identical(other.providerId, providerId) || other.providerId == providerId)&&const DeepCollectionEquality().equals(other._pathToProperty, _pathToProperty));
}


@override
int get hashCode => Object.hash(runtimeType,providerId,const DeepCollectionEquality().hash(_pathToProperty));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InstancePath.fromProviderId(providerId: $providerId, pathToProperty: $pathToProperty)';
}


}

/// @nodoc
abstract mixin class _$InstancePathFromProviderIdCopyWith<$Res> implements $InstancePathCopyWith<$Res> {
  factory _$InstancePathFromProviderIdCopyWith(_InstancePathFromProviderId value, $Res Function(_InstancePathFromProviderId) _then) = __$InstancePathFromProviderIdCopyWithImpl;
@override @useResult
$Res call({
 String providerId, List<PathToProperty> pathToProperty
});




}
/// @nodoc
class __$InstancePathFromProviderIdCopyWithImpl<$Res>
    implements _$InstancePathFromProviderIdCopyWith<$Res> {
  __$InstancePathFromProviderIdCopyWithImpl(this._self, this._then);

  final _InstancePathFromProviderId _self;
  final $Res Function(_InstancePathFromProviderId) _then;

/// Create a copy of InstancePath
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? providerId = null,Object? pathToProperty = null,}) {
  return _then(_InstancePathFromProviderId(
null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,pathToProperty: null == pathToProperty ? _self._pathToProperty : pathToProperty // ignore: cast_nullable_to_non_nullable
as List<PathToProperty>,
  ));
}


}

// dart format on
