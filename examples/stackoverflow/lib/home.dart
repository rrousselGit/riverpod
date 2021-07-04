// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:html/parser.dart';

import 'common.dart';

part 'home.freezed.dart';
part 'home.g.dart';

@freezed
abstract class QuestionsResponse with _$QuestionsResponse {
  factory QuestionsResponse({
    required List<Question> items,
    required int total,
  }) = _QuestionsResponse;

  factory QuestionsResponse.fromJson(Map<String, Object?> json) =>
      _$QuestionsResponseFromJson(json);
}

@freezed
abstract class Question with _$Question {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Question({
    required List<String> tags,
    required int viewCount,
    required int score,
    int? bountyAmount,
    int? acceptedAnswerId,
    required Owner owner,
    required int answerCount,
    @TimestampParser() required DateTime creationDate,
    required int questionId,
    required String link,
    required String title,
    required String body,
  }) = _Question;

  factory Question.fromJson(Map<String, Object> json) =>
      _$QuestionFromJson(json);
}

final client = Provider((ref) => Dio());

final _fetchedPages = StateProvider((ref) => <int>[]);

final paginatedQuestionsProvider = FutureProvider.autoDispose
    .family<QuestionsResponse, int>((ref, pageIndex) async {
  final fetchedPages = ref.watch(_fetchedPages).state;
  fetchedPages.add(pageIndex);
  ref.onDispose(() => fetchedPages.remove(pageIndex));

  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  final uri = Uri(
    scheme: 'https',
    host: 'api.stackexchange.com',
    path: '/2.2/questions',
    queryParameters: <String, Object>{
      'order': 'desc',
      'sort': 'creation',
      'site': 'stackoverflow',
      'filter': '!17vW1m9jnXcpKOO(p4a5Jj.QeqRQmvxcbquXIXJ1fJcKq4',
      'tagged': 'flutter',
      'pagesize': '50',
      'page': '${pageIndex + 1}',
    },
  );

  final response = await ref
      .watch(client)
      .getUri<Map<String, Object?>>(uri, cancelToken: cancelToken);

  final parsed = QuestionsResponse.fromJson(response.data!);
  final page = parsed.copyWith(
    items: parsed.items.map((e) {
      final document = parse(e.body);
      return e.copyWith(body: document.body!.text.replaceAll('\n', ' '));
    }).toList(),
  );

  ref.maintainState = true;

  return page;
});

final questionsCountProvider = Provider.autoDispose((ref) {
  return ref
      .watch(paginatedQuestionsProvider(0))
      .whenData((page) => page.total);
});

@freezed
abstract class QuestionTheme with _$QuestionTheme {
  const factory QuestionTheme({
    required TextStyle titleStyle,
    required TextStyle descriptionStyle,
  }) = _QuestionTheme;
}

final questionThemeProvider = Provider<QuestionTheme>((ref) {
  throw UnimplementedError();
});

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StackOverflow'),
      ),
      body: HookConsumer(builder: (context, ref, child) {
        final count = ref.watch(questionsCountProvider);

        return count.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (err, stack) {
            if (err is DioError) {
              return Text(
                err.response!.data.toString(),
              );
            }
            return Text('Error $err\n$stack');
          },
          data: (count) {
            return RefreshIndicator(
              onRefresh: () {
                ref.refresh(paginatedQuestionsProvider(0));
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
      }),
    );
  }
}

final currentQuestion = Provider<AsyncValue<Question>>((ref) {
  throw UnimplementedError();
});

class QuestionItem extends HookConsumerWidget {
  const QuestionItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = ref.watch(currentQuestion);
    final questionTheme = ref.watch(questionThemeProvider);

    if (question.data == null) {
      return const Center(child: Text('loading'));
    }

    final data = question.data!.value;

    return ListTile(
      title: Text(
        data.title,
        style: questionTheme.titleStyle,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Text(
            data.body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  for (final tag in data.tags) Tag(tag: tag),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: PostInfo(
                      owner: data.owner,
                      creationDate: data.creationDate,
                    ),
                  ),
                  UpvoteCount(data.score),
                  const SizedBox(width: 10),
                  AnswersCount(
                    data.answerCount,
                    accepted: data.acceptedAnswerId != null,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
