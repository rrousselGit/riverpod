import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_generator/src/riverpod_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  group('Notifiers', () {
    group('with arguments', () {
      test('should throw if the class is abstract', () async {
        const source = r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
abstract class MyNotifier extends _$MyNotifier {
  @override
  int build(int a) => 0;
}
''';

        await expectLater(
          () => compile(source),
          throwsA(isA<InvalidGenerationSourceError>()),
        );
      });

      test('should throw if there is no default constructor', () async {
        const source = r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class MyNotifier extends _$MyNotifier {
  MyNotifier._();

  @override
  int build(int a) => 0;
}
''';

        await expectLater(
          () => compile(source),
          throwsA(isA<InvalidGenerationSourceError>()),
        );
      });

      test('should throw if the default constructor has required parameters',
          () async {
        const source = r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class MyNotifier extends _$MyNotifier {
  MyNotifier(int a);

  @override
  int build(int a) => 0;
}
''';

        await expectLater(
          () => compile(source),
          throwsA(isA<InvalidGenerationSourceError>()),
        );
      });
    });

    group('without arguments', () {
      test('should throw if the class is abstract', () async {
        const source = r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
abstract class MyNotifier extends _$MyNotifier {
  @override
  int build() => 0;
}
''';

        await expectLater(
          () => compile(source),
          throwsA(isA<InvalidGenerationSourceError>()),
        );
      });
    });
  });
}

void tearDownTmp() {
  addTearDown(() {
    final tmp = Directory('.dart_tool/test');
    if (tmp.existsSync()) {
      tmp.deleteSync(recursive: true);
    }
  });
}

File createTmpFile(String filePath) {
  tearDownTmp();

  final file = File(path.join('.dart_tool', 'test', filePath));
  file.createSync(recursive: true);

  return file;
}

Future<String> compile(String source) async {
  final generator = RiverpodGenerator(const {});

  final main = createTmpFile('lib/main.dart')..writeAsStringSync(source);
  final pubspec = createTmpFile('pubspec.yaml')..writeAsStringSync('''
name: test_app

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  riverpod_annotation: ^2.3.3
''');

  await runPubGet(pubspec.parent);

  final result = await resolveFile2(path: main.absolute.path);

  result as ResolvedUnitResult;

  return generator.generateForUnit([result.unit]);
}

Future<void> runPubGet(Directory parent) async {
  final process = await Process.start(
    'dart',
    ['pub', 'get'],
    workingDirectory: parent.path,
  );

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw Exception(
      'flutter pub get failed with exit code $exitCode\n'
      '${await process.stdout.transform(utf8.decoder).join()}',
    );
  }
}
