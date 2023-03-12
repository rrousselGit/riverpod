import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:collection/collection.dart';
// ignore: implementation_imports, somehow not exported by analyzer
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../object_utils.dart';
import '../riverpod_custom_lint.dart';
import 'convert_to_widget_utils.dart';

const _convertTarget = ConvertToWidget.statefulWidget;

final _statelessBaseType = getStatelessBaseType(
  excludes: [_convertTarget, ConvertToWidget.statelessWidget],
);
final _statefulBaseType = getStatefulBaseType(excludes: [_convertTarget]);

const _stateType = TypeChecker.fromName('State', packageName: 'flutter');

class ConvertToStatefulWidget extends RiverpodAssist {
  ConvertToStatefulWidget();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    context.registry.addExtendsClause((node) {
      // Only offer the assist if hovering the extended type
      if (!node.superclass.sourceRange.intersects(target)) return;

      final type = node.superclass.type;
      if (type == null) return;

      if (_statelessBaseType.isExactlyType(type)) {
        _convertStatelessToStatefulWidget(reporter, node);
        return;
      }

      if (_statefulBaseType.isExactlyType(type)) {
        _convertStatefulToStatefulWidget(reporter, node, resolver.source);
        return;
      }
    });
  }

  void _convertStatelessToStatefulWidget(
    ChangeReporter reporter,
    ExtendsClause node,
  ) {
    final changeBuilder = reporter.createChangeBuilder(
      message: 'Convert to ${_convertTarget.widgetName}',
      priority: _convertTarget.priority,
    );

    changeBuilder.addDartFileEdit((builder) {
      // Change the extended base class
      builder.addSimpleReplacement(
        node.superclass.sourceRange,
        _convertTarget.widgetName,
      );

      final widgetClass = node.thisOrAncestorOfType<ClassDeclaration>();
      if (widgetClass == null) return;

      // Now update "build" to take a "ref" parameter
      final buildMethod = node
          .thisOrAncestorOfType<ClassDeclaration>()
          ?.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((element) => element.name.lexeme == 'build');
      if (buildMethod == null) return;

      final createdStateClassName = '_${widgetClass.name.lexeme.public}State';

      // Split the class into two classes right before the build method
      builder.addSimpleInsertion(buildMethod.offset, '''
@override
  State<${widgetClass.name.lexeme}> createState() => $createdStateClassName();
}

class $createdStateClassName extends State<${widgetClass.name}> {
''');

      final buildParams = buildMethod.parameters;
      // If the build method has a ref, remove it
      if (buildParams != null && buildParams.parameters.length == 2) {
        builder.addDeletion(
          sourceRangeFrom(
            start: buildParams.parameters.first.end,
            end: buildParams.rightParenthesis.offset,
          ),
        );
      }
    });
  }

  void _convertStatefulToStatefulWidget(
    ChangeReporter reporter,
    ExtendsClause node,
    Source source,
  ) {
    final changeBuilder = reporter.createChangeBuilder(
      message: 'Convert to ${_convertTarget.widgetName}',
      priority: _convertTarget.priority,
    );

    changeBuilder.addDartFileEdit((builder) {
      // Change the extended base class
      builder.addSimpleReplacement(
        node.superclass.sourceRange,
        _convertTarget.widgetName,
      );

      final widgetClass = node.thisOrAncestorOfType<ClassDeclaration>();
      if (widgetClass == null) return;

      final stateClass = _findStateClass(widgetClass);
      if (stateClass == null) return;

      final createStateMethod = widgetClass.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((element) => element.name.lexeme == 'createState');
      if (createStateMethod != null) {
        final returnTypeString = createStateMethod.returnType?.toSource() ?? '';
        if (returnTypeString != stateClass.name.lexeme) {
          // Replace ConsumerState<MyWidget> with State<MyWidget>
          builder.addSimpleReplacement(
            createStateMethod.returnType!.sourceRange,
            'State<${widgetClass.name}>',
          );
        }
      }

      final stateExtends = stateClass.extendsClause;
      if (stateExtends != null) {
        // Replace ConsumerState<MyWidget> with State<MyWidget>
        builder.addSimpleReplacement(
          stateExtends.superclass.sourceRange,
          'State<${widgetClass.name}>',
        );
      }
    });
  }

  // TODO: standardization
  ClassDeclaration? _findStateClass(ClassDeclaration widgetClass) {
    final widgetType = widgetClass.declaredElement?.thisType;
    if (widgetType == null) return null;

    return widgetClass
        .thisOrAncestorOfType<CompilationUnit>()
        ?.declarations
        .whereType<ClassDeclaration>()
        .where(
          // Is the class a state class?
          (e) =>
              e.extendsClause?.superclass.type
                  .let(_stateType.isAssignableFromType) ??
              false,
        )
        .firstWhereOrNull((e) {
      final stateWidgetType = e
          .extendsClause?.superclass.typeArguments?.arguments.firstOrNull?.type;
      if (stateWidgetType == null) return false;

      final checker = TypeChecker.fromStatic(widgetType);
      return checker.isExactlyType(stateWidgetType);
    });
  }
}
