import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_events.freezed.dart';

@freezed
class AuthEvents with _$AuthEvents {
  const factory AuthEvents.emailChanged({required String? email}) =
      EmailChanged;

  const factory AuthEvents.passwordChanged({required String? password}) =
      PasswordChanged;

  const factory AuthEvents.signUpWithEmailAndPasswordPressed() =
      SignUPWithEmailAndPasswordPressed;

  const factory AuthEvents.signInWithEmailAndPasswordPressed() =
      SignInWithEmailAndPasswordPressed;
}
