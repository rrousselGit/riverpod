import 'package:meta/meta.dart';

part 'models.freezed.dart';

const freezed = Object();

@freezed
class Data with _$Data {
  factory Data() = _Data;
}

@freezed
class GlobalData with _$GlobalData {
  factory GlobalData() = _GlobalData;
}
