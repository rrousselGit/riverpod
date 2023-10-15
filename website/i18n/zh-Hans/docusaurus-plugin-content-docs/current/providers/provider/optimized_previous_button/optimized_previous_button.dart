// A provider that controls the current page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'optimized_previous_button.g.dart';

/* SNIPPET START */

@riverpod
class PageIndex extends _$PageIndex {
  @override
  int build() {
    return 0;
  }

  void goToPreviousPage() {
    state = state - 1;
  }
}

// 一个计算是否允许用户跳转到上一页的provider
@riverpod
/* highlight-start */
bool canGoToPreviousPage(CanGoToPreviousPageRef ref) {
/* highlight-end */
  return ref.watch(pageIndexProvider) != 0;
}

class PreviousButton extends ConsumerWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 现在我们观察我们新的provider，
    // 当我们跳转到前一页时我们的widget不再需要计算。
/* highlight-start */
    final canGoToPreviousPage = ref.watch(canGoToPreviousPageProvider);
/* highlight-end */

    void goToPreviousPage() {
      ref.read(pageIndexProvider.notifier).goToPreviousPage();
    }

    return ElevatedButton(
      onPressed: canGoToPreviousPage ? goToPreviousPage : null,
      child: const Text('previous'),
    );
  }
}
