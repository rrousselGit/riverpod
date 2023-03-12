import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/generated/source.dart';
// ignore: implementation_imports, somehow not exported by analyzer
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';
import 'convert_to_widget_utils.dart';

const _convertTarget = ConvertToWidget.statefulWidget;

final _statelessBaseType = getStatelessBaseType(
  excludes: [_convertTarget, ConvertToWidget.statelessWidget],
);
final _statefulBaseType = getStatefulBaseType(excludes: [_convertTarget]);

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
  }
}
