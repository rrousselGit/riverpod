import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  group('mermaid format', () {
    test('It should log the structure of the consumer_widget project',
        () async {
      final process = await TestProcess.start(
        'dart',
        const [
          'run',
          'riverpod_graph',
          'test/integration/consumer_widget/golden',
        ],
      );

      final stdoutList = <String>[];
      while (await process.stdout.hasNext) {
        stdoutList.add(await process.stdout.next);
      }

      expect(
        // replace windows file separator with linux - make test pass on windows
        stdoutList.first.replaceAll(r'\', '/'),
        allOf(
          [
            startsWith('Analyzing'),
            endsWith(
              'packages/riverpod_graph/test/integration/consumer_widget/golden ...',
            ),
          ],
        ),
        reason: 'It should log the analyzed folder',
      );

      expect(
        stdoutList.sublist(1).join('\n'),
        '''
flowchart TB
  subgraph Arrows
    direction LR
    start1[ ] -..->|read| stop1[ ]
    style start1 height:0px;
    style stop1 height:0px;
    start2[ ] --->|listen| stop2[ ]
    style start2 height:0px;
    style stop2 height:0px;
    start3[ ] ===>|watch| stop3[ ]
    style start3 height:0px;
    style stop3 height:0px;
  end
  subgraph Type
    direction TB
    ConsumerWidget((widget));
    Provider[[provider]];
  end

  counterProvider[["counterProvider"]];
  CounterWidget((CounterWidget));

  counterProvider ==> CounterWidget;
  counterProvider -.-> CounterWidget;''',
        reason: 'It should log the riverpod graph',
      );
      await process.shouldExit(0);
    });
  });
  group('D2 format', () {
    test('It should log the structure of the consumer_widget project',
        () async {
      final process = await TestProcess.start(
        'dart',
        const [
          'run',
          'riverpod_graph',
          'test/integration/consumer_widget/golden',
          '-f',
          'd2',
        ],
      );

      final stdoutList = <String>[];
      while (await process.stdout.hasNext) {
        stdoutList.add(await process.stdout.next);
      }

      expect(
        // replace windows file separator with linux - make test pass on windows
        stdoutList.first.replaceAll(r'\', '/'),
        allOf(
          [
            startsWith('Analyzing'),
            endsWith(
              'packages/riverpod_graph/test/integration/consumer_widget/golden ...',
            ),
          ],
        ),
        reason: 'It should log the analyzed folder',
      );

      expect(
        stdoutList.sublist(1).join('\n'),
        '''
Legend: {
  Type: {
    Widget.shape: circle
    Provider: rectangle
  }
  Arrows: {
    "." -> "..": read: {style.stroke-dash: 4}
    "." -> "..": listen
    "." -> "..": watch: {style.stroke-width: 4}
  }
}

counterProvider: "counterProvider"
counterProvider.shape: rectangle
counterProvider.tooltip: "Counter provider."
CounterWidget.shape: circle
CounterWidget.tooltip: "Counter widget."

counterProvider -> CounterWidget: {style.stroke-width: 4}
counterProvider -> CounterWidget: {style.stroke-dash: 4}''',
        reason: 'It should log the riverpod graph',
      );
      await process.shouldExit(0);
    });
  });
}
