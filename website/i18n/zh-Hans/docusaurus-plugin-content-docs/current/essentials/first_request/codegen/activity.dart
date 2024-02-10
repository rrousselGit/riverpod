/* SNIPPET START */ import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// `GET /api/activity` 请求的响应。
///
/// 这个定义使用了 `freezed` 和 `json_serializable`。
@freezed
class Activity with _$Activity {
  factory Activity({
    required String key,
    required String activity,
    required String type,
    required int participants,
    required double price,
  }) = _Activity;

  /// 将 JSON 对象转换为 [Activity] 实例。
  /// 这可以实现 API 响应的类型安全读取。
  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
