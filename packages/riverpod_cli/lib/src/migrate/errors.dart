import 'dart:io';

import 'package:codemod/codemod.dart';

bool errorOccurredDuringMigration = false;
const migrationUrl = 'https://riverpod.dev/docs/migration/0.14.0_to_1.0.0';
final migrationErrors = <String, String>{};
void printErrorLogs() {
  stderr.writeln(
    'There was an error during migration, please submit a bug report to riverpod, with any relevant logs and code',
  );
  stderr.writeln();
  stderr
      .writeln('The following files were not able to be successfully migrated');
  for (final error in migrationErrors.entries) {
    stderr.writeln('\t${error.key}: had error ${error.value}');
  }
  stderr.writeln();
  stderr.writeln('Next Steps - either');
  stderr.writeln(
    '\t1: Revert your changes and wait for the migration tool to be fixed',
  );
  stderr.writeln(
    '\t2: Run flutter pub upgrade and finish the migration manually using the migration guide $migrationUrl',
  );
}

mixin ErrorHandling<T> on AstVisitingSuggestor<T> {
  void addError(String message) {
    errorOccurredDuringMigration = true;
    migrationErrors[context.path] = message;
  }
}
