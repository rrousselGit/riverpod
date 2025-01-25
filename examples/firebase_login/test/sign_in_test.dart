// ignore_for_file: prefer_const_constructors

import 'package:firebase_login/auth/auth_repository.dart';
import 'package:firebase_login/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'pump_app.dart';

void main() {
  late AuthRepository authRepository;

  const emailKey = Key('email_textFormField');
  const passwordKey = Key('password_textFormField');
  const emailSignInKey = Key('signInWithEmailAndPassword_elevatedButton');
  const googleSignInKey = Key('signInWithGoogle_elevatedButton');

  setUp(() {
    authRepository = MockAuthRepository();
    when(
      () => authRepository.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
    when(() => authRepository.signInWithGoogle()).thenAnswer((_) async {});
  });

  group('SignIn', () {
    testWidgets(
      'triggers signInWithEmailAndPassword on submit button click',
      (tester) async {
        await tester.pumpApp(
          MaterialApp(home: SignInPage()),
          authRepository: authRepository,
        );

        await tester.enterText(find.byKey(emailKey), 'email@email.com');
        await tester.enterText(find.byKey(passwordKey), 's3cRe7');

        await tester.tap(find.byKey(emailSignInKey));
        verify(
          () => authRepository.signInWithEmailAndPassword(
            email: 'email@email.com',
            password: 's3cRe7',
          ),
        ).called(1);
      },
    );

    testWidgets(
      'triggers signInWithGoogle on google button click',
      (tester) async {
        await tester.pumpApp(
          MaterialApp(home: SignInPage()),
          authRepository: authRepository,
        );

        await tester.tap(find.byKey(googleSignInKey));
        verify(
          () => authRepository.signInWithGoogle(),
        ).called(1);
      },
    );
  });
}
