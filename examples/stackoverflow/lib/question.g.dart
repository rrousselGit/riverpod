// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_QuestionsResponse _$$_QuestionsResponseFromJson(Map<String, dynamic> json) =>
    _$_QuestionsResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );

Map<String, dynamic> _$$_QuestionsResponseToJson(
        _$_QuestionsResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
    };

_$_Question _$$_QuestionFromJson(Map<String, dynamic> json) => _$_Question(
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      viewCount: json['view_count'] as int,
      score: json['score'] as int,
      bountyAmount: json['bounty_amount'] as int?,
      acceptedAnswerId: json['accepted_answer_id'] as int?,
      owner: User.fromJson((json['owner'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, e as Object),
      )),
      answerCount: json['answer_count'] as int,
      creationDate:
          const TimestampParser().fromJson(json['creation_date'] as int),
      questionId: json['question_id'] as int,
      link: json['link'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$$_QuestionToJson(_$_Question instance) =>
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
