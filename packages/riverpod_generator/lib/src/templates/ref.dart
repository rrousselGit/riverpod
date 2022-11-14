import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';

class RefTemplate {
  RefTemplate(this.data);

  final GeneratorProviderDefinition data;

  @override
  String toString() {
    final refName = '${data.name.titled}Ref';

    final refType = data.map(
      functional: (fn) {
        return fn.type.map(
          (_) => 'ProviderRef',
          futureOr: (_) => 'FutureProviderRef',
          future: (_) => 'FutureProviderRef',
        );
      },
      notifier: (notifier) {
        return notifier.type.map(
          (_) => 'NotifierProviderRef',
          futureOr: (_) => 'AsyncNotifierProviderRef',
          future: (_) => 'AsyncNotifierProviderRef',
        );
      },
    );

    return '''
typedef $refName = $refType<${data.type.createdType}>;''';
  }
}
