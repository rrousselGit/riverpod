import '../models.dart';

class ProviderTemplate {
  ProviderTemplate(this.data);
  final Data data;

  @override
  String toString() {
    if (data.functionName != null) {
      return data.isScoped ? _scopedFunction() : _function();
    } else {
      return data.isScoped ? _scopedClass() : _class();
    }
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
