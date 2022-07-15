enum ProviderType {
  stateNotifierProvider,
  provider,
  futureProvider,
  streamProvider,
  changeNotifierProvider,
}

class Data {
  Data({
    required this.providerName,
    required this.refName,
    required this.providerType,
    required this.valueDisplayType,
  });

  final String providerName;
  final String refName;
  final ProviderType providerType;
  final String valueDisplayType;
}

class GlobalData {
  GlobalData();
}
