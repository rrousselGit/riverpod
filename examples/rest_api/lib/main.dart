import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserListScreen(),
    );
  }
}

// Model class representing a User with JSON serialization
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  // Factory constructor for JSON deserialization
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
      );

  // Method for JSON serialization
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}

// Repository class handling API communications
class UserRepository {
  final Dio dio;

  UserRepository(this.dio);

  // Fetches all users from the API
  Future<List<User>> fetchUsers() async {
    try {
      final response =
          await dio.get('https://jsonplaceholder.typicode.com/users');
      return (response.data as List)
          .map((userData) => User.fromJson(userData))
          .toList();
    } catch (e) {
      throw Exception('Failed to load users');
    }
  }

  // Creates a new user via API
  Future<User> createUser(User user) async {
    try {
      final response = await dio.post(
        'https://jsonplaceholder.typicode.com/users',
        data: user.toJson(),
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user');
    }
  }
}

// Dependency injection setup using Riverpod providers
final dioProvider = Provider((ref) => Dio());

final userRepositoryProvider = Provider((ref) {
  return UserRepository(ref.watch(dioProvider));
});

// Main state provider for the users list
final usersProvider = AsyncNotifierProvider<UsersNotifier, List<User>>(() {
  return UsersNotifier();
});

// State management class for Users
class UsersNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    final repository = ref.watch(userRepositoryProvider);
    return repository.fetchUsers();
  }

  Future<void> addUser(User user) async {
    final repository = ref.watch(userRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final newUser = await repository.createUser(user);
      // Get current users and add the new one
      final currentUsers = state.value ?? [];
      return [...currentUsers, newUser];
    });
  }
}

// Main screen showing the list of users
class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the users state for changes
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddUserScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      // Using Dart 3's pattern matching with switch expression
      // This handles all possible states of AsyncValue:
      // - AsyncData: When we have the data
      // - AsyncError: When an error occurred
      // - _: Wildcard for loading and any other state
      body: switch (usersAsync) {
        AsyncData(:final value) => RefreshIndicator(
            onRefresh: () => ref.refresh(usersProvider.future),
            child: ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                final user = value[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            ),
          ),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

// Screen for adding a new user
class AddUserScreen extends ConsumerStatefulWidget {
  const AddUserScreen({super.key});

  @override
  AddUserScreenState createState() => AddUserScreenState();
}

class AddUserScreenState extends ConsumerState<AddUserScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  // Clean up controllers when the widget is disposed
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Function to pop the context to avoid using
    //context across async gaps
    void popContext() {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name input field with validation
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              // Email input field with validation
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newUser = User(
                      id: 0, // API will assign the real ID
                      name: _nameController.text,
                      email: _emailController.text,
                    );
                    // Add user and return to previous screen
                    await ref.read(usersProvider.notifier).addUser(newUser);
                    popContext();
                  }
                },
                child: const Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
