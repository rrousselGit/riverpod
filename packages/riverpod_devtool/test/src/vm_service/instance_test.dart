import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart' as vm;

void main() {
  group('ResolvedVariable.fromInstance', () {
    test('maps primitive instance kinds to specialized variable types', () {
      expect(
        ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('string')),
          VmInstance.string('hello'),
        ),
        isA<StringVariable>().having((it) => it.value, 'value', 'hello'),
      );

      expect(
        ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('int')),
          VmInstance.int(42),
        ),
        isA<IntVariable>().having((it) => it.value, 'value', 42),
      );

      expect(
        ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('double')),
          VmInstance.double(3.14),
        ),
        isA<DoubleVariable>().having((it) => it.value, 'value', 3.14),
      );

      expect(
        ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('bool')),
          VmInstance.bool(value: true),
        ),
        isA<BoolVariable>().having((it) => it.value, 'value', isTrue),
      );

      expect(
        ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('null')),
          VmInstance.null_(),
        ),
        isA<NullVariable>(),
      );

      expect(
        ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('type')),
          VmInstance.type('MyType'),
        ),
        isA<TypeVariable>().having((it) => it.name, 'name', 'MyType'),
      );
    });

    test(
      'builds derived children for records, collections, maps, and objects',
      () {
        final childRef = VmInstanceRef.string('child', id: 'child');
        final object = RootCachedObject(CacheId('root'));

        final record = ResolvedVariable.fromInstance(
          object,
          VmInstance(
            vm.Instance(
              id: 'record',
              kind: vm.InstanceKind.kRecord,
              fields: [
                vm.BoundField(name: 0, value: childRef),
                vm.BoundField(name: 'label', value: childRef),
              ],
            ),
          ),
        )!;
        expect(record, isA<RecordVariable>());
        expect(record.children, hasLength(2));
        expect(record.children.first.label, isNull);
        expect(record.children.last.label, 'label');

        final list = ResolvedVariable.fromInstance(
          object,
          VmInstance(
            vm.Instance(
              id: 'list',
              kind: vm.InstanceKind.kList,
              elements: [childRef, childRef],
            ),
          ),
        )!;
        expect(list, isA<ListVariable>());
        expect(list.children, hasLength(2));

        final set = ResolvedVariable.fromInstance(
          object,
          VmInstance(
            vm.Instance(
              id: 'set',
              kind: vm.InstanceKind.kSet,
              elements: [childRef],
            ),
          ),
        )!;
        expect(set, isA<SetVariable>());
        expect(set.children, hasLength(1));

        final map = ResolvedVariable.fromInstance(
          object,
          VmInstance(
            vm.Instance(
              id: 'map',
              kind: vm.InstanceKind.kMap,
              associations: [vm.MapAssociation(key: childRef, value: childRef)],
            ),
          ),
        )!;
        expect(map, isA<MapVariable>());
        expect(map.children, hasLength(2));
        expect(map.children.first.label, 'key');
        expect(map.children.last.label, 'value');
      },
    );

    test('throws on unknown instance kinds', () {
      expect(
        () => ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('unknown')),
          VmInstance.unknownKind('kUnknownKind'),
        ),
        throwsArgumentError,
      );
    });
  });

  group('FieldKey', () {
    test('creates named and positional keys from supported values', () {
      expect(FieldKey.from('name'), NamedFieldKey('name'));
      expect(FieldKey.from(2), PositionalFieldKey(2));
    });

    test('throws on unsupported field names', () {
      expect(() => FieldKey.from(3.14), throwsStateError);
    });
  });
}
