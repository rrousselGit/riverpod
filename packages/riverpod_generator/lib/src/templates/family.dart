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

  static final _allTransitiveDependencies = ${data.transitiveDependencies};
  static final _dependencies = ${data.dependencyString};

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  List<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  String? get name => r'${data.providerName}';
  
  ${data.providerTypeNameImpl} call(${data.paramDefinition}) {
    return ${data.providerTypeNameImpl}(${data.paramInvocationPassAround});
  }

  @override
  ${data.providerTypeDisplayString} getProviderOverride(
    covariant ${data.providerTypeNameImpl} provider,
  ) {
    return call(${data.paramInvocationFromProvider});
  }
}
''';
  }
}
