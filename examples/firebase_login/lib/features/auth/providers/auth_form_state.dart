import 'package:firebase_login/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_form_state.freezed.dart';

@freezed
sealed class AuthFormState with _$AuthFormState {
  const factory AuthFormState.initial() = _Initial;
  const factory AuthFormState.loading() = _Loading;
  const factory AuthFormState.success() = _Success;
  const factory AuthFormState.failure(String message) = _Failure;
}

class AuthFormStateNotifier extends StateNotifier<AuthFormState> {
  AuthFormStateNotifier({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthFormState.initial());

  final AuthRepository _authRepository;

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AuthFormState.loading();
    try {
      await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AuthFormState.success();
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      state = AuthFormState.failure(e.message);
    } catch (_) {
      state = const AuthFormState.failure('An unexpected error occured!');
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AuthFormState.loading();
    try {
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AuthFormState.success();
    } on SignInWithEmailAndPasswordFailure catch (e) {
      state = AuthFormState.failure(e.message);
    } catch (_) {
      state = const AuthFormState.failure('An unexpected error occured!');
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthFormState.loading();
    try {
      await _authRepository.signInWithGoogle();
      state = const AuthFormState.success();
    } on SignInWithGoogleFailure catch (e) {
      state = AuthFormState.failure(e.message);
    } catch (_) {
      state = const AuthFormState.failure('An unexpected error occured!');
    }
  }
}

extension AuthFormStateExtension on AuthFormState {
  bool get isFormSubmitting {
    return maybeWhen(loading: () => true, orElse: () => false);
  }
}
