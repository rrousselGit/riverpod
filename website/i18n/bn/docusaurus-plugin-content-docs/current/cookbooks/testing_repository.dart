import 'package:hooks_riverpod/hooks_riverpod.dart';

class Todo {}

/* SNIPPET START */

class Repository {
  Future<List<Todo>> fetchTodos() async => [];
}

// আমরা আমাদের রিপোসেটোরি এর ইন্সটেন্স-টি একটি প্রভাইডার এ এক্সপোস করলাম
final repositoryProvider = Provider((ref) => Repository());

/// টুডুস গুলার তালিকা. আমরা এখানে এটি খুব সাধারণ ভাবে সার্ভার থেকে ফেচ করতেছি
/// [Repository] ব্যবহার করে এবং এখানে আমরা আর কিছু করতেছি না।
final todoListProvider = FutureProvider((ref) async {
  // রিপোসেটোরি এর ইন্সট্যান্স নিলাম
  final repository = ref.watch(repositoryProvider);

  // টুডু গুলা ফেচ করলাম, এবং তা ইউয়াই (UI) তে এক্সপোস করে দিলাম
  return repository.fetchTodos();
});
