import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';

class NotifierTemplate {
  NotifierTemplate(this.data);

  final GeneratorProviderDefinition data;

  @override
  String toString() {
    return '''
abstract class ${data.notifierBaseName} extends ${data.notifierBaseType()} {
${data.parameters.map((e) => 'late final ${e.type.getDisplayString(withNullability: true)} ${e.name};').join()}

  ${data.parameters.isNotEmpty ? '' : '@override'}
  ${data.buildValueDisplayType} build(${data.paramDefinition});
}
''';
  }
}
