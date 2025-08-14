// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThemeSettings {
  ThemeMode get mode;
  Color get primaryColor;

  /// Create a copy of ThemeSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThemeSettingsCopyWith<ThemeSettings> get copyWith =>
      _$ThemeSettingsCopyWithImpl<ThemeSettings>(
          this as ThemeSettings, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThemeSettings &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.primaryColor, primaryColor) ||
                other.primaryColor == primaryColor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode, primaryColor);

  @override
  String toString() {
    return 'ThemeSettings(mode: $mode, primaryColor: $primaryColor)';
  }
}

/// @nodoc
abstract mixin class $ThemeSettingsCopyWith<$Res> {
  factory $ThemeSettingsCopyWith(
          ThemeSettings value, $Res Function(ThemeSettings) _then) =
      _$ThemeSettingsCopyWithImpl;
  @useResult
  $Res call({ThemeMode mode, Color primaryColor});
}

/// @nodoc
class _$ThemeSettingsCopyWithImpl<$Res>
    implements $ThemeSettingsCopyWith<$Res> {
  _$ThemeSettingsCopyWithImpl(this._self, this._then);

  final ThemeSettings _self;
  final $Res Function(ThemeSettings) _then;

  /// Create a copy of ThemeSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? primaryColor = null,
  }) {
    return _then(_self.copyWith(
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      primaryColor: null == primaryColor
          ? _self.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// Adds pattern-matching-related methods to [ThemeSettings].
extension ThemeSettingsPatterns on ThemeSettings {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ThemeSettings value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ThemeSettings() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ThemeSettings value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ThemeSettings():
        return $default(_that);
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ThemeSettings value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ThemeSettings() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(ThemeMode mode, Color primaryColor)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ThemeSettings() when $default != null:
        return $default(_that.mode, _that.primaryColor);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(ThemeMode mode, Color primaryColor) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ThemeSettings():
        return $default(_that.mode, _that.primaryColor);
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(ThemeMode mode, Color primaryColor)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ThemeSettings() when $default != null:
        return $default(_that.mode, _that.primaryColor);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ThemeSettings implements ThemeSettings {
  const _ThemeSettings({required this.mode, required this.primaryColor});

  @override
  final ThemeMode mode;
  @override
  final Color primaryColor;

  /// Create a copy of ThemeSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ThemeSettingsCopyWith<_ThemeSettings> get copyWith =>
      __$ThemeSettingsCopyWithImpl<_ThemeSettings>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ThemeSettings &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.primaryColor, primaryColor) ||
                other.primaryColor == primaryColor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode, primaryColor);

  @override
  String toString() {
    return 'ThemeSettings(mode: $mode, primaryColor: $primaryColor)';
  }
}

/// @nodoc
abstract mixin class _$ThemeSettingsCopyWith<$Res>
    implements $ThemeSettingsCopyWith<$Res> {
  factory _$ThemeSettingsCopyWith(
          _ThemeSettings value, $Res Function(_ThemeSettings) _then) =
      __$ThemeSettingsCopyWithImpl;
  @override
  @useResult
  $Res call({ThemeMode mode, Color primaryColor});
}

/// @nodoc
class __$ThemeSettingsCopyWithImpl<$Res>
    implements _$ThemeSettingsCopyWith<$Res> {
  __$ThemeSettingsCopyWithImpl(this._self, this._then);

  final _ThemeSettings _self;
  final $Res Function(_ThemeSettings) _then;

  /// Create a copy of ThemeSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mode = null,
    Object? primaryColor = null,
  }) {
    return _then(_ThemeSettings(
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      primaryColor: null == primaryColor
          ? _self.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

// dart format on
