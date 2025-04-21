// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionsResponse _$QuestionsResponseFromJson(Map<String, dynamic> json) =>
    _QuestionsResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$QuestionsResponseToJson(_QuestionsResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
    };

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      viewCount: (json['view_count'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      bountyAmount: (json['bounty_amount'] as num?)?.toInt(),
      acceptedAnswerId: (json['accepted_answer_id'] as num?)?.toInt(),
      owner: User.fromJson((json['owner'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, e as Object),
      )),
      answerCount: (json['answer_count'] as num).toInt(),
      creationDate: const TimestampParser()
          .fromJson((json['creation_date'] as num).toInt()),
      questionId: (json['question_id'] as num).toInt(),
      link: json['link'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
      'tags': instance.tags,
      'view_count': instance.viewCount,
      'score': instance.score,
      'bounty_amount': instance.bountyAmount,
      'accepted_answer_id': instance.acceptedAnswerId,
      'owner': instance.owner,
      'answer_count': instance.answerCount,
      'creation_date': const TimestampParser().toJson(instance.creationDate),
      'question_id': instance.questionId,
      'link': instance.link,
      'title': instance.title,
      'body': instance.body,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(questionTheme)
const questionThemeProvider = QuestionThemeProvider._();

final class QuestionThemeProvider
    extends $FunctionalProvider<QuestionTheme, QuestionTheme>
    with $Provider<QuestionTheme> {
  const QuestionThemeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'questionThemeProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$questionThemeHash();

  @$internal
  @override
  $ProviderElement<QuestionTheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuestionTheme create(Ref ref) {
    return questionTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuestionTheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<QuestionTheme>(value),
    );
  }
}

String _$questionThemeHash() => r'c66658995d65c988e6db012ab7f9f754eaa0e5ce';

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
@ProviderFor(currentQuestion)
const currentQuestionProvider = CurrentQuestionProvider._();

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
final class CurrentQuestionProvider
    extends $FunctionalProvider<AsyncValue<Question>, AsyncValue<Question>>
    with $Provider<AsyncValue<Question>> {
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
  const CurrentQuestionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currentQuestionProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  @override
  String debugGetCreateSourceHash() => _$currentQuestionHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<Question>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<Question> create(Ref ref) {
    return currentQuestion(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Question> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<AsyncValue<Question>>(value),
    );
  }
}

String _$currentQuestionHash() => r'e9359841a5b980cd7b8c79a0b56cb98878190861';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
