import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../../imports.dart';
import 'wrap_with_consumer.dart';

class WrapWithProviderScope extends ResolvedCorrectionProducer {
  WrapWithProviderScope({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  AssistKind get assistKind => const AssistKind(
    'wrap_with_provider_scope',
    wrapPriority - 1,
    'Wrap with ProviderScope',
  );

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is! InstanceCreationExpression) return;

    final createdType = node.constructorName.type.type;
    if (createdType == null || !widgetType.isAssignableFromType(createdType)) {
      return;
    }

    await builder.addDartFileEdit(file, (builder) {
      final providerScope = builder.importProviderScope();
      builder.addSimpleInsertion(node.offset, '$providerScope(child: ');
      builder.addSimpleInsertion(node.end, ',)');
    });
  }
}
