import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/features/auth/data/repositories/auth_repository.dart';
import 'package:firebase_login/features/auth/providers/auth_form_state.dart';
import 'package:firebase_login/features/auth/providers/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@riverpod
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@riverpod
GoogleSignIn googleSignIn(Ref ref) => GoogleSignIn();

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    firebaseAuth: ref.read<FirebaseAuth>(firebaseAuthProvider),
    googleSignIn: ref.read<GoogleSignIn>(googleSignInProvider),
  );
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(
      authRepository: ref.read<AuthRepository>(authRepositoryProvider),
    ),
);

final authFormStateProvider =
    StateNotifierProvider<AuthFormStateNotifier, AuthFormState>(
  (ref) => AuthFormStateNotifier(
    authRepository: ref.read<AuthRepository>(authRepositoryProvider),
  ),
);
