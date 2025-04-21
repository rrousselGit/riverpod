import 'package:analyzer/dart/ast/ast.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../models.dart';
import '../riverpod_generator.dart';
import 'template.dart';

extension MutationX on Mutation {
  String get elementFieldName => '_\$${name.lowerFirst}';
  String get generatedMutationInterfaceName =>
      '${(node.parent! as ClassDeclaration).name}\$${name.titled}';
  String get generatedMutationImplName =>
      '_\$${(node.parent! as ClassDeclaration).name}\$${name.titled}';
}

class ElementTemplate extends Template {
  ElementTemplate(this.provider);

  final ClassBasedProviderDeclaration provider;
  late final _generics = provider.generics();
  late final _genericsDefinition = provider.genericsDefinition();

  @override
  void run(StringBuffer buffer) {
    if (provider.mutations.isEmpty) return;

    buffer.write('''
class ${provider.generatedElementName}$_genericsDefinition extends ${provider.internalElementName}<${provider.name}$_generics, ${provider.valueTypeDisplayString}> {
  ${provider.generatedElementName}(super.pointer) {
''');

    _constructorBody(buffer);
    buffer.writeln('}');

    _fields(buffer);
    _overrideMount(buffer);
    _overrideVisitChildren(buffer);

    buffer.writeln('}');
  }

  void _constructorBody(StringBuffer buffer) {
    for (final mutation in provider.mutations) {
      buffer.writeln(
        '    ${mutation.elementFieldName}.result = \$Result.data(${mutation.generatedMutationImplName}(this));',
      );
    }
  }

  void _overrideVisitChildren(StringBuffer buffer) {
    buffer.writeln(r'''
  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);
''');

    for (final mutation in provider.mutations) {
      buffer.writeln('    listenableVisitor(${mutation.elementFieldName});');
    }

    buffer.write('''
      }
    ''');
  }

  void _fields(StringBuffer buffer) {
    for (final mutation in provider.mutations) {
      buffer.writeln(
        '  final ${mutation.elementFieldName} = \$ElementLense<${mutation.generatedMutationImplName}>();',
      );
    }
  }

  void _overrideMount(StringBuffer buffer) {
    buffer.write('''
  @override
  void mount() {
    super.mount();
''');
    for (final mutation in provider.mutations) {
      buffer.writeln(
        '    ${mutation.elementFieldName}.result!.value!.reset();',
      );
    }
    buffer.writeln('''
      }''');
  }
}
