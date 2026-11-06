import 'package:internal_lint/src/legacy_api.dart';
import 'package:internal_lint/src/legacy_api_check.dart';
import 'package:test/test.dart';

// Split, so that this file does not trip the check it tests.
final _ignore = ['// ignore', 'avoid_legacy_api'].join(': ');
final _ignoreForFile = ['// ignore_for_file', 'avoid_legacy_api'].join(': ');

void main() {
  final policy = LegacyApiPolicy.parse('''
ignored:
  - ignored/**
allowed:
  - allowed/**
baseline:
  - baseline_used.md
  - baseline_unused.md
  - lib/baseline.dart
''');

  List<String> check(Map<String, String> files, {LegacyApiPolicy? policy_}) {
    return checkLegacyApi(
      policy: policy_ ?? policy,
      files: files.keys.toList(),
      read: (path) => files[path]!,
    );
  }

  // The files of the baseline, so that it is not reported as stale, and the
  // options that enable the lint on Dart files.
  const baseline = {
    'analysis_options.yaml': 'plugins:\n  internal_lint:\n    path: lint\n',
    'baseline_used.md': '```dart\nStateProvider\n```',
    'baseline_unused.md': '```dart\nStateProvider\n```',
    'lib/baseline.dart': '',
  };

  test('passes when legacy APIs are only where allowed', () {
    expect(
      check({
        ...baseline,
        'allowed/a.md': '```dart\nStateProvider\n```',
        'allowed/pubspec.yaml': 'dependencies:\n  state_notifier: 1\n',
        'a.md': 'StateProvider in prose',
        'lib/a.dart': 'StateProvider',
      }),
      isEmpty,
    );
  });

  test('skips ignored files', () {
    expect(
      check({
        ...baseline,
        'ignored/a.md': '```dart\nStateProvider\n```',
        'ignored/a.dart': 'StateProvider $_ignore',
        'ignored/pubspec.yaml': 'dependencies:\n  state_notifier: 1\n',
      }),
      isEmpty,
    );
  });

  test('reports text uses outside of the policy', () {
    expect(
      check({
        ...baseline,
        'a.md': '```dart\nStateProvider\n```',
        'pubspec.yaml': 'dependencies:\n  state_notifier: 1\n',
        'docs/analysis_options.yaml': '''
include: ../analysis_options.yaml
analyzer:
  exclude:
    - i18n/**
''',
        'docs/i18n/a.dart': 'StateProvider',
      }),
      [
        'a.md:2: uses a legacy API: StateProvider',
        'pubspec.yaml:2: uses a legacy API: state_notifier: 1',
        'docs/i18n/a.dart:1: uses a legacy API: StateProvider',
      ],
    );
  });

  test('reads as text the Dart files that the lint does not analyze', () {
    expect(
      check({
        ...baseline,
        // Included, directly or not: analyzed by the lint.
        'a/analysis_options.yaml': 'include: ../analysis_options.yaml',
        'a/b/analysis_options.yaml': 'include: [../analysis_options.yaml]',
        'a/b/linted.dart': 'StateProvider',
        // Not included: no plugins.
        'c/analysis_options.yaml': 'import: ../analysis_options.yaml',
        'c/typo.dart': 'StateProvider',
        'd/analysis_options.yaml': 'include: package:lints/recommended.yaml',
        'd/package.dart': 'StateProvider',
        // Excluded.
        'e/analysis_options.yaml': '''
include: ../analysis_options.yaml
analyzer:
  exclude: [gen/**]
''',
        'e/gen/excluded.dart': 'StateProvider',
        'e/included.dart': 'StateProvider',
      }),
      [
        'c/typo.dart:1: uses a legacy API: StateProvider',
        'd/package.dart:1: uses a legacy API: StateProvider',
        'e/gen/excluded.dart:1: uses a legacy API: StateProvider',
      ],
    );

    expect(
      check({
        'no_options.dart': 'StateProvider',
      }, policy_: LegacyApiPolicy.parse('{}')),
      ['no_options.dart:1: uses a legacy API: StateProvider'],
    );
  });

  test('reports baseline entries that are stale', () {
    expect(check({...baseline, 'baseline_unused.md': 'nothing'}), [
      'baseline_unused.md: no longer uses legacy APIs. '
          'Remove it from the baseline of $legacyApiPolicyPath.',
    ]);

    expect(check({...baseline}..remove('lib/baseline.dart')), [
      'lib/baseline.dart: in the baseline, but no longer exists.',
    ]);
  });

  test('reports malformed baselines', () {
    final malformed = LegacyApiPolicy.parse('''
allowed:
  - allowed/**
ignored:
  - ignored/**
baseline:
  - a.md
  - a.md
  - allowed/b.md
  - ignored/c.md
''');

    expect(
      check({
        'a.md': '```dart\nStateProvider\n```',
        'allowed/b.md': '',
        'ignored/c.md': '',
      }, policy_: malformed),
      [
        'a.md: listed twice in the baseline.',
        'allowed/b.md: in the baseline, but already allowed.',
        'ignored/c.md: in the baseline, but ignored.',
      ],
    );
  });

  test('forbids silencing the lint', () {
    expect(
      check({
        ...baseline,
        'allowed/a.dart': 'StateProvider $_ignore',
        'lib/b.dart': '\n$_ignoreForFile',
        'other/analysis_options.yaml':
            'analyzer:\n  errors:\n    avoid_legacy_api: ignore',
      }),
      [
        'allowed/a.dart:1: avoid_legacy_api must not be ignored. '
            'Add the file to the baseline of $legacyApiPolicyPath instead.',
        'lib/b.dart:2: avoid_legacy_api must not be ignored. '
            'Add the file to the baseline of $legacyApiPolicyPath instead.',
        'other/analysis_options.yaml: avoid_legacy_api must not be configured.',
      ],
    );
  });
}
