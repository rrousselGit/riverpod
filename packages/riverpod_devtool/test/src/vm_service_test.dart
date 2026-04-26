import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart';

import '../test_helpers.dart';

void main() {
  group('decodeAll', () {
    test('decodes values using indexed paths', () {
      final events = <String, InstanceRef>{
        'root.length': stringRef('2'),
        'root[0]': stringRef('alpha'),
        'root[1]': stringRef('beta'),
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
}
