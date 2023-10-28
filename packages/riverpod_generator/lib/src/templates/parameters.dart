import 'package:analyzer/dart/ast/ast.dart';

String buildParamDefinitionQuery(
  List<FormalParameter> parameters, {
  bool asThisParameter = false,
  bool asSuperParameter = false,
  bool writeBrackets = true,
  bool asRequiredNamed = false,
  bool asRecord = false,
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
  String encodeParameter(FormalParameter parameter) {
    if (asRecord) {
      final type = parameter.typeDisplayString.isEmpty
          ? 'dynamic'
          : parameter.typeDisplayString;
      if (parameter.isNamed) {
        return '$type ${parameter.name}';
      }
      return type;
    }

    late final element = parameter.declaredElement!;
    late final leading =
        parameter.isRequiredNamed || asRequiredNamed ? 'required ' : '';
    late final trailing = element.defaultValueCode != null && !asRequiredNamed
        ? '= ${element.defaultValueCode}'
        : '';
    if (asThisParameter) return '${leading}this.${parameter.name}$trailing';
    if (asSuperParameter) return '${leading}super.${parameter.name}$trailing';

    return '$leading${parameter.typeDisplayString} ${parameter.name}$trailing';
  }

  buffer.writeAll(
    requiredPositionals.map(encodeParameter).expand((e) => [e, ',']),
  );
  if (optionalPositionals.isNotEmpty) {
    if (writeBrackets && !asRecord) buffer.write('[');
    buffer.writeAll(
      optionalPositionals.map(encodeParameter).expand((e) => [e, ',']),
    );
    if (writeBrackets && !asRecord) buffer.write(']');
  }
  if (named.isNotEmpty) {
    if (writeBrackets) buffer.write('{');
    buffer.writeAll(named.map(encodeParameter).expand((e) => [e, ',']));
    if (writeBrackets) buffer.write('}');
  }

  return buffer.toString();
}

String buildParamInvocationQuery(
  Map<FormalParameter, String> parameters, {
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

extension ParamterType on FormalParameter {
  String get typeDisplayString {
    final that = this;
    switch (that) {
      case DefaultFormalParameter():
        return that.parameter.typeDisplayString;
      case SimpleFormalParameter():
        // No type, so let's just return ''
        return that.type?.toSource() ?? '';
      case FieldFormalParameter():
      case FunctionTypedFormalParameter():
      case SuperFormalParameter():
        throw UnsupportedError(
          'Only parameters of the form "Type name" are supported',
        );
    }
  }
}
