/* SNIPPET START */
class Activity {
  Activity({
    required this.activity,
    required this.type,
    required this.participants,
    required this.price,
  });

  factory Activity.fromJson(Map<Object?, Object?> json) {
    return Activity(
      activity: json['activity']! as String,
      type: json['type']! as String,
      participants: json['participants']! as int,
      price: json['price']! as double,
    );
  }

  final String activity;
  final String type;
  final int participants;
  final double price;
}
/* SNIPPET END */
