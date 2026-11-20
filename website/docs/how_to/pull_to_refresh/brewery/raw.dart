/* SNIPPET START */
class Brewery {
  Brewery({
    required this.name,
    required this.breweryType,
    required this.city,
    required this.country,
  });

  factory Brewery.fromJson(Map<Object?, Object?> json) {
    return Brewery(
      name: json['name']! as String,
      breweryType: json['brewery_type']! as String,
      city: json['city']! as String,
      country: json['country']! as String,
    );
  }

  final String name;
  final String breweryType;
  final String city;
  final String country;
}
/* SNIPPET END */
