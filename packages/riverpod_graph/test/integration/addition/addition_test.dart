import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  group('mermaid format', () {
    test('It should log the structure of the addition project', () async {
      final process = await TestProcess.start(
        'dart',
        const ['run', 'riverpod_graph', 'test/integration/addition/golden'],
      );

      final stdoutList = <String>[];
      while (await process.stdout.hasNext) {
        stdoutList.add(await process.stdout.next);
      }

      expect(
        stdoutList.first,
        allOf(
          [
            startsWith('Analyzing'),
            endsWith(
              'packages/riverpod_graph/test/integration/addition/golden ...',
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
  additionProvider[[additionProvider]];
  normalProvider ==> additionProvider;
  futureProvider ==> additionProvider;
  familyProviders ==> additionProvider;
  functionProvider ==> additionProvider;
  selectedProvider ==> additionProvider;
  SampleClass.normalProvider ==> additionProvider;
  SampleClass.futureProvider ==> additionProvider;
  SampleClass.familyProviders ==> additionProvider;
  SampleClass.functionProvider ==> additionProvider;
  SampleClass.selectedProvider ==> additionProvider;
  normalProvider[[normalProvider]];
  futureProvider[[futureProvider]];
  familyProviders[[familyProviders]];
  functionProvider[[functionProvider]];
  selectedProvider[[selectedProvider]];
  subgraph SampleClass
    SampleClass.normalProvider[[normalProvider]];
  end
  subgraph SampleClass
    SampleClass.futureProvider[[futureProvider]];
  end
  subgraph SampleClass
    SampleClass.familyProviders[[familyProviders]];
  end
  subgraph SampleClass
    SampleClass.functionProvider[[functionProvider]];
  end
  subgraph SampleClass
    SampleClass.selectedProvider[[selectedProvider]];
  end''',
        reason: 'It should log the riverpod graph',
      );
      await process.shouldExit(0);
    });
  });
  group('d2 format', () {
    test('It should log the structure of the addition project', () async {
      final process = await TestProcess.start(
        'dart',
        const [
          'run',
          'riverpod_graph',
          'test/integration/addition/golden',
          '-f',
          'd2',
        ],
      );

      final stdoutList = <String>[];
      while (await process.stdout.hasNext) {
        stdoutList.add(await process.stdout.next);
      }

      expect(
        stdoutList.first,
        allOf(
          [
            startsWith('Analyzing'),
            endsWith(
              'packages/riverpod_graph/test/integration/addition/golden ...',
            ),
          ],
        ),
        reason: 'It should log the analyzed folder',
      );

      expect(
        stdoutList.sublist(1).join('\n'),
        '''
normalProvider -> additionProvider: {style.stroke-width: 4}
futureProvider -> additionProvider: {style.stroke-width: 4}
familyProviders -> additionProvider: {style.stroke-width: 4}
functionProvider -> additionProvider: {style.stroke-width: 4}
selectedProvider -> additionProvider: {style.stroke-width: 4}
SampleClass.normalProvider -> additionProvider: {style.stroke-width: 4}
SampleClass.futureProvider -> additionProvider: {style.stroke-width: 4}
SampleClass.familyProviders -> additionProvider: {style.stroke-width: 4}
SampleClass.functionProvider -> additionProvider: {style.stroke-width: 4}
SampleClass.selectedProvider -> additionProvider: {style.stroke-width: 4}''',
        reason: 'It should log the riverpod graph',
      );
      await process.shouldExit(0);
    });
  });
}
