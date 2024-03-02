import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class Repository {
  Future<List<Todo>> fetchTodos() async => [];
}

class Todo {
  Todo({
    required this.id,
    required this.label,
    required this.completed,
  });

  final String id;
  final String label;
  final bool completed;
}

// আমরা আমাদের ইন্সটেন্স একটি প্রভাইডার এ এক্সপোস করলাম
final repositoryProvider = Provider((ref) => Repository());

/// টুডুস গুলার তালিকা. আমরা এখানে এটি খুব সাধারণ ভাবে সার্ভার থেকে ফেচ করতেছি
/// [Repository] ব্যবহার করে এবং এখানে আমরা আর কিছু করতেছি না।
final todoListProvider = FutureProvider((ref) async {
  // রিপোসেটোরি এর ইন্সট্যান্স নিলাম
  final repository = ref.read(repositoryProvider);

  // টুডু গুলা ফেচ করলাম, এবং তা ইউয়াই (UI) তে এক্সপোস করে দিলাম
  return repository.fetchTodos();
});

/// একটি রিপোসোটোরী এর মকেড ইমপ্লেমেন্টেশন যেটি একটি পূর্ব নির্ধারিত টুডু লিস্ট রিটার্ন করে
class FakeRepository implements Repository {
  @override
  Future<List<Todo>> fetchTodos() async {
    return [
      Todo(id: '42', label: 'Hello world', completed: false),
    ];
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.todo});
  final Todo todo;
  @override
  Widget build(BuildContext context) {
    return Text(todo.label);
  }
}

void main() {
  testWidgets('override repositoryProvider', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [repositoryProvider.overrideWithValue(FakeRepository())],
        // আমাদের এপ্লিকেশন, যেটি todoListProvider থেকে রিড করবে todo-list ডিসপ্লে করার জন্যে
        // আপনি এটি এক্সট্রেক্ট অথবা রিফেক্টর করে MyApp উইজেট করতে পারেন
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(builder: (context, ref, _) {
              final todos = ref.watch(todoListProvider);
              // টুডুস গুলার তালিকা, এটা কি Error না কি Loading এ আছে
              if (todos.asData == null) {
                return const CircularProgressIndicator();
              }
              return ListView(
                children: [
                  for (final todo in todos.asData!.value) TodoItem(todo: todo)
                ],
              );
            }),
          ),
        ),
      ),
    );

    // প্রথম ফ্রেমটি হচ্ছে লোডিং স্ট্যাট (Loading)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // রি-রেন্ডার. TodoListProvider এতক্ষণে টুডুস গুলা ফেচ করার কাজ শেষ করে ফেলেছে
    await tester.pump();

    // লোডিং আর থাকবে না
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // একটি TodoItem রেন্ডার হয়েছে, যে ডাটা গুলা FakeRepository দ্বারা রিটার্ন করা হয়েছে
    expect(tester.widgetList(find.byType(TodoItem)), [
      isA<TodoItem>()
          .having((s) => s.todo.id, 'todo.id', '42')
          .having((s) => s.todo.label, 'todo.label', 'Hello world')
          .having((s) => s.todo.completed, 'todo.completed', false),
    ]);
  });
}
