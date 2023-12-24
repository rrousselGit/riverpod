/* SNIPPET START */

import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// La risposta dell'endpoint `GET /api/activity`.
///
/// È definita utilizzando `freezed` e `json_serializable`..
@freezed
class Activity with _$Activity {
  factory Activity({
    required String key,
    required String activity,
    required String type,
    required int participants,
    required double price,
  }) = _Activity;

  /// Converte un oggetto JSON in un'istanza di [Activity].
  /// Questo consente una lettura type-safe della risposta API.
  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}
