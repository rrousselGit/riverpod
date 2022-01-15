// ignore_for_file: public_member_api_docs

import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';

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
