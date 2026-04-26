import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart' as vm;

void main() {
  group('ResolvedVariable.fromInstance', () {
    test('maps primitive instance kinds to specialized variable types', () {
      expect(
        ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('string')),
          vm.Instance(
            id: 'string',
            kind: vm.InstanceKind.kString,
            valueAsString: 'hello',
          ),
        ),
        isA<StringVariable>().having((it) => it.value, 'value', 'hello'),
      );

      expect(
        ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('int')),
          vm.Instance(
            id: 'int',
            kind: vm.InstanceKind.kInt,
            valueAsString: '42',
          ),
        ),
        isA<IntVariable>().having((it) => it.value, 'value', 42),
      );

      expect(
        ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('double')),
          vm.Instance(
            id: 'double',
            kind: vm.InstanceKind.kDouble,
            valueAsString: '3.14',
          ),
        ),
        isA<DoubleVariable>().having((it) => it.value, 'value', 3.14),
      );

      expect(
        ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('bool')),
          vm.Instance(
            id: 'bool',
            kind: vm.InstanceKind.kBool,
            valueAsString: 'true',
          ),
        ),
        isA<BoolVariable>().having((it) => it.value, 'value', isTrue),
      );

      expect(
        ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('null')),
          vm.Instance(id: 'null', kind: vm.InstanceKind.kNull),
        ),
        isA<NullVariable>(),
      );

      expect(
        ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('type')),
          vm.Instance(id: 'type', kind: vm.InstanceKind.kType, name: 'MyType'),
        ),
        isA<TypeVariable>().having((it) => it.name, 'name', 'MyType'),
      );
    });

    test(
      'builds derived children for records, collections, maps, and objects',
      () {
        final childRef = vm.InstanceRef(
          id: 'child',
          kind: vm.InstanceKind.kString,
          valueAsString: 'child',
        );
        final object = RootCachedObject(CacheId('root'));

        final record = ResolvedVariable.fromInstance(
          object,
          vm.Instance(
            id: 'record',
            kind: vm.InstanceKind.kRecord,
            fields: [
              vm.BoundField(name: 0, value: childRef),
              vm.BoundField(name: 'label', value: childRef),
            ],
          ),
        );
        expect(record, isA<RecordVariable>());
        expect(record.children, hasLength(2));
        expect(record.children.first.label, isNull);
        expect(record.children.last.label, 'label');

        final list = ResolvedVariable.fromInstance(
          object,
          vm.Instance(
            id: 'list',
            kind: vm.InstanceKind.kList,
            elements: [childRef, childRef],
          ),
        );
        expect(list, isA<ListVariable>());
        expect(list.children, hasLength(2));

        final set = ResolvedVariable.fromInstance(
          object,
          vm.Instance(
            id: 'set',
            kind: vm.InstanceKind.kSet,
            elements: [childRef],
          ),
        );
        expect(set, isA<SetVariable>());
        expect(set.children, hasLength(1));

        final map = ResolvedVariable.fromInstance(
          object,
          vm.Instance(
            id: 'map',
            kind: vm.InstanceKind.kMap,
            associations: [vm.MapAssociation(key: childRef, value: childRef)],
          ),
        );
        expect(map, isA<MapVariable>());
        expect(map.children, hasLength(2));
        expect(map.children.first.label, 'key');
        expect(map.children.last.label, 'value');

        final unknown = ResolvedVariable.fromInstance(
          object,
          vm.Instance(
            id: 'object',
            kind: vm.InstanceKind.kPlainInstance,
            classRef: vm.ClassRef(id: 'class', name: 'ExampleObject'),
            identityHashCode: 123,
            fields: [vm.BoundField(name: 'field', value: childRef)],
          ),
        );
        expect(unknown, isA<UnknownObjectVariable>());
        expect((unknown as UnknownObjectVariable).type, 'ExampleObject');
        expect(unknown.identityHashCode, 123);
        expect(unknown.children.single.label, 'field');
      },
    );

    test('throws on unknown instance kinds', () {
      expect(
        () => ResolvedVariable.fromInstance(
          RootCachedObject(CacheId('unknown')),
          vm.Instance(id: 'unknown', kind: 'kUnknownKind'),
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
