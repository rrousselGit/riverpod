import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_login/auth/user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

/// {@template sign_up_with_email_and_password_failure}
/// Thrown during the sign-up process if a failure occurs.
///
/// * Check the [Reference API][ref link] for updated error codes.
///
/// [ref link]: https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown error occurred.',
  ]);

  /// Creates a failure message from a [firebase_auth.FirebaseAuthException] code.
  ///
  /// {@macro sign_up_with_email_and_password_failure}
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for this email address.',
        );
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'The email is not valid or badly formatted.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'This operation is not allowed. Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'The password provided is too weak. Please use a stronger password.',
        );

      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;

  @override
  String toString() => message;
}

/// {@template sign_in_with_email_and_password_failure}
/// Thrown during the sign in process if a failure occurs.
///
/// * Check the [Reference API][ref link] for updated error codes.
///
/// [ref link]: https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
/// {@endtemplate}
class SignInWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_in_with_email_and_password_failure}
  const SignInWithEmailAndPasswordFailure([
    this.message = 'An unknown error occurred.',
  ]);

  /// Creates a failure message from a [firebase_auth.FirebaseAuthException] code.
  ///
  /// {@macro sign_in_with_email_and_password_failure}
  factory SignInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignInWithEmailAndPasswordFailure(
          'The email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignInWithEmailAndPasswordFailure(
          'This user account has been disabled. Please contact support.',
        );
      case 'user-not-found':
        return const SignInWithEmailAndPasswordFailure(
          'No user found with this email. Please check the email or sign up.',
        );
      case 'wrong-password':
        return const SignInWithEmailAndPasswordFailure(
          'Incorrect password. Please try again.',
        );
      case 'invalid-credential':
        return const SignInWithEmailAndPasswordFailure(
          'The credential provided is invalid. Please try again or use a different method.',
        );

      default:
        return const SignInWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;

  @override
  String toString() => message;
}

/// {@template sign_in_with_google_failure}
/// Thrown during the sign in process if a failure occurs.
///
/// * Check the [Reference API][ref link] for updated error codes.
///
/// [ref link]: https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithCredential.html
/// {@endtemplate}
class SignInWithGoogleFailure implements Exception {
  /// {@macro sign_in_with_google_failure}
  const SignInWithGoogleFailure([
    this.message = 'An unknown error occurred.',
  ]);

  /// Creates a failure message from a [firebase_auth.FirebaseAuthException] code.
  ///
  /// {@macro sign_in_with_google_failure}
  factory SignInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const SignInWithGoogleFailure(
          'An account already exists with a different credential. Please use a different sign-in method.',
        );
      case 'invalid-credential':
        return const SignInWithGoogleFailure(
          'The credential provided is malformed or has expired.',
        );
      case 'user-disabled':
        return const SignInWithGoogleFailure(
          'This user account has been disabled. Please contact support.',
        );
      case 'user-not-found':
        return const SignInWithGoogleFailure(
          'No user found with this credential. Please check your credentials or sign up.',
        );
      case 'wrong-password':
        return const SignInWithGoogleFailure(
          'Incorrect password. Please try again.',
        );
      case 'invalid-verification-code':
        return const SignInWithGoogleFailure(
          'The verification code is invalid. Please check and try again.',
        );
      case 'invalid-verification-id':
        return const SignInWithGoogleFailure(
          'The verification ID is invalid. Please restart the verification process.',
        );

      default:
        return const SignInWithGoogleFailure();
    }
  }

  /// The associated error message.
  final String message;

  @override
  String toString() => message;
}

/// Thrown during the logout process if a failure occurs.
class SignOutFailure implements Exception {}

/// {@template auth_repository}
/// Repository that handles authentication with email-password
/// and google sign in.
/// {@endtemplate}
class AuthRepository {
  /// {@macro auth_repository}
  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Stream of [User] that notifies about changes to the user's
  /// authentication state (such as sign-in or sign-out)
  ///
  /// Emits empty user, if the user is unauthenticated.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser != null ? firebaseUser.toUser : User.empty();
    });
  }

  /// Creates a new user with the provided email address and password.
  ///
  /// Throws [SignUpWithEmailAndPasswordFailure] when an exception
  /// occurs during the operation.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// Signs in a user with the provided email address and password.
  ///
  /// Throws [SignInWithEmailAndPasswordFailure] when an exception
  /// occurs during the operation.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignInWithEmailAndPasswordFailure();
    }
  }

  /// Triggers the google sign in flow.
  ///
  /// Throws [SignInWithGoogleFailure] when an exception occurs
  /// during the operation.
  Future<void> signInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      if (kIsWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleAccount = await _googleSignIn.signIn();
        final googleAuthentication = await googleAccount!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuthentication.accessToken,
          idToken: googleAuthentication.idToken,
        );
      }

      await _firebaseAuth.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const SignInWithGoogleFailure();
    }
  }

  /// Signs out currently signed in user.
  ///
  /// Throws [SignOutFailure] when an exception occurs during
  /// the operation.
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw SignOutFailure();
    }
  }
}

extension on firebase_auth.User {
  /// Maps a [firebase_auth.User] into a [User].
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}

@riverpod
firebase_auth.FirebaseAuth firebaseAuth(Ref ref) =>
    firebase_auth.FirebaseAuth.instance;

@riverpod
GoogleSignIn googleSignIn(Ref ref) => GoogleSignIn();

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    firebaseAuth: ref.read<firebase_auth.FirebaseAuth>(firebaseAuthProvider),
    googleSignIn: ref.read<GoogleSignIn>(googleSignInProvider),
  );
}
