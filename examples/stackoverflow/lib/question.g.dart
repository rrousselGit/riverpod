// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionsResponseImpl _$$QuestionsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionsResponseImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$$QuestionsResponseImplToJson(
        _$QuestionsResponseImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
    };

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
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

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
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
