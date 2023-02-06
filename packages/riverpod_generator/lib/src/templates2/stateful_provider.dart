import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import '../riverpod_generator2.dart';
import 'template.dart';

class StatefulProviderTemplate extends Template {
  StatefulProviderTemplate(
    this.provider, {
    required this.providerName,
    required this.notifierTypedefName,
    required this.hashFn,
  }) {
    if (provider.buildMethod.parameters!.parameters.isNotEmpty) {
      throw ArgumentError.value(
        provider.buildMethod.parameters?.toSource(),
        'provider',
        'Expected a stateful provider with no parameter',
      );
    }
  }
  final StatefulProviderDeclaration provider;
  final String providerName;
  final String notifierTypedefName;
  final String hashFn;

  @override
  void run(StringBuffer buffer) {
    String notifierBaseType;
    String providerType;
    var leading = '';
    if (!provider.annotation.element.keepAlive) {
      leading = 'AutoDispose';
    }

    final returnType = provider.buildMethod.returnType?.type;
    if ((returnType?.isDartAsyncFutureOr ?? false) ||
        (returnType?.isDartAsyncFuture ?? false)) {
      notifierBaseType = '${leading}AsyncNotifier';
      providerType = '${leading}AsyncNotifierProvider';
    } else {
      notifierBaseType = '${leading}Notifier';
      providerType = '${leading}NotifierProvider';
    }

    buffer.write('''
${providerDocFor(provider.providerElement.element)}
@ProviderFor(${provider.name})
final $providerName = $providerType<${provider.name}, ${provider.valueType}>(
  ${provider.providerElement.name}.new,
  name: r'$providerName',
  debugGetCreateSourceHash: $hashFn,
);

typedef $notifierTypedefName = $notifierBaseType<${provider.valueType}>;
''');
  }
}
