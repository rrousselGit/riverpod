import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRepository {}

final repositoryProvider = Provider((ref) => FakeRepository());

abstract class Todo {
  String get id;
  String get label;
  bool get completed;
}

final todoListProvider = FutureProvider<List<Todo>>((ref) => []);

void main() {
/* SNIPPET START */

  test('override repositoryProvider', () async {
    final container = ProviderContainer(
      overrides: [
        //  repositoryProvider এর আচরণ পরিবর্তন করে
        //  FakeRepository রিটার্ন করবে আসল Repository এর বদলে
        /* highlight-start */
        repositoryProvider.overrideWithValue(FakeRepository()),
        /* highlight-end */
        // আমাদের `todoListProvider` প্রভাইডার ওভাররাইড করার প্রয়োজন নেই,
        // এটি অটোমেটিকলী ওভাররাইডেন repositoryProvider ব্যবহার করবে
      ],
    );

    // প্রথম রিড, লোডিং স্ট্যাটাস কিনা চেক হচ্ছে
    expect(
      container.read(todoListProvider),
      const AsyncValue<List<Todo>>.loading(),
    );

    /// রিকুয়েস্ট শেষ হওয়ার জন্য অপেক্ষা চলতেছে
    await container.read(todoListProvider.future);

    // ফেচ হওয়া ডাটা এক্সপোস করবে
    expect(container.read(todoListProvider).value, [
      isA<Todo>()
          .having((s) => s.id, 'id', '42')
          .having((s) => s.label, 'label', 'Hello world')
          .having((s) => s.completed, 'completed', false),
    ]);
  });

/* SNIPPET END */
}
