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

  additionProvider[["additionProvider</br>FutureProvider&lt; num&gt;"]];
  normalProvider[["normalProvider</br>Provider&lt; int&gt;"]];
  futureProvider[["futureProvider</br>FutureProvider&lt; int&gt;"]];
  familyProviders[["familyProviders</br>ProviderFamily&lt; int, Object?&gt;"]];
  functionProvider[["functionProvider</br>Provider&lt; int Function()&gt;"]];
  selectedProvider[["selectedProvider</br>Provider&lt; int&gt;"]];
  subgraph SampleClass
    SampleClass.normalProvider[["normalProvider</br>Provider&lt; int&gt;"]];
  end
  subgraph SampleClass
    SampleClass.futureProvider[["futureProvider</br>FutureProvider&lt; int&gt;"]];
  end
  subgraph SampleClass
    SampleClass.familyProviders[["familyProviders</br>ProviderFamily&lt; int, Object?&gt;"]];
  end
  subgraph SampleClass
    SampleClass.functionProvider[["functionProvider</br>Provider&lt; int Function()&gt;"]];
  end
  subgraph SampleClass
    SampleClass.selectedProvider[["selectedProvider</br>Provider&lt; int&gt;"]];
  end
  marvelTearOffConsumer[["marvelTearOffConsumer</br>Provider&lt; Null&gt;"]];
  marvelRefdProvider[["marvelRefdProvider</br>Provider&lt; MarvelRepository&gt;"]];

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

additionProvider: "additionProvider\nFutureProvider<num>"
additionProvider.shape: rectangle
normalProvider: "normalProvider\nProvider<int>"
normalProvider.shape: rectangle
futureProvider: "futureProvider\nFutureProvider<int>"
futureProvider.shape: rectangle
familyProviders: "familyProviders\nProviderFamily<int, Object?>"
familyProviders.shape: rectangle
functionProvider: "functionProvider\nProvider<int Function()>"
functionProvider.shape: rectangle
selectedProvider: "selectedProvider\nProvider<int>"
selectedProvider.shape: rectangle
SampleClass.normalProvider: "SampleClass.normalProvider\nProvider<int>"
SampleClass.normalProvider.shape: rectangle
SampleClass.futureProvider: "SampleClass.futureProvider\nFutureProvider<int>"
SampleClass.futureProvider.shape: rectangle
SampleClass.familyProviders: "SampleClass.familyProviders\nProviderFamily<int, Object?>"
SampleClass.familyProviders.shape: rectangle
SampleClass.functionProvider: "SampleClass.functionProvider\nProvider<int Function()>"
SampleClass.functionProvider.shape: rectangle
SampleClass.selectedProvider: "SampleClass.selectedProvider\nProvider<int>"
SampleClass.selectedProvider.shape: rectangle
marvelTearOffConsumer: "marvelTearOffConsumer\nProvider<Null>"
marvelTearOffConsumer.shape: rectangle
marvelRefdProvider: "marvelRefdProvider\nProvider<MarvelRepository>"
marvelRefdProvider.shape: rectangle

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
