enum ProviderType {
  stateNotifierProvider,
  provider,
  futureProvider,
  streamProvider,
  changeNotifierProvider,
}

class Data {
  Data.function({
    required this.functionName,
    required this.providerName,
    required this.refName,
    required this.providerType,
    required this.valueDisplayType,
    required this.isAsync,
    required this.isScoped,
  }) : notifierName = null;

  Data.notifier({
    required this.notifierName,
    required this.providerName,
    required this.refName,
    required this.providerType,
    required this.valueDisplayType,
    required this.isAsync,
    required this.isScoped,
  }) : functionName = null;

  final bool isScoped;
  final bool isAsync;
  final String? functionName;
  final String? notifierName;
  final String providerName;
  final String refName;
  final ProviderType providerType;
  final String valueDisplayType;
}

class GlobalData {
  GlobalData();
}
