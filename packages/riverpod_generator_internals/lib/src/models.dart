import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';

@freezed
class Data with _$Data {
  factory Data() = _Data;
}

@freezed
class GlobalData with _$GlobalData {
  factory GlobalData() = _GlobalData;
}
