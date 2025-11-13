import 'package:analyzer/source/source_range.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

SourceRange sourceRangeFrom({required int start, required int end}) {
  return SourceRange(start, end - start);
}

String refNameFor(ProviderDeclaration provider) => 'Ref';

String classNameFor(ProviderDeclaration provider) {
  return provider.name.lexeme.titled;
}

String generatedClassNameFor(ProviderDeclaration provider) {
  return '_\$${provider.name.lexeme.titled.public}';
}
