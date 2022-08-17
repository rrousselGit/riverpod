class Data {
  Data.function({
    required this.functionName,
    required this.providerName,
    required this.refName,
    required this.valueDisplayType,
    required this.isAsync,
    required this.isScoped,
  }) : notifierName = null;

  Data.notifier({
    required this.notifierName,
    required this.providerName,
    required this.refName,
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
  final String valueDisplayType;

  String get notifierType {
    assert(functionName != null, 'functions do not have a notifier');
    return isAsync ? 'AsyncNotifier' : 'Notifier';
  }

  String get providerType {
    if (functionName != null) {
      return isAsync ? 'FutureProvider' : 'Provider';
    } else {
      return isAsync ? 'AsyncNotifierProvider' : 'NotifierProvider';
    }
  }

  String get refType => '${providerType}Ref';
}

class GlobalData {
  GlobalData();
}
