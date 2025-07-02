// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FreezedExample {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FreezedExample);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FreezedExample()';
  }
}

/// @nodoc
class $FreezedExampleCopyWith<$Res> {
  $FreezedExampleCopyWith(FreezedExample _, $Res Function(FreezedExample) __);
}

/// @nodoc

class _FreezedExample implements FreezedExample {
  _FreezedExample();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _FreezedExample);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FreezedExample()';
  }
}

/// @nodoc
mixin _$ClassicFreezed {
  int get value;

  /// Create a copy of ClassicFreezed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClassicFreezedCopyWith<ClassicFreezed> get copyWith =>
      _$ClassicFreezedCopyWithImpl<ClassicFreezed>(
          this as ClassicFreezed, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ClassicFreezed &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'ClassicFreezed(value: $value)';
  }
}

/// @nodoc
abstract mixin class $ClassicFreezedCopyWith<$Res> {
  factory $ClassicFreezedCopyWith(
          ClassicFreezed value, $Res Function(ClassicFreezed) _then) =
      _$ClassicFreezedCopyWithImpl;
  @useResult
  $Res call({int value});
}

/// @nodoc
class _$ClassicFreezedCopyWithImpl<$Res>
    implements $ClassicFreezedCopyWith<$Res> {
  _$ClassicFreezedCopyWithImpl(this._self, this._then);

  final ClassicFreezed _self;
  final $Res Function(ClassicFreezed) _then;

  /// Create a copy of ClassicFreezed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(ClassicFreezed(
      null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
