import '../models.dart';

class ProviderTemplate {
  ProviderTemplate(this.data);
  final Data data;

  @override
  String toString() {
    if (data.isScoped) {
      if (data.functionName != null) {
        return '''
final ${data.providerName} = Provider<${data.valueDisplayType}>(
  (context) => throw StateError(
    'Tried to read the scoped provider ${data.providerName} '
    'but the provider was not overridden.',
  ),
  name: '${data.providerName}',
);''';
      } else {
        final baseClassName =
            '_\$${data.providerName.replaceFirst(RegExp('_+'), '')}';

        return '''
class $baseClassName extends Notifier<${data.valueDisplayType}> {
  @override
  void build(Ref<${data.valueDisplayType}> ref) {
    throw throw StateError(
      'Tried to read the scoped provider ${data.providerName} '
      'but the provider was not overridden.',
    );
  }
}

final ${data.providerName} = NotifierProvider<${data.notifierName}, ${data.valueDisplayType}>(
  ${data.notifierName}.new,
  name: '${data.providerName}',
);''';
      }
    }

    if (data.functionName != null) {
      return '''
final ${data.providerName} = Provider<${data.valueDisplayType}>(
  ${data.functionName},
  name: '${data.providerName}',
);''';
    } else {
      final baseClassName =
          '_\$${data.providerName.replaceFirst(RegExp('_+'), '')}';

      return '''
typedef $baseClassName = Notifier<${data.valueDisplayType}>;

final ${data.providerName} = NotifierProvider<${data.notifierName}, ${data.valueDisplayType}>(
  ${data.notifierName}.new,
  name: '${data.providerName}',
);''';
    }
  }
}
