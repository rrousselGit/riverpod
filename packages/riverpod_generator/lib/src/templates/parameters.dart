import 'package:analyzer/dart/element/element.dart';

String buildParamDefinitionQuery(
  List<ParameterElement> parameters, {
  bool asThisParameter = false,
  bool asSuperParameter = false,
  bool writeBrackets = true,
  bool asRequiredNamed = false,
}) {
  assert(
    !asThisParameter || !asSuperParameter,
    'Cannot enable both asThisParameter and asSuperParameter',
  );

  final requiredPositionals = parameters
      .where((element) => element.isRequiredPositional && !asRequiredNamed)
      .toList();
  final optionalPositionals = parameters
      .where((element) => element.isOptionalPositional && !asRequiredNamed)
      .toList();
  final named = parameters
      .where((element) => element.isNamed || asRequiredNamed)
      .toList();

  final buffer = StringBuffer();
  String encodeParameter(ParameterElement e) {
    final leading = e.isRequiredNamed || asRequiredNamed ? 'required ' : '';
    final trailing = e.defaultValueCode != null && !asRequiredNamed
        ? '= ${e.defaultValueCode}'
        : '';
    if (asThisParameter) return '${leading}this.${e.name}$trailing';
    if (asSuperParameter) return '${leading}super.${e.name}$trailing';
    return '$leading${e.type} ${e.name}$trailing';
  }

  buffer.writeAll(
    requiredPositionals.map(encodeParameter).expand((e) => [e, ',']),
  );
  if (optionalPositionals.isNotEmpty) {
    if (writeBrackets) buffer.write('[');
    buffer.writeAll(
      optionalPositionals.map(encodeParameter).expand((e) => [e, ',']),
    );
    if (writeBrackets) buffer.write(']');
  }
  if (named.isNotEmpty) {
    if (writeBrackets) buffer.write('{');
    buffer.writeAll(named.map(encodeParameter).expand((e) => [e, ',']));
    if (writeBrackets) buffer.write('}');
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
