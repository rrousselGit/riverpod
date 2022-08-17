import 'package:analyzer/dart/element/element.dart';

class Data {
  Data.function({
    required this.rawName,
    required this.functionName,
    required this.providerName,
    required this.refName,
    required this.valueDisplayType,
    required this.isAsync,
    required this.isScoped,
    required this.isFamily,
    required this.parameters,
  }) : notifierName = null;

  Data.notifier({
    required this.rawName,
    required this.notifierName,
    required this.providerName,
    required this.refName,
    required this.valueDisplayType,
    required this.isAsync,
    required this.isScoped,
    required this.isFamily,
    required this.parameters,
  }) : functionName = null;

  final bool isScoped;
  final bool isAsync;
  final bool isFamily;
  final String rawName;
  final String? functionName;
  final String? notifierName;
  final String providerName;
  final String refName;
  final String valueDisplayType;
  final List<ParameterElement> parameters;

  late final String notifierBaseName =
      '_\$${rawName.replaceFirst(RegExp('_*'), '')}';

  late final List<ParameterElement> positionalParameters =
      parameters.where((e) => e.isPositional && e.isRequired).toList();

  late final List<ParameterElement> optionalPositionalParameters =
      parameters.where((e) => e.isPositional && e.isOptional).toList();

  late final List<ParameterElement> namedParameters =
      parameters.where((e) => e.isNamed).toList();

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

  late final familyName = '${providerName}Family';
  late final internalFamilyName = '\$$familyName';
  late final internalProviderTypeName = '\$$providerName';
}

class GlobalData {
  GlobalData();
}
