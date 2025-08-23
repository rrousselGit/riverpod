import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:package_config/package_config.dart';
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

/// Due to [resolveSource] throwing if trying to interact with the resolver
/// after the future completed, we change the syntax to make sure our test
/// executes within the resolver scope.
@isTest
void testSource(
  String description,
  Future<void> Function(
    Resolver resolver,
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
  final testId = _testNumber++;
  test(description, skip: skip, timeout: timeout, () async {
    // Giving a unique name to the package to avoid the analyzer cache
    // messing up tests.
    final packageName = 'test_lib$testId';
    final sourceWithLibrary = 'library foo;$source';

    final enclosingZone = Zone.current;

    final otherSources = {
      for (final entry in files.entries)
        '$packageName|lib/${entry.key}':
            'library "${entry.key}"; ${entry.value}',
    };

    Future<(List<ResolvedUnitResult>, CompilationUnit)> getUnits(
      Resolver resolver,
    ) async {
      final lib = await resolver.findLibraryByName('foo');

      final ast = await lib!.session.getResolvedLibraryByElement2(lib);
      ast as ResolvedLibraryResult;

      return (
        ast.units,
        ast.units.firstWhere((e) => e.path.endsWith('foo.dart')).unit,
      );
    }

    final packageConfigUri = await Isolate.packageConfig;
    final packageConfig = PackageConfig.parseString(
      File.fromUri(packageConfigUri!).readAsStringSync(),
      packageConfigUri,
    );

    String? generated;
    if (runGenerator) {
      generated = await resolveSources(
        packageConfig: packageConfig,
        readAllSourcesFromFilesystem: true,
        {'$packageName|lib/foo.dart': sourceWithLibrary, ...otherSources},
        (resolver) async {
          final (units, _) = await getUnits(resolver);

          return RiverpodGenerator(
            const {},
          ).generateForUnit(units.map((e) => e.unit).toList());
        },
      );
    }

    await resolveSources(
      packageConfig: packageConfig,
      readAllSourcesFromFilesystem: true,
      {
        '$packageName|lib/foo.dart': sourceWithLibrary,
        if (generated != null)
          '$packageName|lib/foo.g.dart': 'part of "foo.dart";$generated',
        ...otherSources,
      },
      (resolver) async {
        try {
          final originalZone = Zone.current;
          return runZoned(
            () async {
              final (units, unit) = await getUnits(resolver);

              try {
                return await run(resolver, unit, units);
              } finally {
                collectErrors(() {
                  for (final unit in units) {
                    expectRiverpodAstOnlyHasASingleOptionPerNode(unit.unit);
                  }
                });
              }
            },
            zoneSpecification: ZoneSpecification(
              // Somehow prints are captured inside the callback. Let's restore them
              print: (self, parent, zone, line) => enclosingZone.print(line),
              handleUncaughtError: (self, parent, zone, error, stackTrace) {
                originalZone.handleUncaughtError(error, stackTrace);
                enclosingZone.handleUncaughtError(error, stackTrace);
              },
            ),
          );
        } catch (err, stack) {
          enclosingZone.handleUncaughtError(err, stack);
        }
      },
    );
  });
}

/// Asserts that no [AstNode] has to Riverpod ast.
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

        case NamedCompilationUnitMember():
          if (node.name.lexeme == name) return node as WhereNodeT;

        default:
          throw UnsupportedError('Unsupported node ${node.runtimeType}');
      }
    }

    throw StateError('No node found with name "$name"');
  }
}

extension ResolverX on Resolver {
  // ignore: invalid_use_of_internal_member
  Future<RiverpodAnalysisResult> resolveRiverpodAnalysisResult({
    String libraryName = 'foo',
    bool ignoreErrors = false,
  }) async {
    final library = await requireFindLibraryByName(
      libraryName,
      ignoreErrors: ignoreErrors,
    );

    final libraryAst = await library.session.getResolvedLibraryByElement2(
      library,
    );
    libraryAst as ResolvedLibraryResult;

    final compilerErrors = libraryAst.units
        .expand((e) => e.errors)
        .where((e) => e.severity == Severity.error)
        .toList();
    if (compilerErrors.isNotEmpty) {
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

  Future<LibraryElement2> requireFindLibraryByName(
    String libraryName, {
    required bool ignoreErrors,
  }) async {
    final library = await findLibraryByName(libraryName);
    if (library == null) {
      throw StateError('No library found for name "$libraryName"');
    }

    if (!ignoreErrors) {
      final errorResult = await library.session.getErrors(
        '/test_lib/lib/foo.dart',
      );
      errorResult as ErrorsResult;

      final errors = errorResult.errors
          // Infos are only recommendations. There's no reason to fail just for this
          .where((e) => e.severity != Severity.info)
          .toList();

      if (errors.isNotEmpty) {
        throw StateError('''
The parsed library has errors:
${errors.map((e) => '- $e\n').join()}
''');
      }
    }

    return library;
  }
}
