import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/collection.dart';

void main() {
  group('SetBuilder', () {
    test('returns the original set when unchanged', () {
      final original = {1, 2};
      final builder = SetBuilder(original);

      expect(identical(builder.build(), original), isTrue);
      expect(builder.build(), {1, 2});
    });

    test('clones before mutating', () {
      final original = {1, 2};
      final builder = SetBuilder(original);

      final didAdd = builder.add(3);

      expect(didAdd, isTrue);
      expect(original, {1, 2});
      expect(builder.build(), {1, 2, 3});
      expect(identical(builder.build(), original), isFalse);
    });
  });

  group('MapBuilder', () {
    test('returns the original map when unchanged', () {
      final original = {'a': 1};
      final builder = MapBuilder(original);

      expect(identical(builder.build(), original), isTrue);
      expect(builder['a'], 1);
    });

    test('clones on write and leaves original untouched', () {
      final original = {'a': 1};
      final builder = MapBuilder(original);

      builder['b'] = 2;

      expect(original, {'a': 1});
      expect(builder.build(), {'a': 1, 'b': 2});
      expect(identical(builder.build(), original), isFalse);
    });

    test('removes values from the cloned map', () {
      final original = {'a': 1, 'b': 2};
      final builder = MapBuilder(original);

      final removed = builder.remove('a');

      expect(removed, 1);
      expect(original, {'a': 1, 'b': 2});
      expect(builder.build(), {'b': 2});
    });
  });

  group('UnmodifiableMap', () {
    test('delegates reads but rejects writes', () {
      final map = UnmodifiableMap<String, int>({'a': 1});

      expect(map['a'], 1);
      expect(map.containsKey('a'), isTrue);
      // ignore: deprecated_member_use_from_same_package, we're testing that it throws
      expect(() => map['b'] = 2, throwsA(isA<UnsupportedError>()));
      expect(() => map.addAll({'b': 2}), throwsA(isA<UnsupportedError>()));
      expect(() => map.remove('a'), throwsA(isA<UnsupportedError>()));
      expect(map.clear, throwsA(isA<UnsupportedError>()));
    });
  });
}
