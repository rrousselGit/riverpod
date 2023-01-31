// A provider that controls the current page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unoptimized_previous_button.g.dart';

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

class PreviousButton extends ConsumerWidget {
  const PreviousButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 如果不是第一页，那么前一页按钮可用
    final canGoToPreviousPage = ref.watch(pageIndexProvider) != 0;

    void goToPreviousPage() {
      ref.read(pageIndexProvider.notifier).goToPreviousPage();
    }

    return ElevatedButton(
      onPressed: canGoToPreviousPage ? goToPreviousPage : null,
      child: const Text('previous'),
    );
  }
}
