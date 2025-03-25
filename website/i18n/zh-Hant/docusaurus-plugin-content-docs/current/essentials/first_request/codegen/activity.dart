/* SNIPPET START */ import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// `GET /api/activity` 請求的響應。
///
/// 這個定義使用了 `freezed` 和 `json_serializable`。
@freezed
sealed class Activity with _$Activity {
  factory Activity({
    required String key,
    required String activity,
    required String type,
    required int participants,
    required double price,
  }) = _Activity;

  /// 將 JSON 物件轉換為 [Activity] 例項。
  /// 這可以實現 API 響應的型別安全讀取。
  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
