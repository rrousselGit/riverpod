import 'package:freezed_annotation/freezed_annotation.dart';

part 'codegen.g.dart';
part 'codegen.freezed.dart';

/* SNIPPET START */
@freezed
sealed class Brewery with _$Brewery {
  factory Brewery({
    required String name,
    @JsonKey(name: 'brewery_type') required String breweryType,
    required String city,
    required String country,
  }) = _Brewery;

  factory Brewery.fromJson(Map<String, dynamic> json) =>
      _$BreweryFromJson(json);
}
/* SNIPPET END */
