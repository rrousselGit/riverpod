/* SNIPPET START */

import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// `GET /api/activity` 엔드포인트의 응답
///
/// `freezed`와 `json_serializable`을 사용하여 정의됩니다.
@freezed
class Activity with _$Activity {
  factory Activity({
    required String key,
    required String activity,
    required String type,
    required int participants,
    required double price,
  }) = _Activity;

  /// JSON 객체를 [Activity] 인스턴스로 변환합니다.
  /// 이렇게 하면 API 응답을 형안정(Type-safe)하게 읽을 수 있습니다.
  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}
