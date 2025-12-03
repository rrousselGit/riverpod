import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_api/main.dart';
import 'user_test.mocks.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('UserListScreen shows loading and then data',
        (WidgetTester tester) async {
      // Arrange
      final mockDio = MockDio();
      when(mockDio.get('https://jsonplaceholder.typicode.com/users'))
          .thenAnswer((_) async {
        // Add delay to simulate network request
        await Future.delayed(const Duration(milliseconds: 100));
        return Response(
          data: [
            {'id': 1, 'name': 'Test User', 'email': 'test@example.com'}
          ],
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );
      });

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dioProvider.overrideWithValue(mockDio)],
          child: const MaterialApp(home: UserListScreen()),
        ),
      );

      // Assert - should show loading first
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for async operations and rebuild
      await tester.pumpAndSettle();

      // Assert - should show user data
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Shows error message on network failure',
        (WidgetTester tester) async {
      // Arrange
      final mockDio = MockDio();
      when(mockDio.get('https://jsonplaceholder.typicode.com/users'))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'No Internet',
      ));

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dioProvider.overrideWithValue(mockDio)],
          child: const MaterialApp(home: UserListScreen()),
        ),
      );

      // Wait for async operations and rebuild
      await tester.pumpAndSettle();

      // Assert
      expect(
          find.text('Error: Exception: Failed to load users'), findsOneWidget);
    });

    testWidgets('AddUserScreen can create new user',
        (WidgetTester tester) async {
      // Arrange
      final mockDio = MockDio();
      when(mockDio.post(
        'https://jsonplaceholder.typicode.com/users',
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: {'id': 1, 'name': 'New User', 'email': 'test@example.com'},
            statusCode: 201,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dioProvider.overrideWithValue(mockDio)],
          child: const MaterialApp(home: AddUserScreen()),
        ),
      );

      // Fill form
      await tester.enterText(find.byType(TextFormField).first, 'New User');
      await tester.enterText(
          find.byType(TextFormField).last, 'test@example.com');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify
      verify(mockDio.post(
        'https://jsonplaceholder.typicode.com/users',
        data: anyNamed('data'),
      )).called(1);
    });
  });
}
