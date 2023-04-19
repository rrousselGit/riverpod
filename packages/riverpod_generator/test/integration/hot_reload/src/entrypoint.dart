// ignore_for_file: avoid_print

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

  run(() => renderer(container));

  await HotReloader.create(
    onBeforeReload: (_) {
      print('Before reload');
      return true;
    },
    onAfterReload: (value) {
      run(() {
        print('After reload');
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
}
