import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

String refNameFor(ProviderDeclaration provider) => 'Ref';

String classNameFor(ProviderDeclaration provider) {
  return provider.name.lexeme.titled;
}

String generatedClassNameFor(ProviderDeclaration provider) {
  return '_\$${provider.name.lexeme.titled.public}';
}
