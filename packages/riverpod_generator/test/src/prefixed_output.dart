import 'dart:io';

import 'package:test/test.dart';

/// The code generated for `test/integration/prefixed.dart`, which imports
/// riverpod_annotation with the `r` prefix, without its comments.
///
/// golden_test.dart checks that it is the current output of the generator.
final _prefixedOutput = File('test/integration/prefixed.g.dart')
    .readAsLinesSync()
    .where((line) => !line.trimLeft().startsWith('//'))
    .join('\n');

/// Expects the generated code to reference each of [names] through the
/// prefix of its import only.
void expectPrefixed(List<String> names) {
  for (final name in names) {
    expect(_prefixedOutput, contains('r.$name'), reason: name);

    final unprefixed = RegExp('(?<![\\w\$.])${RegExp.escape(name)}(?![\\w\$])');
    expect(_prefixedOutput, isNot(contains(unprefixed)), reason: name);
  }
}
