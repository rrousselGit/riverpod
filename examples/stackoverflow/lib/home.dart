// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'question.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StackOverflow'),
      ),
      body: HookConsumer(
        builder: (context, ref, child) {
          final count = ref.watch(questionsCountProvider);

          return count.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (err, stack) {
              if (err is DioException) {
                return Text(
                  err.response!.data.toString(),
                );
              }
              return Text('Error $err\n$stack');
            },
            data: (count) {
              return RefreshIndicator(
                onRefresh: () {
                  ref.invalidate(paginatedQuestionsProvider(0));
                  return ref.read(paginatedQuestionsProvider(0).future);
                },
                child: ListView.separated(
                  itemCount: count,
                  itemBuilder: (context, index) {
                    return ProviderScope(
                      overrides: [
                        currentQuestion.overrideWithValue(
                          ref
                              .watch(paginatedQuestionsProvider(index ~/ 50))
                              .whenData((page) => page.items[index % 50]),
                        ),
                      ],
                      child: const QuestionItem(),
                    );
                  },
                  separatorBuilder: (context, _) {
                    return const Divider(
                      height: 30,
                      color: Color(0xff3d3d3d),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
