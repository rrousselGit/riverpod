/* SNIPPET START */

import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

// {@template activity}
/// The response of the `GET /api/activity` endpoint.
// {@endtemplate}
///
// {@template codegen_freezed}
/// It is defined using `freezed` and `json_serializable`.
// {@endtemplate}
@freezed
class Activity with _$Activity {
  factory Activity({
    required String key,
    required String activity,
    required String type,
    required int participants,
    required double price,
  }) = _Activity;

  // {@template fromJson}
  /// Convert a JSON object into an [Activity] instance.
  /// This enables type-safe reading of the API response.
  // {@endtemplate}
  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}
