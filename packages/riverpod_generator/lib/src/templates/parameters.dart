import 'package:analyzer/dart/element/element.dart';

String buildParamDefinitionQuery(
  List<ParameterElement> parameters, {
  bool asThisParameter = false,
}) {
  final requiredPositionals =
      parameters.where((element) => element.isRequiredPositional);
  final optionalPositionals =
      parameters.where((element) => element.isOptionalPositional).toList();
  final named = parameters.where((element) => element.isNamed).toList();

  final buffer = StringBuffer();
  String encodeParameter(ParameterElement e) {
    final leading = e.isRequiredNamed ? 'required ' : '';
    final trailing =
        e.defaultValueCode != null ? '= ${e.defaultValueCode}' : '';
    if (asThisParameter) return '${leading}this.${e.name}$trailing';
    return '$leading${e.type} ${e.name}$trailing';
  }

  buffer.writeAll(
    requiredPositionals.map(encodeParameter).expand((e) => [e, ',']),
  );
  if (optionalPositionals.isNotEmpty) {
    buffer
      ..write('[')
      ..writeAll(
        optionalPositionals.map(encodeParameter).expand((e) => [e, ',']),
      )
      ..write(']');
  }
  if (named.isNotEmpty) {
    buffer
      ..write('{')
      ..writeAll(named.map(encodeParameter).expand((e) => [e, ',']))
      ..write('}');
  }

  return buffer.toString();
}

String buildParamInvocationQuery(
  Map<ParameterElement, String> parameters, {
  bool asThisParameter = false,
}) {
  final buffer = StringBuffer();

  buffer.writeAll(
    parameters.entries.map((e) {
      if (e.key.isNamed) return '${e.key.name}: ${e.value}';
      return e.value;
    }).expand((e) => [e, ',']),
  );

  return buffer.toString();
}
