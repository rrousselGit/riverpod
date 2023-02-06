import '../models.dart';

class ProviderTemplate {
  ProviderTemplate(this.data);
  final Data data;

  @override
  String toString() {
    if (data.isFamily) {
      return _familyClass();
    }

    String create() {
      if (data.isNotifier) return '${data.rawName}.new';
      return data.rawName;
    }

    return '''
${data.providerDoc}
${data.providerForAnnotation}
final ${data.providerName} = ${data.providerTypeDisplayString}(
  ${create()},
  name: r'${data.providerName}',
  debugGetCreateSourceHash: ${data.hashFn},
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
${data.providerDoc}
${data.providerForAnnotation}
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
    switch (data.providerType) {
      case ProviderType.futureProvider:
      case ProviderType.provider:
        return '''
(ref) => ${data.rawName}(ref, ${data.paramInvocationPassAround})
''';

      case ProviderType.asyncNotifier:
      case ProviderType.notifier:
        return '''
() => ${data.rawName}()
  ${data.parameters.map((e) => '..${e.name} = ${e.name}').join()}
''';
    }
  }
}
