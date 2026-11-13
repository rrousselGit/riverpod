import 'dart:convert';
import 'dart:io';

import 'package:doc_snippets/src/generate.dart';
import 'package:path/path.dart' as p;

/// The folder of the extracted snippets, relative to the repository root.
const _output = 'tools/doc_snippets/snippets';

/// Extracts the `dart` snippets of the doc comments and Markdown files of the
/// repository into Dart files of [_output] (see [generateSnippets]), where
/// they are analyzed like any other code, and removes the files of the
/// snippets that are gone.
///
/// Usage: `dart run doc_snippets:generate [root]`, where `root` is the
/// repository root (default: the current directory).
void main(List<String> args) {
  final root = p.absolute(args.firstOrNull ?? '.');

  final policyFile = File(p.join(root, snippetPolicyPath));
  if (!policyFile.existsSync()) {
    stderr.writeln('$snippetPolicyPath is missing.');
    exit(2);
  }
  final SnippetPolicy policy;
  try {
    policy = SnippetPolicy.parse(policyFile.readAsStringSync());
  } on FormatException catch (e) {
    stderr.writeln('$snippetPolicyPath is malformed: ${e.message}');
    exit(2);
  }

  // Tracked files and untracked ones that are not ignored.
  final git = Process.runSync(
    'git',
    [
      'ls-files',
      '--cached',
      '--others',
      '--exclude-standard',
      // Unquoted paths, separated by NUL.
      '-z',
    ],
    workingDirectory: root,
    stdoutEncoding: utf8,
  );
  if (git.exitCode != 0) {
    stderr.writeln('git ls-files failed:\n${git.stderr}');
    exit(2);
  }
  final files = (git.stdout as String)
      .split('\x00')
      .where((path) => path.isNotEmpty)
      // Deleted files are still listed until the deletion is staged.
      .where((path) => File(p.join(root, path)).existsSync())
      // The copies of a file, such as the README.md of the packages, would
      // have its snippets extracted again.
      .where((path) => !FileSystemEntity.isLinkSync(p.join(root, path)))
      .toList();

  final generation = generateSnippets(
    policy: policy,
    files: files,
    read: (path) => File(p.join(root, path)).readAsStringSync(),
  );

  final output = Directory(p.join(root, _output));
  final expected = {
    for (final path in generation.files.keys)
      p.join(output.path, p.fromUri(path)),
  };
  if (output.existsSync()) {
    for (final file in output.listSync(recursive: true).whereType<File>()) {
      if (p.extension(file.path) == '.dart' && !expected.contains(file.path)) {
        file.deleteSync();
      }
    }
    // Deepest first, so that the folders left with only empty folders go too.
    final folders = output.listSync(recursive: true).whereType<Directory>();
    for (final folder in folders.toList().reversed) {
      if (folder.listSync().isEmpty) folder.deleteSync();
    }
  }
  for (final MapEntry(key: path, value: content) in generation.files.entries) {
    final file = File(p.join(output.path, p.fromUri(path)));
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  stdout.writeln(
    'Extracted ${generation.files.length} snippets into $_output.',
  );
  if (generation.problems.isEmpty) return;

  stderr
    ..writeln('Some snippets could not be extracted:')
    ..writeAll(generation.problems.map((problem) => '  $problem\n'));
  exit(1);
}
