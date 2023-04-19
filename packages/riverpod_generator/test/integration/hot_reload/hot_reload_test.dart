import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

import '../../project_utils.dart';
import 'src/entrypoint.dart';

final hotReloadDir = Directory.current.dir('test/integration/hot_reload');
final srcDir = hotReloadDir.dir('src');

class HotReloadRunner {
  HotReloadRunner._(this._workspace);

  static Future<HotReloadRunner> start(
    File renderer,
  ) async {
    final runner = HotReloadRunner._(srcDir);
    addTearDown(runner.close);

    runner
      .._writeMain()
      .._writeRenderer(renderer);

    runner._process = Process.start(
      'dart',
      [
        '--enable-vm-service',
        srcDir.file('main.dart').path,
      ],
      // No workingDirection as hotReloader expects to be run from the root
      // of the project.
    );

    await runner._listenToOutput();

    return runner;
  }

  final Directory _workspace;
  Future<Process>? _process;

  final _onClose = <Future<void> Function()>[];

  final _renderController = StreamController<String>();
  late final currentRender = StreamQueue<String>(_renderController.stream);

  void _writeMain() {
    writeFile(
      _workspace.file('main.dart'),
      '''
import 'renderer.dart';
import 'entrypoint.dart';

void main() {
  entrypoint(renderer);
}
''',
    );
  }

  void _writeRenderer(File renderer) {
    final fileName = basenameWithoutExtension(renderer.path);

    final partRegex = RegExp(r'^part .+$', multiLine: true);

    writeFile(
      _workspace.file('renderer.dart'),
      renderer
          .readAsStringSync()
          .replaceAll(partRegex, "part 'renderer.g.dart';"),
    );

    writeFile(
      _workspace.file('renderer.g.dart'),
      renderer.parent
          .file('$fileName.g.dart')
          .readAsStringSync()
          .replaceAll(partRegex, "part of 'renderer.dart';"),
    );
  }

  void update(File renderer) {
    _writeRenderer(renderer);
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
        print('Output $line');
        if (line.contains(renderStart)) {
          _pendingRenderBuffer = StringBuffer();
        } else if (line.contains(renderEnd)) {
          final render = _pendingRenderBuffer!.toString();
          _pendingRenderBuffer = null;
          _renderController.add(render);
        } else {
          if (_pendingRenderBuffer?.isEmpty ?? false) {
            _pendingRenderBuffer?.write(line);
          } else {
            _pendingRenderBuffer?.write('\n$line');
          }
        }
      });
      _onClose.add(outSub.cancel);

      void onError(Object event) {
        print('Err $event');
        _renderController.addError(event);
      }

      final errSub = process.stderr.transform(utf8.decoder).listen(onError);
      _onClose.add(errSub.cancel);
    });
  }

  Future<void> close() async {
    try {
      await Future.wait(_onClose.map((it) => it()));

      await _process?.then((process) => process.kill());
    } finally {
      unawaited(currentRender.cancel());
      await _renderController.close();
      // workspace dir is deleted by the test framework
    }
  }
}

void main() {
  test(
      timeout: const Timeout.factor(2),
      'Supports adding/removing family parameters', () async {
    final familyParamDir = srcDir.dir('family_param');

    final runner = await HotReloadRunner.start(
      familyParamDir.file('step1.dart'),
    );

    print('Wait for id: 0');
    expect(await runner.currentRender.next, 'id: 0');

    runner.update(familyParamDir.file('step2.dart'));

    print('Wait for id2: 0');
    expect(await runner.currentRender.next, 'id2: 0');
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
