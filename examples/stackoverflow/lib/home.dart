import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/parser.dart';

import 'common.dart';

part 'home.g.dart';
part 'home.freezed.dart';

@freezed
abstract class QuestionsResponse with _$QuestionsResponse {
  factory QuestionsResponse({
    @required List<Question> items,
    @required int total,
  }) = _QuestionsResponse;

  factory QuestionsResponse.fromJson(Map<String, Object> json) =>
      _$QuestionsResponseFromJson(json);
}

@freezed
abstract class Question with _$Question {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Question({
    @required List<String> tags,
    @required int viewCount,
    @required int score,
    int bountyAmount,
    int acceptedAnswerId,
    @required Owner owner,
    @required int answerCount,
    @required @TimestampParser() DateTime creationDate,
    @required int questionId,
    @required String link,
    @required String title,
    @required String body,
  }) = _Question;

  factory Question.fromJson(Map<String, Object> json) =>
      _$QuestionFromJson(json);
}

final client = Provider((ref) => Dio());

class PaginatedQuestions extends ChangeNotifier {
  PaginatedQuestions(this._client);

  final Dio _client;
  final _pages = <AsyncValue<QuestionsResponse>>[];
  final _questions = <int, AsyncValue<Question>>{};
  final _cancelTokens = DoubleLinkedQueue<CancelToken>();

  Future<QuestionsResponse> _firstPage;
  Future<QuestionsResponse> get firstPage => _firstPage;

  AsyncValue<int> get questionsCount {
    if (_pages.isEmpty) {
      getQuestionAt(0);
      return const AsyncValue.loading();
    }

    return _pages.first.whenData((page) => page.total);
  }

  /// Questions can be deleted as we scroll, so we cannot simply rely on the index
  /// to fetch question.
  /// The algorithm instead relies on the creation date of the last previous of
  /// the previous page, such that the next page starts from the end of the
  /// previous page.
  AsyncValue<Question> getQuestionAt(int index) {
    // If the previous question isn't fetched or failed to fetch, returns a
    // loading/error status.
    if (index > 0 && !_questions.containsKey(index)) {
      final previousQuestion = getQuestionAt(index - 1);
      if (previousQuestion.data == null) {
        return previousQuestion;
      }
    }

    // At this point, we are always on the last page since the algorithm
    // awaits for all the previous questions to be fetched.
    return _questions.putIfAbsent(index, () {
      final pageStartDate = _pages.isEmpty
          ? null
          : _pages.last.data.value.items.last.creationDate;

      Future<void> fetch() async {
        final page = await AsyncValue.guard<QuestionsResponse>(() async {
          final cancelToken = CancelToken();
          _cancelTokens.add(cancelToken);

          final uri = Uri(
            scheme: 'https',
            host: 'api.stackexchange.com',
            path: '/2.2/questions',
            queryParameters: <String, String>{
              'order': 'desc',
              'sort': 'creation',
              'site': 'stackoverflow',
              'filter': '!17vW1m9jnXcpKOO(p4a5Jj.QeqRQmvxcbquXIXJ1fJcKq4',
              'tagged': 'flutter',
              if (pageStartDate != null)
                'todate':
                    (pageStartDate.millisecondsSinceEpoch ~/ 1000).toString()
            },
          );

          print('fetch $uri');

          final response = await _client.getUri<Map<String, Object>>(
            uri,
            cancelToken: cancelToken,
          );
          final parsed = QuestionsResponse.fromJson(response.data);
          final page = parsed.copyWith(
            items: parsed.items.map((e) {
              final document = parse(e.body);
              return e.copyWith(body: document.body.text.replaceAll('\n', ' '));
            }).toList(),
          );

          return page;
        });

        _pages.add(page);
        notifyListeners();

        page.when(
          // never reached
          loading: () {},
          data: (page) {
            for (var i = 0; i < page.items.length; i++) {
              _questions[index + i] = AsyncValue.data(page.items[i]);
            }
          },
          error: (error, stack) {
            for (var i = index; i < _questions.length; i++) {
              _questions[i] = AsyncValue.error(error, stack);
            }
          },
        );
      }

      fetch();

      return const AsyncValue.loading();
    });
  }

  @override
  void dispose() {
    for (final cancelToken in _cancelTokens) {
      cancelToken.cancel();
    }
    super.dispose();
  }
}

final questionsProvider = ChangeNotifierProvider.autoDispose((ref) {
  return PaginatedQuestions(ref.watch(client));
});

final questionsCountProvider = Provider.autoDispose((ref) {
  return ref.watch(questionsProvider).questionsCount;
});

// final questionsProvider = FutureProvider.autoDispose
//     .family<QuestionsResponse, int>((ref, page) async {
//   final cancelToken = CancelToken();
//   ref.onDispose(cancelToken.cancel);

//   final response = await ref.watch(client).get<Map<String, Object>>(
//     'https://api.stackexchange.com/2.2/questions',
//     cancelToken: cancelToken,
//     queryParameters: <String, String>{
//       'order': 'desc',
//       'sort': 'creation',
//       'site': 'stackoverflow',
//       'filter': '!17vW1m9jnXcpKOO(p4a5Jj.QeqRQmvxcbquXIXJ1fJcKq4',
//       'tagged': 'flutter'
//     },
//   );

//   final parsed = QuestionsResponse.fromJson(response.data);
//   return parsed.copyWith(
//     items: parsed.items.map((e) {
//       final document = parse(e.body);
//       return e.copyWith(body: document.body.text);
//     }).toList(),
//   );
// });

@freezed
abstract class QuestionTheme with _$QuestionTheme {
  const factory QuestionTheme({
    @required TextStyle titleStyle,
    @required TextStyle descriptionStyle,
  }) = _QuestionTheme;
}

final questionThemeProvider = ScopedProvider<QuestionTheme>(null);

class MyHomePage extends HookWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useReassemble(() {
      return Future.microtask(() {
        context.read(questionsProvider).notifyListeners();
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('StackOverflow'),
      ),
      body: HookBuilder(builder: (context) {
        final count = useProvider(questionsCountProvider);
        print(count);
        return count.when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error $err'),
          data: (count) {
            return RefreshIndicator(
              onRefresh: () {
                return context.refresh(questionsProvider).firstPage;
              },
              child: ListView.separated(
                itemCount: count,
                itemBuilder: (context, index) {
                  return ProviderScope(
                    overrides: [
                      currentQuestion.overrideAs((watch) {
                        return watch(questionsProvider).getQuestionAt(index);
                      }),
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

final currentQuestion = ScopedProvider<AsyncValue<Question>>(null);

class QuestionItem extends HookWidget {
  const QuestionItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final question = useProvider(currentQuestion);
    final questionTheme = useProvider(questionThemeProvider);

    if (question.data == null) {
      return Center(child: Text('loading'));
    }

    final data = question.data.value;

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
