import '../models.dart';

class FamilyTemplate {
  FamilyTemplate(this.data);

  final Data data;

  @override
  String toString() {
    final providerType =
        'NotifierProvider<${data.rawName}, ${data.valueDisplayType}>';
    // TODO inject provider doc into the provider
    return '''
const ${data.providerName} = ${data.internalFamilyName}();

// ignore: subtype_of_sealed_class
class ${data.internalFamilyName} extends Family<${data.valueDisplayType}> {
  const ${data.internalFamilyName}();

  $providerType call(${data.paramDefinition}) {
    return ${data.internalProviderTypeName}(${data.paramInvocationPassAround});
  }

  @override
  $providerType getProviderOverride(
    covariant ${data.internalProviderTypeName} provider,
  ) {
    return call(${data.paramInvocationFromProvider});
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies =>
      throw UnimplementedError();

  @override
  Duration? get cacheTime => throw UnimplementedError();

  @override
  List<ProviderOrFamily>? get dependencies => throw UnimplementedError();

  @override
  Duration? get disposeDelay => throw UnimplementedError();

  @override
  String? get name => r'${data.providerName}';
}
''';
  }
}
