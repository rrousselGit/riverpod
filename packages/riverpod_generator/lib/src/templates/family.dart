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

  late final _recDeps = ${data.transitiveDependencies};

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => _recDeps;

  static final _deps = ${data.dependencyString};

  @override
  List<ProviderOrFamily>? get dependencies => _deps;

  @override
  String? get name => r'${data.providerName}';
}
''';
  }
}
