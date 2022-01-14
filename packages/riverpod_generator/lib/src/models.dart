import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

part 'models.freezed.dart';

const freezed = Object();

class JsonKey {
  // ignore: avoid_unused_constructor_parameters
  const JsonKey({bool? ignore});
}

@freezed
class Data with _$Data {
  factory Data({
    required String name,
  }) = _Data;
}

@freezed
class GlobalData with _$GlobalData {
  factory GlobalData() = _GlobalData;
}
