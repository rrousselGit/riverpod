import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
// ignore: implementation_imports, somehow not exported by analyzer
import 'package:analyzer/src/generated/source.dart' show Source;
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../riverpod_custom_lint.dart';
import 'convert_to_widget_utils.dart';

const _convertTarget = ConvertToWidget.statelessWidget;

final _statelessBaseType = getStatelessBaseType(excludes: [_convertTarget]);
final _statefulBaseType = getStatefulBaseType(
  excludes: [_convertTarget, ConvertToWidget.statefulWidget],
);

class ConvertToStatelessWidget extends RiverpodAssist {
  ConvertToStatelessWidget();

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
        _convertStatelessToStatelessWidget(reporter, node);
        return;
      }

      if (_statefulBaseType.isExactlyType(type)) {
        _convertStatefulToStatelessWidget(reporter, node, resolver.source);
        return;
      }
    });
  }

  void _convertStatelessToStatelessWidget(
    ChangeReporter reporter,
    ExtendsClause node,
  ) {
    final changeBuilder = reporter.createChangeBuilder(
      message: 'Convert to ${_convertTarget.widgetName}',
      priority: _convertTarget.priority,
    );
    // TODO implement
  }

  void _convertStatefulToStatelessWidget(
    ChangeReporter reporter,
    ExtendsClause node,
    Source source,
  ) {
    final changeBuilder = reporter.createChangeBuilder(
      message: 'Convert to ${_convertTarget.widgetName}',
      priority: _convertTarget.priority,
    );
    // TODO implement
  }
}
