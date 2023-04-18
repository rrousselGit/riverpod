import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../project_utils.dart';

const _renderStart = '<<<<rendering>>>>';
const _renderEnd = '<<<<done rendering>>>>';

class HotReloadRunner {
  HotReloadRunner._(this._workspace);

  static Future<HotReloadRunner> start({
    required String renderer,
    required String providers,
  }) async {
    final tempDir = createTempDir();
    final workspace = tempDir.dir('hot_reload_test');

    final runner = HotReloadRunner._(workspace);
    addTearDown(runner.close);

    runner
      .._writeMain()
      .._writeRenderer(renderer)
      .._writeProviders(providers)
      .._writePubspec();

    // await runner._flutterCreate();
    await runner._pubGet();
    await runner._runGenerator();

    runner._process = Process.start(
      'dart',
      [
        '--enable-vm-service',
        workspace.file('lib', 'main.dart').path,
      ],
      workingDirectory: workspace.path,
    );

    await runner._listenToOutput();

    return runner;
  }

  final Directory _workspace;
  Future<Process>? _process;

  final _onClose = <Future<void> Function()>[];

  final _renderController = StreamController<String>();
  late final currentRender = StreamQueue<String>(_renderController.stream);

  Future<void> update({String? renderer, String? providers}) async {
    assert(renderer != null || providers != null, 'Nothing to update');

    if (renderer != null) {
      _writeRenderer(renderer);
    }
    if (providers != null) {
      _writeProviders(providers);
      await _runGenerator();
    }

    await _performHotReload();
  }

  Future<void> _listenToOutput() {
    StringBuffer? _pendingRenderBuffer;

    return _process!.then((process) {
      // Folds <rendering>{...}</done rendering> in a single String event.
      // Any stdout event outside of those tags is ignored.
      // Errors are forwarded as-is.

      final outSub = process.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .map((e) => e.startsWith('flutter: ') ? e.substring(9) : e)
          .listen((line) {
        print('Received line: `$line`');
        if (line.contains(_renderStart)) {
          _pendingRenderBuffer = StringBuffer();
        } else if (line.contains(_renderEnd)) {
          final render = _pendingRenderBuffer!.toString();
          _pendingRenderBuffer = null;
          _renderController.add(render);
        } else {
          _pendingRenderBuffer?.write(line);
        }
      });
      _onClose.add(outSub.cancel);

      void onError(Object event) {
        print('Error: $event');
        _renderController.addError(event);
      }

      final errSub = process.stderr.transform(utf8.decoder).listen(onError);
      _onClose.add(errSub.cancel);
    });
  }

  Future<void> _performHotReload() async {
    final process = await _process;
    if (process == null) {
      throw StateError('Process not started');
    }

    process.stdin.writeln('r');
  }

  void _writeMain() {
    const main = '''
import 'package:riverpod/riverpod.dart';
import 'package:hotreloader/hotreloader.dart';
import 'providers.dart';
import 'renderer.dart';

Future<void> main() async {
  void run(ProviderContainer container) {
    try {
      print('$_renderStart');
      renderer(container);
    } finally {
      print('$_renderEnd');
    }
  }

  final container = ProviderContainer();

  run(container);

  await HotReloader.create(
    onAfterReload: (value) {
      run(container);
    },
  );

}
''';

    writeFile(_workspace.file('lib', 'main.dart'), main);
  }

  void _writeRenderer(String renderer) {
    writeFile(_workspace.file('lib', 'renderer.dart'), '''
import 'package:riverpod/riverpod.dart';

import 'providers.dart';

void renderer(ProviderContainer container) {
  $renderer
} 
''');
  }

  void _writeProviders(String providers) {
    writeFile(
      _workspace.file('lib', 'providers.dart'),
      providers,
    );
  }

  void _writePubspec() {
    writeFile(
      _workspace.pubspec,
      '''
name: hot_reload_test
environment:
  sdk: ">=2.18.0 <3.0.0"

dependencies:
  riverpod:
  riverpod_annotation:
  hotreloader:

dev_dependencies:
  build_runner:
  riverpod_generator:

dependency_overrides:
  riverpod:
    path: ../../../../riverpod
  riverpod_annotation:
    path: ../../../../riverpod_annotation
  riverpod_generator:
    path: ../../../../riverpod_generator
''',
    );
  }

  Future<void> _flutterCreate() async {
    final result = await Process.run(
      'flutter',
      ['create', '.', '--platforms=macos'],
      workingDirectory: _workspace.path,
    );

    if (result.exitCode != 0) {
      throw StateError('_flutterCreate failed: ${result.stderr}');
    }
  }

  Future<void> _runGenerator() async {
    final result = await Process.run(
      'dart',
      ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      workingDirectory: _workspace.path,
    );

    if (result.exitCode != 0) {
      throw StateError(
        '_runGenerator failed:\n${result.stderr}\n${result.stdout}',
      );
    }
  }

  Future<void> _pubGet() async {
    final result = await Process.run(
      'dart',
      ['pub', 'get', '--offline'],
      workingDirectory: _workspace.path,
    );

    if (result.exitCode != 0) {
      throw StateError('_pubGet failed: ${result.stderr}');
    }
  }

  Future<void> close() async {
    try {
      print('closing');
      await Future.wait(_onClose.map((it) => it()));

      print('closing2');
      await _process?.then((process) {
        print('kill');
        return process.kill();
      });
    } finally {
      await _renderController.close();
      // workspace dir is deleted by the test framework
    }
  }
}

void main() {
  test(
      timeout: const Timeout.factor(2),
      'Supports adding/removing family parameters', () async {
    final runner = await HotReloadRunner.start(
      renderer:
          'print(container.listen(fnProvider(id: 0), (_, __) {}).read());',
      providers: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
String fn(FnRef ref, {required int id}) => 'id: $id';
''',
    );

    print('starting');

    expect(await runner.currentRender.next, 'id: 0');
    print('got id: 0');

    await runner.update(
      renderer:
          'print(container.listen(fnProvider(id2: 0), (_, __) {}).read());',
      providers: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'providers.g.dart';

@riverpod
String fn(FnRef ref, {required int id2}) => 'id2: $id2';
''',
    );

    print('got id2: 0');
    expect(await runner.currentRender.next, 'id2: 0');
    print('closing');
    await runner.close();

    print('waiting for done');
    expect(runner.currentRender.rest, emitsDone);
  });

  test(
    'Updates providers if they ref.watch a provider which changed Element',
    () {},
  );

  test(
    'Updates providers if they ref.listen a provider which changed Element',
    () {},
  );

  test('Preserves the state of unedited providers', () {});

  test('Supports switching in/out family', () {});

  test('Supports enabling/disabling autoDispose', () {});

  test('Supports changing the runtimeType', () {});
}
