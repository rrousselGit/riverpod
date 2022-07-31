import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/parser.dart';

import 'common.dart';
import 'tag.dart';

part 'question.g.dart';
part 'question.freezed.dart';

@freezed
class QuestionsResponse with _$QuestionsResponse {
  factory QuestionsResponse({
    required List<Question> items,
    required int total,
  }) = _QuestionsResponse;

  factory QuestionsResponse.fromJson(Map<String, Object?> json) =>
      _$QuestionsResponseFromJson(json);
}

@freezed
class Question with _$Question {
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

  factory Question.fromJson(Map<String, Object?> json) =>
      _$QuestionFromJson(json);
}

final paginatedQuestionsProvider = FutureProvider.autoDispose
    .family<QuestionsResponse, int>((ref, pageIndex) async {
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

  ref.keepAlive();

  return page;
});

final questionsCountProvider = Provider.autoDispose((ref) {
  return ref
      .watch(paginatedQuestionsProvider(0))
      .whenData((page) => page.total);
});

@freezed
class QuestionTheme with _$QuestionTheme {
  const factory QuestionTheme({
    required TextStyle titleStyle,
    required TextStyle descriptionStyle,
  }) = _QuestionTheme;
}

final questionThemeProvider = Provider<QuestionTheme>((ref) {
  return const QuestionTheme(
    titleStyle: TextStyle(
      color: Color(0xFF3ca4ff),
      fontSize: 16,
    ),
    descriptionStyle: TextStyle(
      color: Color(0xFFe7e8eb),
      fontSize: 13,
    ),
  );
});

/// A scoped provider, exposing the current question used by [QuestionItem].
///
/// This is used as a performance optimization to pass a [Question] to
/// [QuestionItem], while still instantiating [QuestionItem] using the `const`
/// keyword.
///
/// This allows [QuestionItem] to rebuild less often.
/// By doing so, even when using [QuestionItem] in a [ListView], even if new
/// questions are obtained, previously rendered [QuestionItem]s won't rebuild.
///
/// This is an optional step. Since scoping is a fairly advanced mechanism,
/// it's entirely fine to simply pass the [Question] to [QuestionItem] directly.
final currentQuestion = Provider<AsyncValue<Question>>((ref) {
  throw UnimplementedError();
});

/// A UI widget rendering a [Question].
///
/// That question will be obtained through [currentQuestion]. As such, it is
/// necessary to override that provider before using [QuestionItem].
class QuestionItem extends HookConsumerWidget {
  const QuestionItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = ref.watch(currentQuestion);
    final questionTheme = ref.watch(questionThemeProvider);

    return question.when(
      // TODO(rrousselGit): improve error rendering
      error: (error, stack) => const Center(child: Text('Error')),
      loading: () => const Center(child: Text('loading')),
      data: (question) {
        return ListTile(
          title: Text(
            question.title,
            style: questionTheme.titleStyle,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(
                question.body,
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
                      for (final tag in question.tags) Tag(tag: tag),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: PostInfo(
                          owner: question.owner,
                          creationDate: question.creationDate,
                        ),
                      ),
                      UpvoteCount(question.score),
                      const SizedBox(width: 10),
                      AnswersCount(
                        question.answerCount,
                        accepted: question.acceptedAnswerId != null,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
