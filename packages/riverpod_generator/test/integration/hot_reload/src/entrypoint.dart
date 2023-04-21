// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:hotreloader/hotreloader.dart';

const renderStart = '<<<<rendering>>>>';
const renderEnd = '<<<<done rendering>>>>';

Future<void> _run(FutureOr<void> Function() cb) async {
  try {
    print(renderStart);
    await cb();
  } catch (err, stack) {
    print(err);
    print(stack);
  } finally {
    print(renderEnd);
  }
}

Future<void> entrypoint(FutureOr<void> Function() renderer) async {
  try {
    await HotReloader.create(
      onAfterReload: (value) async {
        await _run(() {
          switch (value.result) {
            case HotReloadResult.Succeeded:
              return renderer();
            default:
              print('Error ${value.reloadReports.length}');
              for (final report in value.reloadReports.entries) {
                print(report.value.json);
              }
              break;
          }
        });
      },
    );
  } catch (err, stack) {
    stderr.writeln(err);
    stderr.writeln(stack);
  }

  await _run(renderer);
}
