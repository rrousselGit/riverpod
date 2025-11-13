import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../../../main.dart';
import '../../imports.dart';
import '../../object_utils.dart';

/// Right above "wrap in builder"
const wrapPriority = 30;

class WrapWithConsumer extends ResolvedCorrectionProducer {
  WrapWithConsumer({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  AssistKind get assistKind => const AssistKind(
    'riverpod.wrap_with_consumer',
    wrapPriority,
    'Wrap with Consumer',
  );

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is! NamedType) return;

    final instanceCreationExpr =
        node.ancestors.whereType<InstanceCreationExpression>().firstOrNull;
    if (instanceCreationExpr == null) return;

    await builder.addDartFileEdit(file, (builder) {
      final consumer = builder.importConsumer();

      builder.addSimpleInsertion(
        instanceCreationExpr.offset,
        '$consumer(builder: (context, ref, child) { return ',
      );
      builder.addSimpleInsertion(instanceCreationExpr.end, '; },)');
    });
  }
}
