import 'dart:io';
// ignore: deprecated_member_use
import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:codemod/codemod.dart';
import 'package:glob/glob.dart';
import 'package:source_span/source_span.dart';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void analysisGroup(String name, String inputFileDir,
    void Function(AnalysisAssistant assistant) groupTests) {
  group(name, () {
    final assistant = AnalysisAssistant(inputFileDir);
    setUpAll(() {
      final inputFilePath = path.canonicalize(path.join(inputFileDir, 'input'));
      final collection = AnalysisContextCollection(
        includedPaths:
            filePathsFromGlob(Glob('$inputFilePath/**.dart', recursive: true))
                .toList(),
      );
      assistant._collection = collection;
    });

    groupTests(assistant);
  });
}

class AnalysisAssistant {
  AnalysisAssistant(this.inputFileDir);
  final String inputFileDir;
  AnalysisContextCollection _collection;

  void testResolvedFile(String testName, String fileName,
      void Function(SourceFile, CompilationUnit) tester) {
    test(testName, () async {
      final filePath = path.join(inputFileDir, 'input', '$fileName.dart');
      final file = File(filePath).readAsStringSync();
      final sourceFile = SourceFile.fromString(file);
      final f = path.canonicalize(filePath);
      final context = _collection.contextFor(f);
      final unit = await context.currentSession.getResolvedUnit(f);
      final compilationUnit = unit.unit;
      print('Testing ${sourceFile.getText(0)}');
      tester(sourceFile, compilationUnit);
    });
  }

  String getGolden(String fileName) {
    final filePath = path.join(inputFileDir, 'golden', '$fileName.dart');
    return File(filePath).readAsStringSync();
  }
}
