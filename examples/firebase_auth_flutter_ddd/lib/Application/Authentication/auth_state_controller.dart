import 'package:dartz/dartz.dart';
import 'package:firebase_auth_flutter_ddd/Domain/Authentication/auth_failures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Domain/Authentication/auth_value_objects.dart';
import '../../Domain/Authentication/i_auth_facade.dart';
import 'auth_events.dart';
import 'auth_states.dart';

class AuthStateController extends StateNotifier<AuthStates> {
  AuthStateController(this._authFacade) : super(AuthStates.initial());

  final IAuthFacade _authFacade;

  Future mapEventsToStates(AuthEvents events) async {
    return events.map(
      emailChanged: (value) async {
        state = state.copyWith(
            emailAddress: EmailAddress(
              email: value.email,
            ),
            authFailureOrSuccess: none());
      },
      passwordChanged: (value) async {
        state = state.copyWith(
          password: Password(
            password: value.password,
          ),
          authFailureOrSuccess: none(),
        );
      },
      signUpWithEmailAndPasswordPressed: (value) async {
        await _performAuthAction(
          _authFacade.registerWithEmailAndPassword,
        );
      },
      signInWithEmailAndPasswordPressed: (value) async {
        await _performAuthAction(
          _authFacade.signInWithEmailAndPassword,
        );
      },
    );
  }

  Future _performAuthAction(
    Future<Either<AuthFailures, Unit>> Function(
            {required EmailAddress emailAddress, required Password password})
        forwardCall,
  ) async {
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    Either<AuthFailures, Unit>? failureOrSuccess;
    if (isEmailValid && isPasswordValid) {
      state = state.copyWith(
        isSubmitting: true,
        authFailureOrSuccess: none(),
      );
      failureOrSuccess = await forwardCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }
    state = state.copyWith(
      isSubmitting: false,
      showError: true,
      authFailureOrSuccess: optionOf(failureOrSuccess),
    );
  }
}
