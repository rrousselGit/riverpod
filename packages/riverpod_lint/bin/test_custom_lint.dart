// TODO: Replace with custom_lint/basic_runner.dart once merged into custom_lint
// Hotreloader and watcher are really more of dev-dependencies

// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as dev;

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:path/path.dart';
import 'package:watcher/watcher.dart';

import 'custom_lint.dart';

void main() async {
  final collection = AnalysisContextCollection(
    includedPaths: [canonicalize('../riverpod_lint_flutter_test/')],
  );
  const test = 'mutate_in_create';
  final file =
      canonicalize('../riverpod_lint_flutter_test/test/goldens/$test.dart');
  final watcher = FileWatcher(file);
  ResolvedUnitResult? unit;
  Future<void> analyzeTestFile() async {
    final context = collection.contextFor(file);
    final result = await context.currentSession.getResolvedUnit(file);
    if (result is ResolvedUnitResult) {
      unit = result;
    } else {
      dev.log('Error finding or analyzing file $file');
    }
  }

  Future<void> getLints() async {
    if (unit == null) {
      return;
    }
    await for (final lint in RiverpodLint().getLints(unit!)) {
      dev.log(
        'Got lint ${lint.code} "${lint.message}" at location ${lint.location.startLine}:${lint.location.startColumn}',
      );
    }
  }

  watcher.events.listen((_) async {
    dev.log('Test file changed, rerunning dart analyzer');
    await analyzeTestFile();
    dev.log('Rerunning lint analysis');
    await getLints();
  });

  final _ = await HotReloader.create(
    onBeforeReload: (_) {
      dev.log('Linter changed, reloading linter code');
      return true;
    },
    onAfterReload: (_) async {
      dev.log('Rerunning lint analysis');
      await getLints();
    },
  );
  dev.log('Analyzing test file');
  await analyzeTestFile();
  dev.log('Running lint analysis');
  await getLints();
}
