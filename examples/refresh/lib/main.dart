import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';

part 'main.freezed.dart';
part 'main.g.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

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

class TimestampParser implements JsonConverter<DateTime, int> {
  const TimestampParser();

  @override
  DateTime fromJson(int json) {
    return DateTime.fromMillisecondsSinceEpoch(
      json * 1000,
      isUtc: true,
    );
  }

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}

@freezed
abstract class Owner with _$Owner {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Owner({
    @required int reputation,
    @required int userId,
    BadgeCount badgeCounts,
    @required String displayName,
    @required String profileImage,
    @required String link,
  }) = _Owner;

  factory Owner.fromJson(Map<String, Object> json) => _$OwnerFromJson(json);
}

@freezed
abstract class BadgeCount with _$BadgeCount {
  factory BadgeCount({
    @required int bronze,
    @required int silver,
    @required int gold,
  }) = _BadgeCount;

  factory BadgeCount.fromJson(Map<String, Object> json) =>
      _$BadgeCountFromJson(json);
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
              return e.copyWith(body: document.body.text);
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
abstract class TagTheme with _$TagTheme {
  const factory TagTheme({
    @required TextStyle style,
    @required EdgeInsets padding,
    @required Color backgroundColor,
    @required BorderRadius borderRadius,
  }) = _TagTheme;
}

final tagThemeProvider = ScopedProvider<TagTheme>(null);

@freezed
abstract class QuestionTheme with _$QuestionTheme {
  const factory QuestionTheme({
    @required TextStyle titleStyle,
    @required TextStyle descriptionStyle,
  }) = _QuestionTheme;
}

final questionThemeProvider = ScopedProvider<QuestionTheme>(null);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        final theme = Theme.of(context);

        return ProviderScope(
          overrides: [
            tagThemeProvider.overrideWithValue(
              TagTheme(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.textTheme.bodyText1.fontSize * 0.5,
                  vertical: theme.textTheme.bodyText1.fontSize * 0.4,
                ),
                style: theme.textTheme.bodyText2.copyWith(
                  color: const Color(0xff9cc3db),
                ),
                borderRadius: BorderRadius.circular(3),
                backgroundColor: const Color(0xFF3e4a52),
              ),
            ),
            questionThemeProvider.overrideWithValue(
              const QuestionTheme(
                titleStyle: TextStyle(
                  color: Color(0xFF3ca4ff),
                  fontSize: 16,
                ),
                descriptionStyle: TextStyle(
                  color: Color(0xFFe7e8eb),
                  fontSize: 13,
                ),
              ),
            ),
          ],
          child: ListTileTheme(
            textColor: const Color(0xFFe7e8eb),
            child: child,
          ),
        );
      },
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF2d2d2d),
      ),
      home: const MyHomePage(),
    );
  }
}

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

class AnswersCount extends StatelessWidget {
  const AnswersCount(
    this.answerCount, {
    Key key,
    @required this.accepted,
  }) : super(key: key);

  final int answerCount;
  final bool accepted;

  @override
  Widget build(BuildContext context) {
    final textStyle = accepted
        ? null
        : answerCount == 0
            ? const TextStyle(color: Color(0xffacb2b8))
            : const TextStyle(color: Color(0xff5a9e6f));
    return Container(
      decoration: answerCount > 0
          ? BoxDecoration(
              color: accepted ? const Color(0xff5a9e6f) : null,
              border: Border.all(color: const Color(0xff5a9e6f)),
              borderRadius: BorderRadius.circular(3),
            )
          : null,
      padding: const EdgeInsets.all(7),
      child: Column(
        children: [
          Text(answerCount.toString(), style: textStyle),
          Text('answers', style: textStyle)
        ],
      ),
    );
  }
}

class UpvoteCount extends StatelessWidget {
  const UpvoteCount(this.upvoteCount, {Key key}) : super(key: key);

  final int upvoteCount;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Color(0xffacb2b8));

    return Padding(
      padding: const EdgeInsets.all(7),
      child: Column(
        children: [
          Text(upvoteCount.toString(), style: textStyle),
          const Text('votes', style: textStyle)
        ],
      ),
    );
  }
}

String _useCreatedSince(DateTime creationDate) {
  final label = useState('');

  useEffect(() {
    void setLabel() {
      final now = DateTime.now();
      final diff = now.difference(creationDate);

      String value;
      if (diff.inDays > 1) {
        value = '${diff.inDays} days';
      } else if (diff.inHours > 0) {
        value = '${diff.inHours} hours';
      } else if (diff.inMinutes > 0) {
        value = '${diff.inMinutes} mins';
      } else {
        value = '${diff.inSeconds} seconds';
      }

      label.value = 'asked $value ago';
    }

    setLabel();
    final timer = Timer.periodic(const Duration(minutes: 1), (_) => setLabel());

    return timer.cancel;
  }, [creationDate]);

  return label.value;
}

class PostInfo extends HookWidget {
  const PostInfo({
    Key key,
    @required this.owner,
    @required this.creationDate,
  }) : super(key: key);

  final Owner owner;
  final DateTime creationDate;

  @override
  Widget build(BuildContext context) {
    final label = _useCreatedSince(creationDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9fa6ad),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(owner.profileImage),
            ),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owner.displayName,
                  style: const TextStyle(
                    color: Color(0xff3ca4ff),
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${owner.reputation}',
                      style: const TextStyle(
                        color: Color(0xff9fa6ad),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (owner.badgeCounts != null) ...[
                      if (owner.badgeCounts.gold > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xffffcc00),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${owner.badgeCounts.gold}',
                          style: const TextStyle(
                            color: Color(0xff9fa6ad),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      if (owner.badgeCounts.silver > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xffb4b8bc),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${owner.badgeCounts.silver}',
                          style: const TextStyle(
                            color: Color(0xff9fa6ad),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      if (owner.badgeCounts.bronze > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xffd1a784),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${owner.badgeCounts.bronze}',
                          style: const TextStyle(
                            color: Color(0xff9fa6ad),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class Tag extends HookWidget {
  const Tag({
    Key key,
    @required this.tag,
  }) : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) {
    final tagTheme = useProvider(tagThemeProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: tagTheme.borderRadius,
        color: tagTheme.backgroundColor,
      ),
      padding: tagTheme.padding,
      child: Text(tag, style: tagTheme.style),
    );
  }
}
