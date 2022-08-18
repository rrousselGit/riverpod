import '../models.dart';

class NotifierTemplate {
  NotifierTemplate(this.data);

  final Data data;

  @override
  String toString() {
    final buildReturnValueDisplayType = data.isAsync
        ? 'FutureOr<${data.valueDisplayType}>'
        : data.valueDisplayType;

    return '''
abstract class ${data.notifierBaseName} extends ${data.notifierType()} {
${data.parameters.map((e) => 'late final ${e.type.getDisplayString(withNullability: true)} ${e.name};').join()}

  $buildReturnValueDisplayType build(${data.paramDefinition});
}
''';
  }
}
