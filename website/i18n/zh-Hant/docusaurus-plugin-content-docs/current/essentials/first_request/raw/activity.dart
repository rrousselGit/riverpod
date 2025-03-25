/* SNIPPET START */ /// `GET /api/activity` 請求的響應。
class Activity {
  Activity({
    required this.key,
    required this.activity,
    required this.type,
    required this.participants,
    required this.price,
  });

  /// 將 JSON 物件轉換為 [Activity] 例項。
  /// 這可以實現 API 響應的型別安全讀取。
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
