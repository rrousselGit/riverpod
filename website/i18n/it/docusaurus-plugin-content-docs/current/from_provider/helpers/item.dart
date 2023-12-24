import 'package:freezed_annotation/freezed_annotation.dart';

import 'json.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
class Item with _$Item {
  const factory Item({required int id}) = _Item;
  factory Item.fromJson(Json json) => _$ItemFromJson(json);
}
