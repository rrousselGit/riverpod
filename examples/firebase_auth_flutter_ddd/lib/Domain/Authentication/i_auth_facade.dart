import 'package:dartz/dartz.dart';

import 'auth_failures.dart';
import 'auth_value_objects.dart';


abstract class IAuthFacade {
  Future<Either<AuthFailures, Unit>> registerWithEmailAndPassword(
      {required EmailAddress? emailAddress, required Password? password});

  Future<Either<AuthFailures, Unit>> signInWithEmailAndPassword(
      {required EmailAddress? emailAddress, required Password? password});

  Future<Option<String>> getSignedInUser();

  Future<void> signOut();
}
