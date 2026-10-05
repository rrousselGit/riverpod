import 'package:devtools_app_shared/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_devtool/src/state_inspector/inspector.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart' as vm;

import '../../widget_test_helpers.dart';

class _Session extends DevtoolSessionNotifier {
  @override
  Future<String> build() async => 'session';
}

class _EvalFactory implements EvalFactory {
  _EvalFactory(Map<String, Byte<VmInstanceRef>> roots) {
    dartCore = _Eval(this, roots);
  }

  @override
  late final Eval dartCore;

  @override
  RiverpodEval get riverpodFramework => RiverpodEval(dartCore);

  @override
  String? sessionId = 'session';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Eval implements Eval {
  _Eval(this.factory, this.roots);

  @override
  final EvalFactory factory;
  final Map<String, Byte<VmInstanceRef>> roots;

  @override
  Future<Byte<VmInstanceRef>> eval(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) async {
    final id = RegExp(r'getCache\("(.*)"\)').firstMatch(code)!.group(1)!;
    return roots[id]!;
  }

  @override
  Future<Byte<VmInstance>> instance(
    VmInstanceRef ref, {
    required Disposable isAlive,
  }) async => ByteVariable(ref.requireInstance);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

VmInstance _record(String id, Map<String, VmInstance> fields) => VmInstance(
  vm.Instance(
    id: id,
    kind: vm.InstanceKind.kRecord,
    fields: [
      for (final entry in fields.entries)
        vm.BoundField(name: entry.key, value: entry.value.ref.raw),
    ],
  ),
);

VmInstance _list(String id, List<VmInstance> elements) => VmInstance(
  vm.Instance(
    id: id,
    kind: vm.InstanceKind.kList,
    elements: [for (final element in elements) element.ref.raw],
  ),
);

Future<void> _show(
  WidgetTester tester,
  _EvalFactory factory,
  Widget child,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        evalProvider.overrideWith((ref) => Future.value(factory)),
        devtoolSessionProvider.overrideWith(_Session.new),
      ],
      child: testApp(child),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('keeps matching paths open across frames and shape changes', (
    tester,
  ) async {
    VmInstance frame(String id, int value, {bool reversed = false}) {
      final fields = {
        'opened': _list('$id-opened', [
          _record('$id-detail', {'value': VmInstance.int(value)}),
        ]),
        'closed': _list('$id-closed', [VmInstance.string('hidden')]),
      };
      return _record(
        id,
        reversed ? Map.fromEntries(fields.entries.toList().reversed) : fields,
      );
    }

    final factory = _EvalFactory({
      'first': ByteVariable(frame('first', 1).ref),
      'second': ByteVariable(frame('second', 2, reversed: true).ref),
      'empty': ByteVariable(
        _record('empty', {'opened': _list('short', [])}).ref,
      ),
    });
    Future<void> show(String id) => _show(
      tester,
      factory,
      Inspector(object: RootCachedObject(CacheId(id))),
    );

    await show('first');
    await tester.tap(find.text('Record'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('opened: '));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Record').last);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('"hidden"'), findsNothing);

    await show('second');
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    expect(find.text('"hidden"'), findsNothing);

    await show('empty');
    expect(find.text('Record'), findsOneWidget);
    expect(find.text('opened: '), findsOneWidget);
    expect(tester.takeException(), isNull);

    await show('first');
    expect(find.text('1'), findsOneWidget);
    await tester.tap(find.text('Record').last);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsNothing);
    await show('second');
    expect(find.text('2'), findsNothing);
    expect(find.text('opened: '), findsOneWidget);
  });

  testWidgets('keeps multiline strings expanded when their values change', (
    tester,
  ) async {
    final factory = _EvalFactory({
      'first': ByteVariable(VmInstance.string('first\nline').ref),
      'second': ByteVariable(VmInstance.string('second\nline').ref),
    });
    Future<void> show(String id) => _show(
      tester,
      factory,
      Inspector(object: RootCachedObject(CacheId(id))),
    );

    await show('first');
    await tester.tap(find.text(r'"first\nline"'));
    await tester.pumpAndSettle();
    expect(find.text('"first\nline"'), findsOneWidget);
    await show('second');
    expect(find.text('"second\nline"'), findsOneWidget);
    expect(tester.widget<Text>(find.text('"second\nline"')).maxLines, isNull);
  });

  testWidgets('keeps multiline errors expanded across frames', (tester) async {
    final factory = _EvalFactory({
      'first': ByteError(UnknownEvalErrorType('first\nerror')),
      'second': ByteError(UnknownEvalErrorType('second\nerror')),
    });
    Future<void> show(String id) => _show(
      tester,
      factory,
      Inspector(object: RootCachedObject(CacheId(id))),
    );

    await show('first');
    await tester.tap(
      find.text(r'UnknownEvalError: first\nerror', findRichText: true),
    );
    await tester.pumpAndSettle();
    await show('second');
    expect(
      find.text('UnknownEvalError: second\nerror', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('expansion is local to an inspector and expires on disposal', (
    tester,
  ) async {
    final factory = _EvalFactory({
      'left': ByteVariable(_list('left', [VmInstance.int(1)]).ref),
      'right': ByteVariable(_list('right', [VmInstance.int(2)]).ref),
    });
    Future<void> show({bool mounted = true}) => _show(
      tester,
      factory,
      mounted
          ? Row(
              children: [
                for (final id in ['left', 'right'])
                  Expanded(
                    child: Inspector(
                      key: ValueKey(id),
                      object: RootCachedObject(CacheId(id), label: id),
                    ),
                  ),
              ],
            )
          : const SizedBox(),
    );

    await show();
    await tester.tap(find.text('left: '));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsNothing);
    await show();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsNothing);
    await show(mounted: false);
    await show();
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsNothing);
  });
}
