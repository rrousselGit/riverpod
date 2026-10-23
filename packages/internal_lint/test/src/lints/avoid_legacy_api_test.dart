import 'dart:io';

import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:internal_lint/src/lints/avoid_legacy_api.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../../utils.dart';

const _policy = '''
ignored:
  - ignored/**
allowed:
  - allowed/**
baseline:
  - baseline_used.dart
  - baseline_unused.dart
''';

const _legacyUse = '''
import 'package:riverpod/legacy.dart';

final counter = StateProvider((ref) => 0);
''';

/// A library that is not legacy, but lets legacy APIs through.
const _reexport = '''
export 'package:riverpod/legacy.dart';
export 'package:riverpod/riverpod.dart' show Provider;
''';

void main() {
  Future<List<Diagnostic>> analyze(Directory root, String path) {
    return runRule(AvoidLegacyApi(), p.join(root.path, path));
  }

  String reported(String content, Diagnostic diagnostic) {
    return content.substring(
      diagnostic.offset,
      diagnostic.offset + diagnostic.length,
    );
  }

  test('reports imports and uses of legacy APIs', () async {
    final root = createFixture({
      'baselines/legacy_api.yaml': _policy,
      'a.dart': _legacyUse,
    });

    final diagnostics = await analyze(root, 'a.dart');

    expect(diagnostics.map((e) => reported(_legacyUse, e)), [
      "import 'package:riverpod/legacy.dart';",
      'StateProvider',
    ]);
    expect(
      diagnostics.last.message,
      contains('`StateProvider` is a legacy API'),
    );
  });

  test('reports doc references to legacy APIs', () async {
    const content = '''
import 'package:riverpod/legacy.dart' show StateProvider;

/// Unlike [StateProvider].
void fn() {}
''';
    final root = createFixture({
      'baselines/legacy_api.yaml': _policy,
      'a.dart': content,
    });

    final diagnostics = await analyze(root, 'a.dart');

    expect(diagnostics.map((e) => reported(content, e)), [
      "import 'package:riverpod/legacy.dart' show StateProvider;",
      'StateProvider',
    ]);
    expect(diagnostics.last.offset, content.indexOf('[StateProvider]') + 1);
  });

  test('reports members of legacy APIs', () async {
    const content = '''
import 'package:riverpod/riverpod.dart';
import 'other.dart';

void fn(Ref ref) {
  ref.read(counter.notifier).state++;
}
''';
    final root = createFixture({
      'baselines/legacy_api.yaml': _policy,
      'other.dart': _legacyUse,
      'a.dart': content,
    });

    final diagnostics = await analyze(root, 'a.dart');

    // `counter` itself is declared in other.dart, which is reported instead.
    expect(diagnostics.map((e) => reported(content, e)), ['notifier', 'state']);
  });

  test('reports exports that let legacy APIs through', () async {
    const content = '''
export 'package:riverpod/riverpod.dart';
export 'other.dart' show StateProvider;
export 'other.dart' show Provider;
export 'other.dart' hide StateProvider, StateNotifier, StateController, StateNotifierProvider, StateNotifierProviderFamily, StateProviderFamily;
export 'package:riverpod/legacy.dart';
''';
    final root = createFixture({
      'baselines/legacy_api.yaml': _policy,
      'other.dart': _reexport,
      'a.dart': content,
    });

    final diagnostics = await analyze(root, 'a.dart');

    expect(diagnostics.map((e) => reported(content, e)), [
      "export 'other.dart' show StateProvider;",
      "export 'package:riverpod/legacy.dart';",
    ]);
  });

  test('skips deprecated exports, which are on their way out', () async {
    const content = '''
@Deprecated('Import legacy.dart instead')
export 'other.dart' show StateProvider;
@Deprecated('Import legacy.dart instead')
export 'package:riverpod/legacy.dart';
''';
    final root = createFixture({
      'baselines/legacy_api.yaml': _policy,
      'other.dart': _reexport,
      'a.dart': content,
    });

    expect(await analyze(root, 'a.dart'), isEmpty);
  });

  test('allows the files that the policy allows', () async {
    final root = createFixture({
      'baselines/legacy_api.yaml': _policy,
      'allowed/a.dart': _legacyUse,
    });

    expect(await analyze(root, 'allowed/a.dart'), isEmpty);
  });

  test('skips ignored files', () async {
    final root = createFixture({
      'baselines/legacy_api.yaml': _policy,
      'ignored/a.dart': _legacyUse,
    });

    expect(await analyze(root, 'ignored/a.dart'), isEmpty);
  });

  test('allows the files of the baseline', () async {
    final root = createFixture({
      'baselines/legacy_api.yaml': _policy,
      'baseline_used.dart': _legacyUse,
    });

    expect(await analyze(root, 'baseline_used.dart'), isEmpty);
  });

  test('reports baseline files that no longer use legacy APIs', () async {
    final root = createFixture({
      'baselines/legacy_api.yaml': _policy,
      'baseline_unused.dart': 'void main() {}',
    });

    final diagnostics = await analyze(root, 'baseline_unused.dart');

    expect(diagnostics, hasLength(1));
    expect(diagnostics.single.offset, 0);
    expect(
      diagnostics.single.message,
      contains('This file no longer uses legacy APIs'),
    );
  });

  test('reads the policy of the closest parent folder', () async {
    final root = createFixture({
      'baselines/legacy_api.yaml': 'allowed:\n  - "**"\n',
      'nested/baselines/legacy_api.yaml': _policy,
      'nested/a.dart': _legacyUse,
    });

    expect(await analyze(root, 'nested/a.dart'), hasLength(2));
  });
}
