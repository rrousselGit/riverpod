import 'package:test/test.dart';
import 'package:riverpod_lint/src/assists/wrap_with_consumer.dart';
import 'package:riverpod_lint/src/assists/wrap_with_provider_scope.dart';

import '../../golden.dart';

void main() {
  testGolden(
    'Wrap with consumer',
    'assists/wrap_widget/wrap_with_consumer.diff',
    sourcePath: 'test/assists/wrap_widget/wrap_widget.dart',
    (result, helper) async {
      final assist = WrapWithConsumer();

      final cursors = helper.rangesForString('''
  Widget build(BuildContext context) {
    Ma<>p();

    return Scaf<>fold(
      body: Conta<>iner(<>),
    );
''');

      final changes = await helper.runAssist(assist, result, cursors);

      expect(changes, hasLength(2));

      return changes;
    },
  );

  testGolden(
    'Wrap with ProviderScope',
    'assists/wrap_widget/wrap_with_provider_scope.diff',
    sourcePath: 'test/assists/wrap_widget/wrap_widget.dart',
    (result, helper) async {
      final assist = WrapWithProviderScope();

      final cursors = helper.rangesForString('''
  Widget build(BuildContext context) {
    Ma<>p();

    return Scaf<>fold(
      body: Conta<>iner(<>),
    );
''');

      final changes = await helper.runAssist(assist, result, cursors);

      expect(changes, hasLength(2));

      return changes;
    },
  );
}
