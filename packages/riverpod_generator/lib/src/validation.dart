import 'package:collection/collection.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:source_gen/source_gen.dart';

void validateClassBasedProvider(ClassBasedProviderDeclaration provider) {
  // Assert that the class is not abstract
  if (provider.node.abstractKeyword != null) {
    throw InvalidGenerationSourceError(
      '`@riverpod` can only be used on concrete classes.',
      element: provider.node.declaredElement,
    );
  }

  // Assert that the provider has a default constructor
  final constructor = provider.node.declaredElement!.constructors
      .firstWhereOrNull((e) => e.isDefaultConstructor);
  if (constructor == null) {
    throw InvalidGenerationSourceError(
      'The class ${provider.node.name} must have a default constructor.',
      element: provider.node.declaredElement,
    );
  }

  // Assert that the default constructor can be called with no parameter
  if (constructor.parameters.any((e) => e.isRequired)) {
    throw InvalidGenerationSourceError(
      'The default constructor of ${provider.node.name} must have not have required parameters.',
      element: constructor,
    );
  }
}
