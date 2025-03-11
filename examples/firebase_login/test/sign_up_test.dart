// ignore_for_file: prefer_const_constructors

import 'package:firebase_login/auth/auth_repository.dart';
import 'package:firebase_login/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'pump_app.dart';

void main() {
  late AuthRepository authRepository;

  const emailKey = Key('email_textFormField');
  const passwordKey = Key('password_textFormField');

  setUp(() {
    authRepository = MockAuthRepository();
    when(
      () => authRepository.signUpWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
  });

  group('SignUp', () {
    testWidgets(
      'triggers signUpWithEmailAndPassword on submit button click',
      (tester) async {
        await tester.pumpApp(
          MaterialApp(home: SignUpPage()),
          authRepository: authRepository,
        );

        await tester.enterText(find.byKey(emailKey), 'email@email.com');
        await tester.enterText(find.byKey(passwordKey), 's3cRe7');

        await tester.tap(find.byType(ElevatedButton));
        verify(
          () => authRepository.signUpWithEmailAndPassword(
            email: 'email@email.com',
            password: 's3cRe7',
          ),
        ).called(1);
      },
    );
  });
}
