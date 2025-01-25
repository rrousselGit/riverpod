import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

/// {@template user}
/// A user model.
/// {@endtemplate}
@freezed
class User with _$User {
  /// {@macro user}
  const factory User({
    /// Unique identifier for the user.
    required String id,

    /// The associated email address of the user.
    String? email,

    /// Name of the user.
    String? name,

    /// Display photo URL of the user.
    String? photo,
  }) = _User;

  /// {@macro user}
  const User._();

  /// Represents an unauthenticated user.
  factory User.empty() => const User(id: '');

  /// Whether the user is unauthenticated.
  bool get isUnuthenticated => this == User.empty();

  /// Whether the user is authenticated.
  bool get isAuthenticated => !isUnuthenticated;
}
