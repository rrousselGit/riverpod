import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart' as vm;

class _FakeVmService implements vm.VmService {
  _FakeVmService(this._events);

  final Stream<vm.Event> _events;

  @override
  Stream<vm.Event> get onExtensionEvent => _events;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('decodeAll', () {
    test('decodes values using indexed paths', () {
      final events = <String, VmInstanceRef>{
        'root.length': VmInstanceRef.int(2, id: 'ref-2'),
        'root[0]': VmInstanceRef.string('alpha', id: 'ref-alpha'),
        'root[1]': VmInstanceRef.string('beta', id: 'ref-beta'),
      };

      final result = decodeAll<String>(
        events,
        (map, {required path}) => map[path]!.valueAsString!,
        path: 'root',
      ).toList();

      expect(result, ['alpha', 'beta']);
    });
  });

  group('encodeList', () {
    test('generates code that maps list items by index', () {
      final code = encodeList(
        'myList',
        (name, path) => "{'$path': $name}",
        path: 'root',
      );

      expect(code, contains("'root.length': list.length"));
      expect(code, contains('for (final (index, e) in list.indexed)'));
      expect(code, contains(r"'root[$index]'"));
    });
  });

  group('NotificationService.onNotification', () {
    test(
      'maps recognized extension events to Riverpod notifications',
      () async {
        final extensionData = vm.ExtensionData()..data['offset'] = 7;
        final service = _FakeVmService(
          Stream.value(
            vm.Event(
              kind: vm.EventKind.kExtension,
              extensionKind: 'riverpod:new_event',
              extensionData: extensionData,
            ),
          ),
        );

        final notifications = await service.onNotification.toList();

        expect(notifications, hasLength(1));
        expect(notifications.single.name, 'riverpod:new_event');
        expect(notifications.single.toJson(), {'offset': 7});
      },
    );

    test('ignores unrelated extension events', () async {
      final service = _FakeVmService(
        Stream.fromIterable([
          vm.Event(
            kind: vm.EventKind.kExtension,
            extensionKind: 'not-riverpod',
            extensionData: vm.ExtensionData(),
          ),
          vm.Event(kind: vm.EventKind.kExtension),
        ]),
      );

      expect(await service.onNotification.toList(), isEmpty);
    });
  });
}
