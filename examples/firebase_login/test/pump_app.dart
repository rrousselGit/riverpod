import 'package:firebase_login/auth/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

extension WidgetTesterExtension on WidgetTester {
  Future<void> pumpApp(Widget child, {AuthRepository? authRepository}) {
    return pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            authRepository ?? MockAuthRepository(),
          ),
        ],
        child: child,
      ),
    );
  }
}
