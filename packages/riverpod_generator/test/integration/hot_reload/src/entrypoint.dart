// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:hotreloader/hotreloader.dart';
import 'package:riverpod/riverpod.dart';

const renderStart = '<<<<rendering>>>>';
const renderEnd = '<<<<done rendering>>>>';

Future<void> entrypoint(
  void Function(ProviderContainer container) renderer,
) async {
  final container = ProviderContainer();
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
              renderer(container);
              break;
            default:
              print('Hey ${value.reloadReports.length}');
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

  run(() => renderer(container));
}
