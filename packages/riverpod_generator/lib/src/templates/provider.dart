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

  late final paramDefinition = [
    ...data.positionalParameters.map((e) {
      return '${e.type.getDisplayString(withNullability: true)} ${e.name},';
    }),
    if (data.optionalPositionalParameters.isNotEmpty) ...[
      '[',
      ...data.optionalPositionalParameters.map((e) {
        final defaultValue =
            e.defaultValueCode != null ? '= ${e.defaultValueCode}' : '';

        return '${e.type.getDisplayString(withNullability: true)} ${e.name} $defaultValue,';
      }),
      ']',
    ],
    if (data.namedParameters.isNotEmpty) ...[
      '{',
      ...data.namedParameters.map((e) {
        final defaultValue =
            e.defaultValueCode != null ? '= ${e.defaultValueCode}' : '';

        final leading = e.isRequired ? 'required' : '';

        return '$leading ${e.type.getDisplayString(withNullability: true)} ${e.name} $defaultValue,';
      }),
      '}',
    ],
  ].join();

  late final thisParamDefinition = [
    ...data.positionalParameters.map((e) {
      return 'this.${e.name},';
    }),
    if (data.optionalPositionalParameters.isNotEmpty) ...[
      '[',
      ...data.optionalPositionalParameters.map((e) {
        final defaultValue =
            e.defaultValueCode != null ? '= ${e.defaultValueCode}' : '';

        return 'this.${e.name} $defaultValue,';
      }),
      ']',
    ],
    if (data.namedParameters.isNotEmpty) ...[
      '{',
      ...data.namedParameters.map((e) {
        final defaultValue =
            e.defaultValueCode != null ? '= ${e.defaultValueCode}' : '';

        final leading = e.isRequired ? 'required' : '';

        return '$leading this.${e.name} $defaultValue,';
      }),
      '}',
    ],
  ].join();

  late final paramInvocationPassAround = data.parameters.map((e) {
    if (e.isNamed) {
      return '${e.name}: ${e.name},';
    }
    return '${e.name},';
  }).join();

  late final paramInvocationFromProvider = data.parameters.map((e) {
    if (e.isNamed) {
      return '${e.name}: provider.${e.name},';
    }
    return 'provider.${e.name},';
  }).join();

  String _familyFunction() {
    // TODO inject provider doc into the provider
    return '''
const ${data.familyName} = ${data.internalFamilyName}();

// ignore: subtype_of_sealed_class
class ${data.internalFamilyName} extends Family<String> {
  const ${data.internalFamilyName}();

  Provider<String> call($paramDefinition) {
    return ${data.internalFamilyName}($paramInvocationPassAround);
  }

  @override
  ProviderBase<String> getProviderOverride(
    covariant ${data.internalFamilyName} provider,
  ) {
    return call($paramInvocationFromProvider);
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
  ${data.internalFamilyName}($thisParamDefinition) : super(
          (ref) => ${data.rawName}(ref, $paramInvocationPassAround),
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
    // TODO inject provider doc into the provider
    return '''
const ${data.providerName} = ${data.internalFamilyName}();

// ignore: subtype_of_sealed_class
class ${data.internalFamilyName} extends Family<String> {
  const ${data.internalFamilyName}();

  Provider<String> call($paramDefinition) {
    return ${data.internalProviderTypeName}($paramInvocationPassAround);
  }

  @override
  NotifierProvider<String> getProviderOverride(
    covariant ${data.rawName} provider,
  ) {
    return call($paramInvocationFromProvider);
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
class ${data.internalProviderTypeName} extends NotifierProvider<${data.rawName}, String> {
  ${data.internalProviderTypeName}($thisParamDefinition) : super(
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

  String _runNotifierBuild(
    covariant ${data.notifierBaseName} notifier,
  ) {
    return notifier.build($paramInvocationPassAround);
  }
}

abstract class ${data.notifierBaseName} extends NotifierBase<String> {
  late final int first;
  late final String? second;
  late final double third;
  late final bool forth;
  late final List<String>? fifth;

  String build(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  });
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
