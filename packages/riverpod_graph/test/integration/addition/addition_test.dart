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
        // replace windows file separator with linux - make test pass on windows
        stdoutList.first.replaceAll(r'\', '/'),
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

  additionProvider[["additionProvider</br>&lt; num&gt;"]];
  normalProvider[["normalProvider</br>&lt; int&gt;"]];
  futureProvider[["futureProvider</br>&lt; int&gt;"]];
  familyProviders[["familyProviders</br>&lt; int, Object?&gt;"]];
  functionProvider[["functionProvider</br>&lt; int Function()&gt;"]];
  selectedProvider[["selectedProvider</br>&lt; int&gt;"]];
  subgraph SampleClass
    SampleClass.normalProvider[["normalProvider</br>&lt; int&gt;"]];
  end
  subgraph SampleClass
    SampleClass.futureProvider[["futureProvider</br>&lt; int&gt;"]];
  end
  subgraph SampleClass
    SampleClass.familyProviders[["familyProviders</br>&lt; int, Object?&gt;"]];
  end
  subgraph SampleClass
    SampleClass.functionProvider[["functionProvider</br>&lt; int Function()&gt;"]];
  end
  subgraph SampleClass
    SampleClass.selectedProvider[["selectedProvider</br>&lt; int&gt;"]];
  end
  marvelTearOffConsumer[["marvelTearOffConsumer</br>&lt; Null&gt;"]];
  marvelRefdProvider[["marvelRefdProvider</br>&lt; MarvelRepository&gt;"]];

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
  marvelRefdProvider -.-> marvelTearOffConsumer;''',
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
        // replace windows file separator with linux - make test pass on windows
        stdoutList.first.replaceAll(r'\', '/'),
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
        r'''
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

additionProvider: "additionProvider\n<num>"
additionProvider.shape: rectangle
additionProvider.tooltip: "A provider returning the sum of the other providers."
normalProvider: "normalProvider\n<int>"
normalProvider.shape: rectangle
normalProvider.tooltip: "A provider returning a number."
futureProvider: "futureProvider\n<int>"
futureProvider.shape: rectangle
futureProvider.tooltip: "A future provider returning a number."
familyProviders: "familyProviders\n<int, Object?>"
familyProviders.shape: rectangle
familyProviders.tooltip: "A family provider returning a number."
functionProvider: "functionProvider\n<int Function()>"
functionProvider.shape: rectangle
functionProvider.tooltip: "A provider returning a function that returns a number."
selectedProvider: "selectedProvider\n<int>"
selectedProvider.shape: rectangle
selectedProvider.tooltip: "A provider returning a number that will be selected."
SampleClass.normalProvider: "SampleClass.normalProvider\n<int>"
SampleClass.normalProvider.shape: rectangle
SampleClass.normalProvider.tooltip: "A provider returning a number."
SampleClass.futureProvider: "SampleClass.futureProvider\n<int>"
SampleClass.futureProvider.shape: rectangle
SampleClass.futureProvider.tooltip: "A future provider returning a number."
SampleClass.familyProviders: "SampleClass.familyProviders\n<int, Object?>"
SampleClass.familyProviders.shape: rectangle
SampleClass.familyProviders.tooltip: "A family provider returning a number."
SampleClass.functionProvider: "SampleClass.functionProvider\n<int Function()>"
SampleClass.functionProvider.shape: rectangle
SampleClass.functionProvider.tooltip: "A provider returning a function that returns a number."
SampleClass.selectedProvider: "SampleClass.selectedProvider\n<int>"
SampleClass.selectedProvider.shape: rectangle
SampleClass.selectedProvider.tooltip: "A provider returning a number that will be selected."
marvelTearOffConsumer: "marvelTearOffConsumer\n<Null>"
marvelTearOffConsumer.shape: rectangle
marvelTearOffConsumer.tooltip: "read/watch/listen seem to be required to bring this in scope for analysis"
marvelRefdProvider: "marvelRefdProvider\n<MarvelRepository>"
marvelRefdProvider.shape: rectangle
marvelRefdProvider.tooltip: "taken from the marvel example"

normalProvider -> additionProvider: {style.stroke-width: 4}
futureProvider -> additionProvider: {style.stroke-width: 4}
familyProviders -> additionProvider: {style.stroke-width: 4}
functionProvider -> additionProvider: {style.stroke-width: 4}
selectedProvider -> additionProvider: {style.stroke-width: 4}
SampleClass.normalProvider -> additionProvider: {style.stroke-width: 4}
SampleClass.futureProvider -> additionProvider: {style.stroke-width: 4}
SampleClass.familyProviders -> additionProvider: {style.stroke-width: 4}
SampleClass.functionProvider -> additionProvider: {style.stroke-width: 4}
SampleClass.selectedProvider -> additionProvider: {style.stroke-width: 4}
marvelRefdProvider -> marvelTearOffConsumer: {style.stroke-dash: 4}''',
        reason: 'It should log the riverpod graph',
      );
      await process.shouldExit(0);
    });
  });
}
