import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart' as vm;

void main() {
  group('DerivedCachedObject', () {
    test('objectField infers labels from named and positional fields', () {
      final root = RootCachedObject(CacheId('root'));

      final positional = DerivedCachedObject.objectField(
        root,
        vm.BoundField(name: 0),
      );
      final named = DerivedCachedObject.objectField(
        root,
        vm.BoundField(name: 'label'),
      );

      expect(positional.from, same(root));
      expect(positional.label, isNull);
      expect(named.from, same(root));
      expect(named.label, 'label');
    });

    test('collectionElement keeps the parent object and no explicit label', () {
      final root = RootCachedObject(CacheId('root'));
      final child = DerivedCachedObject.collectionElement(root, 1);

      expect(child.from, same(root));
      expect(child.label, isNull);
    });

    test('mapAssociationKey and mapAssociationValue expose fixed labels', () {
      final root = RootCachedObject(CacheId('root'));
      final key = DerivedCachedObject.mapAssociationKey(root, 0);
      final value = DerivedCachedObject.mapAssociationValue(root, 0);

      expect(key.from, same(root));
      expect(key.label, 'key');
      expect(value.from, same(root));
      expect(value.label, 'value');
    });

    test('objectField rejects unsupported field-name types eagerly', () {
      expect(
        () => DerivedCachedObject.objectField(
          RootCachedObject(CacheId('root')),
          vm.BoundField(name: 3.14),
        ),
        throwsStateError,
      );
    });
  });

  group('RootCachedObject', () {
    test('toString includes the cache id', () {
      expect(
        RootCachedObject(CacheId('cache-1')).toString(),
        'CachedObject(id: cache-1)',
      );
    });
  });
}
