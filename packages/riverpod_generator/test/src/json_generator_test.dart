// Resolving the sources takes a while, even more so with coverage.
@Timeout.factor(4)
library;

import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('decodes objects using the import prefix of their type', () {
    // Both libraries declare the same names: only the prefix tells them apart.
    const models = '''
class Model {
  Model.fromJson(Map<String, Object?> json);
}

class Box<ItemT> {
  Box.fromJson(Map<String, Object?> json);
}
''';

    late final String generated;

    setUpAll(() async {
      generated = await generate({
        'unprefixed.dart': models,
        'prefixed.dart': models,
        'main.dart': r'''
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/experimental/persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'prefixed.dart' as p;
import 'unprefixed.dart';

part 'main.g.dart';

@riverpod
@JsonPersist()
class Prefixed extends _$Prefixed {
  @override
  Future<p.Model> build() => throw UnimplementedError();
}

@riverpod
@JsonPersist()
class Nested extends _$Nested {
  @override
  Future<Map<String, List<Set<p.Model?>>>> build() =>
      throw UnimplementedError();
}

@riverpod
@JsonPersist()
class Generic extends _$Generic {
  @override
  Future<p.Box<p.Model>> build() => throw UnimplementedError();
}

@riverpod
@JsonPersist()
class Unprefixed extends _$Unprefixed {
  @override
  Future<List<Model>> build() => throw UnimplementedError();
}
''',
      });
    });

    /// The body of the `decode` fallback generated for the notifier [name].
    String decodeOf(String name) {
      final match = RegExp(
        'abstractclass_\\\$$name'
        r'extends.*?final\w+=\$jsonCodex\.decode\(encoded\);return(.*?);},',
      ).firstMatch(generated);
      return match!.group(1)!;
    }

    test('as the state, leaving unprefixed types as is', () {
      expect(decodeOf('Prefixed'), 'p.Model.fromJson(easMap<String,Object?>)');
      expect(
        decodeOf('Unprefixed'),
        '(easList).map((e)=>Model.fromJson(easMap<String,Object?>)).toList()',
      );
    });

    test('nested in collections, and nullable', () {
      expect(
        decodeOf('Nested'),
        '(easMap).map((k,v)=>MapEntry(kasString,'
        '(vasList).map((e)=>(easList).map((e)=>'
        'e==null?null:p.Model?.fromJson(easMap<String,Object?>)'
        ').toSet()).toList()))',
      );
    });

    test('with type arguments', () {
      expect(
        decodeOf('Generic'),
        'p.Box<p.Model>.fromJson(easMap<String,Object?>)',
      );
    });
  });
}
