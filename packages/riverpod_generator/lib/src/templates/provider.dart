import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';

class ProviderTemplate {
  ProviderTemplate(this.data);
  final GeneratorProviderDefinition data;

  @override
  String toString() {
    if (data.parameters.isNotEmpty) {
      return _familyClass();
    }

    final create = data.isNotifier ? '${data.name}.new' : data.name;

    return '''
${data.docs}
final ${data.providerName} = ${data.providerTypeDisplayString}(
  $create,
  name: r'${data.providerName}',
  debugGetCreateSourceHash: ${data.hashFn},
  dependencies: ${null /* data.dependencyString */},
);''';
  }

  String runNotifierBuild() {
    switch (data.providerType) {
      case ProviderType.provider:
      case ProviderType.futureProvider:
        return '';
      case ProviderType.notifier:
      case ProviderType.asyncNotifier:
        return '''
  @override
  ${data.buildValueDisplayType} runNotifierBuild(
    covariant ${data.notifierBaseName} notifier,
  ) {
    return notifier.build(${data.paramInvocationPassAround});
  }
''';
    }
  }

  String _familyClass() {
    return '''
${data.docs}
class ${data.providerTypeNameImpl} extends ${data.providerTypeDisplayString} {
  ${data.providerTypeNameImpl}(${data.thisParamDefinition}) : super(
          $superConstructor,
          from: ${data.providerName},
          name: r'${data.providerName}',
          debugGetCreateSourceHash: ${data.hashFn},
        );

${data.parameters.map((e) => 'final ${e.type.getDisplayString(withNullability: true)} ${e.name};').join()}

  @override
  bool operator ==(Object other) {
    return ${[
      'other is ${data.providerTypeNameImpl}',
      ...data.parameters.map((e) => 'other.${e.name} == ${e.name}')
    ].join(' && ')};
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
${data.parameters.map((e) => 'hash = _SystemHash.combine(hash, ${e.name}.hashCode);').join()}

    return _SystemHash.finish(hash);
  }

  ${runNotifierBuild()}
}
''';
  }

  String get superConstructor {
    return data.map(
      functional: (data) => '''
(ref) => ${data.name}(ref, ${data.paramInvocationPassAround})
''',
      notifier: (data) => '''
() => ${data.name}()
  ${data.parameters.map((e) => '..${e.name} = ${e.name}').join()}
''',
    );
  }
}
