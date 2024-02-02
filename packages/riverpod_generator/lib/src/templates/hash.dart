import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import 'family_back.dart';
import 'template.dart';

class HashFnTemplate extends Template {
  HashFnTemplate(this.provider);

  final GeneratorProviderDeclaration provider;

  @override
  void run(StringBuffer buffer) {
    buffer.writeln(
      "String ${provider.hashFnName}() => r'${provider.computeProviderHash()}';",
    );
  }
}
