import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:package_config/package_config.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:riverpod_analyzer_utils/src/nodes.dart';
import 'package:riverpod_generator/src/riverpod_generator.dart';
import 'package:test/test.dart';

@internal
extension ObjectX<ValueT> on ValueT? {
  NewT? cast<NewT>() {
    final that = this;
    if (that is NewT) return that;
    return null;
  }

  NewT? let<NewT>(NewT? Function(ValueT value)? cb) {
    if (cb == null) return null;
    final that = this;
    if (that != null) return cb(that);
    return null;
  }
}

List<RiverpodAnalysisError> collectErrors(void Function() cb) {
  final errors = <RiverpodAnalysisError>[];
  final previousErrorReporter = errorReporter;

  try {
    errorReporter = errors.add;
    cb();
    return errors;
  } finally {
    errorReporter = previousErrorReporter;
  }
}

int _testNumber = 0;

Future<_TestAnalysisContext>? _analysisContext;

/// Shares dependency analysis while keeping each test's files at unique paths.
class _TestAnalysisContext {
  _TestAnalysisContext(this.directory, this.resources, this.collection);

  final Directory directory;
  final OverlayResourceProvider resources;
  final AnalysisContextCollection collection;
  int _stamp = 0;

  static Future<_TestAnalysisContext> create() async {
    final configUri = (await Isolate.packageConfig)!;
    final config = PackageConfig.parseString(
      File.fromUri(configUri).readAsStringSync(),
      configUri,
    );
    final directory = Directory.systemTemp.createTempSync('riverpod_analysis_');
    final resources = OverlayResourceProvider(
      PhysicalResourceProvider.INSTANCE,
    );
    final configJson = PackageConfig.toJson(config);
    (configJson['packages']! as List).add({
      'name': 'test_lib',
      'rootUri': directory.uri.toString(),
      'packageUri': 'lib/',
      'languageVersion': Platform.version.split('.').take(2).join('.'),
    });
    resources.setOverlay(
      p.join(directory.path, '.dart_tool', 'package_config.json'),
      content: jsonEncode(configJson),
      modificationStamp: 0,
    );
    resources.setOverlay(
      p.join(directory.path, 'analysis_options.yaml'),
      content: '{}',
      modificationStamp: 0,
    );
    final collection = AnalysisContextCollection(
      includedPaths: [directory.path],
      resourceProvider: resources,
    );
    return _TestAnalysisContext(directory, resources, collection);
  }

  void write(String path, String content) {
    resources.setOverlay(path, content: content, modificationStamp: ++_stamp);
    collection.contextFor(path).changeFile(path);
  }

  Future<void> dispose() async {
    await collection.dispose();
    directory.deleteSync(recursive: true);
  }
}

/// Resolves a test library within the shared analyzer context.
class TestSourceResolver {
  TestSourceResolver(this.context, this.path);

  final AnalysisContext context;
  final String path;

  Future<LibraryElement?> findLibraryByName(String name) async {
    final library = await context.currentSession.getResolvedLibrary(path);
    library as ResolvedLibraryResult;
    final pending = [library.element];
    final visited = <LibraryElement>{};
    while (pending.isNotEmpty) {
      final element = pending.removeLast();
      if (!visited.add(element)) continue;
      if (element.name == name) return element;
      pending.addAll(
        element.fragments
            .expand((fragment) => fragment.libraryImports)
            .map((import) => import.importedLibrary)
            .nonNulls,
      );
      pending.addAll(element.exportedLibraries);
    }
    return null;
  }
}

@isTest
void testSource(
  String description,
  Future<void> Function(
    TestSourceResolver resolver,
    CompilationUnit unit,
    List<ResolvedUnitResult> units,
  )
  run, {
  required String source,
  Map<String, String> files = const {},
  bool runGenerator = false,
  Timeout? timeout,
  Object? skip,
}) {
  if (_testNumber == 0) {
    tearDownAll(() async {
      if (_analysisContext case final context?) {
        await (await context).dispose();
      }
    });
  }
  final testId = _testNumber++;
  test(description, skip: skip, timeout: timeout, () async {
    final analysis = await (_analysisContext ??= _TestAnalysisContext.create());
    final testDirectory = p.join(analysis.directory.path, 'lib', 'test$testId');
    final path = p.join(testDirectory, 'foo.dart');
    analysis.write(path, 'library foo;$source');
    for (final entry in files.entries) {
      analysis.write(
        p.join(testDirectory, entry.key),
        'library "${entry.key}"; ${entry.value}',
      );
    }
    final context = analysis.collection.contextFor(path);
    await context.applyPendingFileChanges();

    Future<ResolvedLibraryResult> getLibrary() async {
      return await context.currentSession.getResolvedLibrary(path)
          as ResolvedLibraryResult;
    }

    if (runGenerator) {
      final library = await getLibrary();
      final generated = RiverpodGenerator(
        const {},
      ).generateForUnit(library.units.map((e) => e.unit).toList());
      analysis.write(
        p.join(testDirectory, 'foo.g.dart'),
        'part of "foo.dart";$generated',
      );
      await context.applyPendingFileChanges();
    }

    final library = await getLibrary();
    final unit = library.units.firstWhere((unit) => unit.path == path).unit;
    try {
      await run(TestSourceResolver(context, path), unit, library.units);
    } finally {
      collectErrors(() {
        for (final unit in library.units) {
          expectRiverpodAstOnlyHasASingleOptionPerNode(unit.unit);
        }
      });
    }
  });
}

/// Asserts that no [AstNode] has more than one Riverpod AST representation.
void expectRiverpodAstOnlyHasASingleOptionPerNode(AstNode node) {
  final result = CollectionRiverpodAst();
  node.accept(result);
  for (final entry in result.riverpodAst.entries) {
    expect(entry.value, anyOf(hasLength(0), hasLength(1)), reason: entry.key);
  }
  node.visitChildren(_VisitNode(expectRiverpodAstOnlyHasASingleOptionPerNode));
}

class _VisitNode extends GeneralizingAstVisitor<void> {
  _VisitNode(this.cb);
  final void Function(AstNode node) cb;
  @override
  void visitNode(AstNode node) => cb(node);
}

extension MapTake<KeyT, ValueT> on Map<KeyT, ValueT> {
  Map<KeyT, ValueT> take(List<KeyT> keys) {
    return <KeyT, ValueT>{
      for (final key in keys)
        if (!containsKey(key))
          key: throw StateError('No key $key found')
        else
          key: this[key] as ValueT,
    };
  }
}

extension TakeList<ProviderT extends ProviderDeclaration> on List<ProviderT> {
  Map<String, ProviderT> takeAll(List<String> names) {
    final result = Map.fromEntries(map((e) => MapEntry(e.name.lexeme, e)));
    return result.take(names);
  }

  ProviderT findByName(String name) {
    return singleWhere((element) => element.name.lexeme == name);
  }
}

extension FindAst<NodeT extends AstNode> on List<NodeT> {
  WhereNodeT findByName<WhereNodeT extends NodeT>(String name) {
    for (final node in this) {
      switch (node) {
        case TopLevelVariableDeclaration():
          final variableWithName = node.variables.variables.firstWhereOrNull(
            (element) => element.name.lexeme == name,
          );

          if (variableWithName != null) return variableWithName as WhereNodeT;

        case MethodDeclaration():
          if (node.name.lexeme == name) return node as WhereNodeT;

        case FieldDeclaration():
          final variableWithName = node.fields.variables.firstWhereOrNull(
            (element) => element.name.lexeme == name,
          );

          if (variableWithName != null) return variableWithName as WhereNodeT;

        // CompilationUnitMember subtypes
        case ClassDeclaration(
          namePart: ClassNamePart(typeName: final nameToken),
        ):
        case MixinDeclaration(name: final nameToken):
        case ExtensionDeclaration(name: final nameToken?):
        case EnumDeclaration(
          namePart: ClassNamePart(typeName: final nameToken),
        ):
        case TypeAlias(name: final nameToken):
        case FunctionDeclaration(name: final nameToken):
          if (nameToken.lexeme == name) return node as WhereNodeT;

        default:
          throw UnsupportedError('Unsupported node ${node.runtimeType}');
      }
    }

    throw StateError('No node found with name "$name"');
  }
}

extension ResolverX on TestSourceResolver {
  // ignore: invalid_use_of_internal_member
  Future<RiverpodAnalysisResult> resolveRiverpodAnalysisResult({
    String libraryName = 'foo',
    bool ignoreErrors = false,
  }) async {
    final library = await requireFindLibraryByName(libraryName);

    final libraryAst = await library.session.getResolvedLibraryByElement(
      library,
    );
    libraryAst as ResolvedLibraryResult;

    final compilerErrors = libraryAst.units
        .expand((e) => e.errors)
        .where((e) => e.severity == Severity.error)
        .toList();
    if (compilerErrors.isNotEmpty && !ignoreErrors) {
      throw StateError('''
The parsed library has compiler errors:
${compilerErrors.map((e) => '- $e\n').join()}
''');
    }

    final result = RiverpodAnalysisResult();

    final errors = <RiverpodAnalysisError>[];
    final previousErrorReporter = errorReporter;
    try {
      if (ignoreErrors) {
        errorReporter = errors.add;
      } else {
        errorReporter = (error) {
          throw StateError('Unexpected error: $error');
        };
      }

      for (final unit in libraryAst.units) {
        unit.unit.accept(result);
      }
    } finally {
      errorReporter = previousErrorReporter;
    }

    result.errors.addAll(errors);

    if (!ignoreErrors) {
      if (errors.isNotEmpty) {
        throw StateError(errors.map((e) => '- $e\n').join());
      }
    }

    return result;
  }

  Future<LibraryElement> requireFindLibraryByName(String libraryName) async {
    final library = await findLibraryByName(libraryName);
    if (library == null) {
      throw StateError('No library found for name "$libraryName"');
    }

    return library;
  }
}
