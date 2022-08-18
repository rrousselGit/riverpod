import '../models.dart';

class ProviderTemplate {
  ProviderTemplate(this.data);
  final Data data;

  @override
  String toString() {
    if (data.functionName != null) {
      if (data.isFamily) {
        return _familyFunction();
      }
      return data.isScoped ? _scopedFunction() : _function();
    } else {
      if (data.isFamily) {
        return _familyClass();
      }
      return data.isScoped ? _scopedClass() : _class();
    }
  }

  String _familyFunction() {
    // TODO inject provider doc into the provider
    return '''
const ${data.familyName} = ${data.internalFamilyName}();

// ignore: subtype_of_sealed_class
class ${data.internalFamilyName} extends Family<String> {
  const ${data.internalFamilyName}();

  Provider<String> call(${data.paramDefinition}) {
    return ${data.internalFamilyName}(${data.paramInvocationPassAround});
  }

  @override
  ProviderBase<String> getProviderOverride(
    covariant ${data.internalFamilyName} provider,
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

// ignore: subtype_of_sealed_class, invalid_use_of_internal_member
class ${data.internalFamilyName} extends Provider<String> {
  ${data.internalFamilyName}(${data.thisParamDefinition}) : super(
          (ref) => ${data.rawName}(ref, ${data.paramInvocationPassAround}),
          from: ${data.familyName},
        );

${data.parameters.map((e) => 'final ${e.type.getDisplayString(withNullability: true)} ${e.name};').join()}

  @override
  bool operator ==(Object other) {
    return ${[
      'other is ${data.internalFamilyName}',
      ...data.parameters.map((e) => 'other.${e.name} == ${e.name}')
    ].join(' && ')};
  }

  @override
  int get hashCode {
    var hash = SystemHash.combine(0, runtimeType.hashCode);
${data.parameters.map((e) => 'hash = SystemHash.combine(hash, ${e.name}.hashCode);').join()}

    return SystemHash.finish(hash);
  }
}
''';
  }

  String _familyClass() {
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

// ignore: subtype_of_sealed_class, invalid_use_of_internal_member
class ${data.internalProviderTypeName} extends $providerType {
  ${data.internalProviderTypeName}(${data.thisParamDefinition}) : super(
          () => ${data.rawName}()
            ${data.parameters.map((e) => '..${e.name} = ${e.name}').join()},
          from: ${data.providerName},
        );

${data.parameters.map((e) => 'final ${e.type.getDisplayString(withNullability: true)} ${e.name};').join()}

  @override
  bool operator ==(Object other) {
    return ${[
      'other is ${data.internalProviderTypeName}',
      ...data.parameters.map((e) => 'other.${e.name} == ${e.name}')
    ].join(' && ')};
  }

  @override
  int get hashCode {
    var hash = SystemHash.combine(0, runtimeType.hashCode);
${data.parameters.map((e) => 'hash = SystemHash.combine(hash, ${e.name}.hashCode);').join()}

    return SystemHash.finish(hash);
  }

  @override
  ${data.valueDisplayType} runNotifierBuild(
    covariant ${data.notifierBaseName} notifier,
  ) {
    return notifier.build(${data.paramInvocationPassAround});
  }
}

abstract class ${data.notifierBaseName} extends NotifierBase<${data.valueDisplayType}> {
${data.parameters.map((e) => 'late final ${e.type.getDisplayString(withNullability: true)} ${e.name};').join()}

  ${data.valueDisplayType} build(${data.paramDefinition});
}
''';
  }

  String _class() {
    final baseClassName =
        '_\$${data.providerName.replaceFirst(RegExp('_+'), '')}';

    return '''
    typedef $baseClassName = ${data.notifierType}<${data.valueDisplayType}>;
    
    final ${data.providerName} = ${data.providerType}<${data.notifierName}, ${data.valueDisplayType}>(
      ${data.notifierName}.new,
      name: '${data.providerName}',
    );''';
  }

  String _function() {
    return '''
final ${data.providerName} = ${data.providerType}<${data.valueDisplayType}>(
      ${data.functionName},
      name: '${data.providerName}',
    );''';
  }

  String _scopedClass() {
    final baseClassName =
        '_\$${data.providerName.replaceFirst(RegExp('_+'), '')}';

    return '''
    class $baseClassName extends ${data.notifierType}<${data.valueDisplayType}> {
      @override
      void build(Ref<${data.valueDisplayType}> ref) {
        throw throw StateError(
          'Tried to read the scoped provider ${data.providerName} '
          'but the provider was not overridden.',
        );
      }
    }
    
    final ${data.providerName} = ${data.providerType}<${data.notifierName}, ${data.valueDisplayType}>(
      ${data.notifierName}.new,
      name: '${data.providerName}',
    );''';
  }

  String _scopedFunction() {
    return '''
final ${data.providerName} = ${data.providerType}<${data.valueDisplayType}>(
      (context) => throw StateError(
        'Tried to read the scoped provider ${data.providerName} '
        'but the provider was not overridden.',
      ),
      name: '${data.providerName}',
    );''';
  }
}
