import '../models.dart';

class FamilyTemplate {
  FamilyTemplate(this.data);

  final Data data;

  @override
  String toString() {
    return '''
${data.providerDoc}
const ${data.providerName} = ${data.familyName}();

class ${data.familyName} extends Family<${data.exposedValueDisplayType}> {
  const ${data.familyName}();

  ${data.providerTypeNameImpl} call(${data.paramDefinition}) {
    return ${data.providerTypeNameImpl}(${data.paramInvocationPassAround});
  }

  @override
  ${data.providerTypeDisplayString} getProviderOverride(
    covariant ${data.providerTypeNameImpl} provider,
  ) {
    return call(${data.paramInvocationFromProvider});
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies =>
      throw UnimplementedError();

  @override
  int? get disposeDelay => ${data.disposeDelay};

  @override
  int? get cacheTime => ${data.cacheTime};

  @override
  List<ProviderOrFamily>? get dependencies => throw UnimplementedError();

  @override
  String? get name => r'${data.providerName}';
}
''';
  }
}
