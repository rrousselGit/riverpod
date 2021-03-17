import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:codemod/codemod.dart';
import 'package:path/path.dart' as p;

final _root = p.canonicalize('./test/files');
// Shared analysis context to speed up tests, (analyzer only has to analyze shared dependencies once)
final _collection = AnalysisContextCollection(includedPaths: [_root]);

Future<FileContext> fileContextForGolden(String name) async {
  final file = p.canonicalize(name);
  return FileContext(file, _collection, root: _root);
}
