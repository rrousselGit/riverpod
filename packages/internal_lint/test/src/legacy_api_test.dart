import 'dart:io';

import 'package:internal_lint/src/legacy_api.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('LegacyApiPolicy.parse', () {
    test('reads ignored, allowed and baseline', () {
      final policy = LegacyApiPolicy.parse('''
ignored:
  - i18n/**
allowed:
  - lib/legacy/**
  - "**/CHANGELOG.md"
baseline:
  - lib/old.dart
''');

      expect(policy.isIgnored('i18n/fr/a.md'), isTrue);
      expect(policy.isIgnored('lib/legacy/a/b.dart'), isFalse);

      expect(policy.isAllowed('lib/legacy/a/b.dart'), isTrue);
      expect(policy.isAllowed('packages/x/CHANGELOG.md'), isTrue);
      expect(policy.isAllowed('lib/old.dart'), isFalse);

      expect(policy.isBaseline('lib/old.dart'), isTrue);
      expect(policy.isBaseline('lib/legacy/a.dart'), isFalse);
    });

    test('accepts missing and empty lists', () {
      final policy = LegacyApiPolicy.parse('baseline:\n');

      expect(policy.ignored, isEmpty);
      expect(policy.allowed, isEmpty);
      expect(policy.baseline, isEmpty);
    });

    test('rejects malformed files', () {
      expect(() => LegacyApiPolicy.parse('- a'), throwsFormatException);
      expect(() => LegacyApiPolicy.parse('allowed: a'), throwsFormatException);
      expect(
        () => LegacyApiPolicy.parse('allowed:\n  - 42\n'),
        throwsFormatException,
      );
      expect(() => LegacyApiPolicy.parse('other: []'), throwsFormatException);
    });
  });

  test('legacyApiPolicyPath exists, relative to the repository root', () {
    // Tests run from packages/internal_lint.
    final root = p.normalize(p.join(Directory.current.path, '..', '..'));
    expect(File(p.join(root, legacyApiPolicyPath)).existsSync(), isTrue);
  });

  test('relativePolicyPath', () {
    expect(relativePolicyPath('/repo/a/b.dart', root: '/repo'), 'a/b.dart');
  });

  test('isLegacyLibrary', () {
    for (final uri in [
      'package:state_notifier/state_notifier.dart',
      'package:riverpod/legacy.dart',
      'package:flutter_riverpod/legacy.dart',
      'package:hooks_riverpod/legacy.dart',
      'package:riverpod/src/providers/legacy/state_provider.dart',
      'package:flutter_riverpod/src/providers/legacy/change_notifier_provider.dart',
    ]) {
      expect(isLegacyLibrary(Uri.parse(uri)), isTrue, reason: uri);
    }

    for (final uri in [
      'package:riverpod/riverpod.dart',
      'package:riverpod/src/providers/notifier.dart',
      'package:hooks_riverpod/src/providers/legacy/a.dart',
      'package:other/legacy.dart',
      'dart:core',
      'file:///riverpod/legacy.dart',
    ]) {
      expect(isLegacyLibrary(Uri.parse(uri)), isFalse, reason: uri);
    }
  });

  group('findLegacyTextUses', () {
    test('reads pubspec.yaml dependencies on state_notifier', () {
      expect(
        findLegacyTextUses('a/pubspec.yaml', '''
name: a
dependencies:
  state_notifier: ^1.0.0
'''),
        [(line: 3, text: 'state_notifier: ^1.0.0')],
      );
      expect(
        findLegacyTextUses('a/other.yaml', 'x:\n  state_notifier: 1'),
        <LegacyTextUse>[
          // Only pubspec.yaml files are read.
        ],
      );
    });

    test('reads the dart code blocks of Markdown files', () {
      const content = '''
StateProvider in prose is fine.

```dart
import 'package:riverpod/legacy.dart';
final a = Provider((ref) => 0);
```

```yaml
StateProvider: 0
```
''';

      for (final path in ['a.md', 'a.mdx']) {
        expect(findLegacyTextUses(path, content), [
          (line: 4, text: "import 'package:riverpod/legacy.dart';"),
        ]);
      }
    });

    test('reads all of Dart files', () {
      expect(
        findLegacyTextUses('a.dart', '''
import 'package:state_notifier/state_notifier.dart';
// MyStateNotifier is not StateNotifier
final a = StateNotifierProvider<A, int>((ref) => A());
'''),
        [
          (
            line: 1,
            text: "import 'package:state_notifier/state_notifier.dart';",
          ),
          (line: 2, text: '// MyStateNotifier is not StateNotifier'),
          (
            line: 3,
            text: 'final a = StateNotifierProvider<A, int>((ref) => A());',
          ),
        ],
      );
      expect(findLegacyTextUses('a.dart', 'class MyStateNotifier {}'), isEmpty);
    });

    test('ignores other files', () {
      expect(findLegacyTextUses('a.txt', 'StateProvider'), isEmpty);
    });
  });
}
