// Tells which Dart files changed in more than directives, comments and
// whitespace.
//
// Usage: dart run code_changes OLD NEW [OLD NEW...]
//
// For each pair of files (two versions of one Dart file), prints NEW when
// their declarations differ. Pairs that only differ in directives (imports,
// exports, parts), comments (docs included) or whitespace print nothing.
// See `sameDeclarations`.

import 'dart:io';

import 'package:code_changes/code_changes.dart';

void main(List<String> args) {
  if (args.isEmpty || args.length.isOdd) {
    stderr.writeln('usage: code_changes OLD NEW [OLD NEW...]');
    exitCode = 2;
    return;
  }
  for (var i = 0; i < args.length; i += 2) {
    final before = File(args[i]).readAsStringSync();
    final after = File(args[i + 1]).readAsStringSync();
    if (!sameDeclarations(before, after)) stdout.writeln(args[i + 1]);
  }
}
