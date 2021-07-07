import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Domain/Authentication/auth_failures.dart';
import '../../Domain/Authentication/auth_value_objects.dart';
import '../../Domain/Authentication/i_auth_facade.dart';
import '../../Domain/Core/errors.dart';

class FirebaseAuthFacade implements IAuthFacade {
  FirebaseAuthFacade(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<Either<AuthFailures, Unit>> registerWithEmailAndPassword(
      {required EmailAddress? emailAddress,
      required Password? password}) async {
    final emailAddressString = emailAddress!.valueObject!
        .fold((l) => throw UnExpectedValueError(l), id);
    final passwordString =
        password!.valueObject!.fold((l) => throw UnExpectedValueError(l), id);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailAddressString, password: passwordString);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return left(const AuthFailures.emailAlreadyInUse());
      } else {
        return left(const AuthFailures.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailures, Unit>> signInWithEmailAndPassword(
      {required EmailAddress? emailAddress,
      required Password? password}) async {
    final emailAddressString = emailAddress!.valueObject!
        .fold((l) => throw UnExpectedValueError(l), id);
    final passwordString =
        password!.valueObject!.fold((l) => throw UnExpectedValueError(l), id);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: emailAddressString, password: passwordString);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        return left(const AuthFailures.invalidEmailAndPasswordCombination());
      } else {
        return left(const AuthFailures.serverError());
      }
    }
  }

  @override
  Future<Option<String>> getSignedInUser() async {
    return optionOf(_firebaseAuth.currentUser?.uid);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
