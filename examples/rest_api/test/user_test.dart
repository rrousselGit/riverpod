import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:rest_api/main.dart';

// Generate mock classes
@GenerateNiceMocks([MockSpec<Dio>()])
import 'user_test.mocks.dart';

void main() {
  group('UserRepository Tests', () {
    late MockDio mockDio;
    late UserRepository repository;

    setUp(() {
      mockDio = MockDio();
      repository = UserRepository(mockDio);
    });

    test('fetchUsers returns list of users', () async {
      // Arrange
      when(mockDio.get('https://jsonplaceholder.typicode.com/users'))
          .thenAnswer((_) async => Response(
                data: [
                  {
                    'id': 1,
                    'name': 'Test User',
                    'email': 'test@example.com',
                  }
                ],
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      // Act
      final users = await repository.fetchUsers();

      // Assert
      expect(users.length, 1);
      expect(users.first.name, 'Test User');
      expect(users.first.email, 'test@example.com');
    });

    test('createUser returns created user', () async {
      // Arrange
      final newUser = User(id: 0, name: 'New User', email: 'new@example.com');
      when(mockDio.post(
        'https://jsonplaceholder.typicode.com/users',
        data: newUser.toJson(),
      )).thenAnswer((_) async => Response(
            data: {
              'id': 1,
              'name': 'New User',
              'email': 'new@example.com',
            },
            statusCode: 201,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final createdUser = await repository.createUser(newUser);

      // Assert
      expect(createdUser.id, 1);
      expect(createdUser.name, 'New User');
      expect(createdUser.email, 'new@example.com');
    });
  });

  group('UsersNotifier Tests', () {
    late ProviderContainer container;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      container = ProviderContainer(
        overrides: [
          dioProvider.overrideWithValue(mockDio),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state loads users', () async {
      // Arrange
      when(mockDio.get('https://jsonplaceholder.typicode.com/users'))
          .thenAnswer((_) async => Response(
                data: [
                  {
                    'id': 1,
                    'name': 'Test User',
                    'email': 'test@example.com',
                  }
                ],
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      // Act & Assert
      expect(
        container.read(usersProvider),
        const AsyncValue<List<User>>.loading(),
      );

      await container.read(usersProvider.future);

      final users = container.read(usersProvider).value;
      expect(users?.length, 1);
      expect(users?.first.name, 'Test User');
    });

    test('addUser adds user to state', () async {
      // Arrange
      when(mockDio.get('https://jsonplaceholder.typicode.com/users'))
          .thenAnswer((_) async => Response(
                data: [],
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final newUser = User(id: 0, name: 'New User', email: 'new@example.com');
      when(mockDio.post(
        'https://jsonplaceholder.typicode.com/users',
        data: newUser.toJson(),
      )).thenAnswer((_) async => Response(
            data: {
              'id': 1,
              'name': 'New User',
              'email': 'new@example.com',
            },
            statusCode: 201,
            requestOptions: RequestOptions(path: ''),
          ));

      // Wait for initial load
      await container.read(usersProvider.future);

      // Act
      await container.read(usersProvider.notifier).addUser(newUser);

      // Assert
      final users = container.read(usersProvider).value;
      expect(users?.length, 1);
      expect(users?.first.name, 'New User');
    });
  });
}
