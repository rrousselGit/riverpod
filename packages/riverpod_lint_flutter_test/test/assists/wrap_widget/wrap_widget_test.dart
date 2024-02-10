import 'package:test/test.dart';
import 'package:riverpod_lint/src/assists/wrap_with_consumer.dart';
import 'package:riverpod_lint/src/assists/wrap_with_provider_scope.dart';
import 'package:analyzer/source/source_range.dart';

import '../../golden.dart';

void main() {
  testGolden(
    'Wrap with consumer',
    'assists/wrap_widget/wrap_with_consumer.diff',
    sourcePath: 'test/assists/wrap_widget/wrap_widget.dart',
    (result) async {
      final assist = WrapWithConsumer();

      var changes = [
        // Map
        ...await assist.testRun(result, const SourceRange(224, 0)),

        // Scaffold
        ...await assist.testRun(result, const SourceRange(245, 0)),

        // Container
        ...await assist.testRun(result, const SourceRange(268, 0)),

        // Between ()
        ...await assist.testRun(result, const SourceRange(273, 0)),
      ];

      expect(changes, hasLength(2));

      return changes;
    },
  );

  testGolden(
    'Wrap with ProviderScope',
    'assists/wrap_widget/wrap_with_provider_scope.diff',
    sourcePath: 'test/assists/wrap_widget/wrap_widget.dart',
    (result) async {
      final assist = WrapWithProviderScope();

      final changes = [
        // Map
        ...await assist.testRun(result, const SourceRange(224, 0)),

        // Scaffold
        ...await assist.testRun(result, const SourceRange(245, 0)),

        // Container
        ...await assist.testRun(result, const SourceRange(268, 0)),

        // Between ()
        ...await assist.testRun(result, const SourceRange(273, 0)),
      ];

      expect(changes, hasLength(2));

      return changes;
    },
  );
}
