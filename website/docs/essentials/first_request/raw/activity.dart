/* SNIPPET START */

// {@template activity}
/// The response of the `GET /api/activity` endpoint.
// {@endtemplate}
class Activity {
  Activity({
    required this.key,
    required this.activity,
    required this.type,
    required this.participants,
    required this.price,
  });

  // {@template fromJson}
  /// Convert a JSON object into an [Activity] instance.
  /// This enables type-safe reading of the API response.
  // {@endtemplate}
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      key: json['key'] as String,
      activity: json['activity'] as String,
      type: json['type'] as String,
      participants: json['participants'] as int,
      price: json['price'] as double,
    );
  }

  final String key;
  final String activity;
  final String type;
  final int participants;
  final double price;
}
