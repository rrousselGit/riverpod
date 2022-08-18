import '../models.dart';

class NotifierTemplate {
  NotifierTemplate(this.data);

  final Data data;

  @override
  String toString() {
    return '''
abstract class ${data.notifierBaseName} extends NotifierBase<${data.valueDisplayType}> {
${data.parameters.map((e) => 'late final ${e.type.getDisplayString(withNullability: true)} ${e.name};').join()}

  ${data.valueDisplayType} build(${data.paramDefinition});
}
''';
  }
}
