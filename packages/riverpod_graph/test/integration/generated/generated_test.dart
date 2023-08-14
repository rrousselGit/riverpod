import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  group('mermaid format', () {
    // TODO(ValentinVignal): Support the generated families.
    test('It should log the structure of the generated project', () async {
      final process = await TestProcess.start(
        'dart',
        const [
          'run',
          'riverpod_graph',
          'test/integration/generated/golden',
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
              'packages/riverpod_graph/test/integration/generated/golden ...',
            ),
          ],
        ),
        reason: 'It should log the analyzed folder',
      );

      expect(
        stdoutList.sublist(1).join('\n'),
        r'''
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

  supports$inNamesProvider[["supports$inNamesProvider"]];
  publicProvider[["publicProvider"]];
  familyProvider[["familyProvider"]];
  _privateProvider[["_privateProvider"]];
  publicClassProvider[["publicClassProvider"]];
  _privateClassProvider[["_privateClassProvider"]];
  familyClassProvider[["familyClassProvider"]];
  supports$InClassNameProvider[["supports$InClassNameProvider"]];

  publicProvider ==> supports$inNamesProvider;
  publicProvider ==> familyProvider;
  publicProvider ==> _privateProvider;
  publicProvider ==> publicClassProvider;
  publicProvider ==> _privateClassProvider;
  publicProvider ==> familyClassProvider;
  publicProvider ==> supports$InClassNameProvider;''',
        reason: 'It should log the riverpod graph',
      );
      await process.shouldExit(0);
    });
  });
  group('d2 format', () {
    test('It should log the structure of the generated project', () async {
      final process = await TestProcess.start(
        'dart',
        const [
          'run',
          'riverpod_graph',
          'test/integration/generated/golden',
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
              'packages/riverpod_graph/test/integration/generated/golden ...',
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

supports$inNamesProvider: "supports$inNamesProvider"
supports$inNamesProvider.shape: rectangle
supports$inNamesProvider.tooltip: "A generated provider with a '$' in its name."
publicProvider: "publicProvider"
publicProvider.shape: rectangle
publicProvider.tooltip: "A public generated provider."
familyProvider: "familyProvider"
familyProvider.shape: rectangle
familyProvider.tooltip: "A generated family provider."
_privateProvider: "_privateProvider"
_privateProvider.shape: rectangle
_privateProvider.tooltip: "See also [_private]."
publicClassProvider: "publicClassProvider"
publicClassProvider.shape: rectangle
publicClassProvider.tooltip: "A generated public provider from a class"
_privateClassProvider: "_privateClassProvider"
_privateClassProvider.shape: rectangle
_privateClassProvider.tooltip: "See also [_PrivateClass]."
familyClassProvider: "familyClassProvider"
familyClassProvider.shape: rectangle
familyClassProvider.tooltip: "A generated family provider from a class."
supports$InClassNameProvider: "supports$InClassNameProvider"
supports$InClassNameProvider.shape: rectangle
supports$InClassNameProvider.tooltip: "A generated provider from a class with a '$' in its name."

publicProvider -> supports$inNamesProvider: {style.stroke-width: 4}
publicProvider -> familyProvider: {style.stroke-width: 4}
publicProvider -> _privateProvider: {style.stroke-width: 4}
publicProvider -> publicClassProvider: {style.stroke-width: 4}
publicProvider -> _privateClassProvider: {style.stroke-width: 4}
publicProvider -> familyClassProvider: {style.stroke-width: 4}
publicProvider -> supports$InClassNameProvider: {style.stroke-width: 4}''',
        reason: 'It should log the riverpod graph',
      );
      await process.shouldExit(0);
    });
  });
}
