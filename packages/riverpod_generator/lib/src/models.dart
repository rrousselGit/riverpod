import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

part 'models.freezed.dart';

const freezed = Object();

class JsonKey {
  // ignore: avoid_unused_constructor_parameters
  const JsonKey({bool? ignore});
}

enum ProviderType {
  stateNotifierProvider,
  provider,
  futureProvider,
  streamProvider,
  changeNotifierProvider,
}

@freezed
class Data with _$Data {
  factory Data({
    required String providerName,
    required String refName,
    required ProviderType providerType,
    required String valueDisplayType,
  }) = _Data;
}

@freezed
class GlobalData with _$GlobalData {
  factory GlobalData() = _GlobalData;
}
