import '../models.dart';

class FamilyTemplate {
  FamilyTemplate(this.data);

  final Data data;

  @override
  String toString() {
    return '''
${data.providerDoc}
final ${data.providerName} = ${data.familyName}();

class ${data.familyName} extends Family<${data.exposedValueDisplayType}> {
  ${data.familyName}();

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
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'${data.providerName}';
}
''';
  }
}
