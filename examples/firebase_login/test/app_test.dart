// ignore_for_file: prefer_const_constructors

import 'package:firebase_login/auth/auth_repository.dart';
import 'package:firebase_login/auth/user.dart';
import 'package:firebase_login/home/home.dart';
import 'package:firebase_login/main.dart';
import 'package:firebase_login/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'pump_app.dart';

void main() {
  late AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    when(() => authRepository.user).thenAnswer((_) => Stream.empty());
  });

  group('App', () {
    testWidgets(
      'renders SignInPage when the user stream is empty',
      (tester) async {
        await tester.pumpApp(App(), authRepository: authRepository);
        expect(find.byType(SignInPage), findsOneWidget);
      },
    );

    testWidgets(
      'renders SignInPage when the user stream emits User.empty',
      (tester) async {
        when(() => authRepository.user).thenAnswer(
          (_) => Stream.value(User.empty()),
        );
        await tester.pumpApp(App(), authRepository: authRepository);
        await tester.pumpAndSettle();
        expect(find.byType(SignInPage), findsOneWidget);
      },
    );

    testWidgets(
      'renders HomePage when the user stream emits authenticated user',
      (tester) async {
        when(() => authRepository.user).thenAnswer(
          (_) => Stream.value(User(id: 'abc')),
        );
        await tester.pumpApp(App(), authRepository: authRepository);
        await tester.pumpAndSettle();
        expect(find.byType(HomePage), findsOneWidget);
      },
    );
  });
}
