import 'dart:io';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:codemod/codemod.dart';
import 'package:path/path.dart' as p;
import 'package:test_descriptor/test_descriptor.dart' as d;

Future<FileContext> fileContextForGolden(String name) async {
  // Use test_descriptor to create the file in a temporary directory
  d.Descriptor descriptor;
  final segments = p.split(name);
  // Last segment should be the file
  descriptor = d.file(segments.last, File(name).readAsStringSync());
  // Any preceding segments (if any) are directories
  for (final dir in segments.reversed.skip(1)) {
    descriptor = d.dir(dir, [descriptor]);
  }
  await descriptor.create();

  // Setup analysis for this file
  final path = p.canonicalize(p.join(d.sandbox, name));
  final collection = AnalysisContextCollection(includedPaths: [path]);

  return FileContext(path, collection, root: d.sandbox);
}
