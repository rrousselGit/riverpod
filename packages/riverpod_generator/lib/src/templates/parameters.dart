import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_buffer/analyzer_buffer.dart';
import 'package:source_gen/source_gen.dart';

String buildParamDefinitionQuery(
  List<FormalParameter> parameters, {
  bool asThisParameter = false,
  bool asSuperParameter = false,
  bool writeBrackets = true,
  bool asRequiredNamed = false,
  bool asRecord = false,
  bool withDefaults = true,
}) {
  assert(
    !asThisParameter || !asSuperParameter,
    'Cannot enable both asThisParameter and asSuperParameter',
  );

  final requiredPositional =
      parameters
          .where((element) => element.isRequiredPositional && !asRequiredNamed)
          .toList();
  final optionalPositional =
      parameters
          .where((element) => element.isOptionalPositional && !asRequiredNamed)
          .toList();
  final named =
      parameters
          .where((element) => element.isNamed || asRequiredNamed)
          .toList();

  final buffer = StringBuffer();

  String encodeParameter(FormalParameter parameter) {
    if (asRecord) {
      final type =
          parameter.typeDisplayString.isEmpty
              ? 'dynamic'
              : parameter.typeDisplayString;
      if (parameter.isNamed) {
        return '$type ${parameter.name}';
      }
      return type;
    }

    late final metadata =
        parameter.metadata.isNotEmpty
            ? '${parameter.metadata.map((e) => e.toSource()).join(' ')} '
            : '';

    late final element = parameter.declaredFragment!.element;
    late final leading =
        parameter.isRequiredNamed || asRequiredNamed
            ? 'required $metadata'
            : metadata;
    late final constant = element.computeConstantValue();
    late final trailing =
        element.hasDefaultValue &&
                constant != null &&
                !asRequiredNamed &&
                withDefaults
            ? '= ${constant.toCode()}'
            : '';
    if (asThisParameter) return '${leading}this.${parameter.name}$trailing';
    if (asSuperParameter) return '${leading}super.${parameter.name}$trailing';

    return '$leading${parameter.typeDisplayString} ${parameter.name}$trailing';
  }

  buffer.writeAll(
    requiredPositional.map(encodeParameter).expand((e) => [e, ',']),
  );
  if (optionalPositional.isNotEmpty) {
    if (writeBrackets && !asRecord) buffer.write('[');
    buffer.writeAll(
      optionalPositional.map(encodeParameter).expand((e) => [e, ',']),
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
    parameters.entries
        .map((e) {
          if (e.key.isNamed) return '${e.key.name}: ${e.value}';
          return e.value;
        })
        .expand((e) => [e, ',']),
  );

  return buffer.toString();
}

extension ParameterType on FormalParameter {
  String get typeDisplayString {
    final that = this;
    switch (that) {
      case DefaultFormalParameter():
        return that.parameter.typeDisplayString;
      case SimpleFormalParameter():
        try {
          // No type, so let's just return 'dynamic'
          return that.type?.type?.toCode() ?? 'dynamic';
        } on InvalidTypeException catch (e, stackTrace) {
          Error.throwWithStackTrace(
            InvalidGenerationSource('Invalid type found', node: this),
            stackTrace,
          );
        }
      case FieldFormalParameter():
      case FunctionTypedFormalParameter():
      case SuperFormalParameter():
        throw UnsupportedError(
          'Only parameters of the form "Type name" are supported',
        );
    }
  }
}
