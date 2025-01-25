// ignore_for_file: prefer_const_constructors

import 'package:firebase_login/auth/auth_repository.dart';
import 'package:firebase_login/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'pump_app.dart';

void main() {
  late AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    when(() => authRepository.signOut()).thenAnswer((_) => Future.value());
  });

  group('Home', () {
    testWidgets('triggers signOut on icon click', (tester) async {
      await tester.pumpApp(
        MaterialApp(home: HomePage()),
        authRepository: authRepository,
      );
      await tester.tap(find.byType(IconButton));
      verify(() => authRepository.signOut()).called(1);
    });
  });
}
