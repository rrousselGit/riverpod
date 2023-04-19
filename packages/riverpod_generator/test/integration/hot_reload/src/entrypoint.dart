// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:hotreloader/hotreloader.dart';

const renderStart = '<<<<rendering>>>>';
const renderEnd = '<<<<done rendering>>>>';

Future<void> entrypoint(
  void Function() renderer,
) async {
  void run(void Function() cb) {
    try {
      print(renderStart);
      cb();
    } catch (err, stack) {
      print(err);
      print(stack);
    } finally {
      print(renderEnd);
    }
  }

  try {
    await HotReloader.create(
      onBeforeReload: (_) {
        return true;
      },
      onAfterReload: (value) {
        run(() {
          switch (value.result) {
            case HotReloadResult.Succeeded:
              renderer();
              break;
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
    stderr.addError(err, stack);
  }

  run(() => renderer());
}
