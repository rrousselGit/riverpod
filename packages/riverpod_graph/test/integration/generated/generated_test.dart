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

  supports$inNamesProvider[["supports$inNamesProvider</br>AutoDisposeProvider&lt; String&gt;"]];
  publicProvider[["publicProvider</br>AutoDisposeProvider&lt; String&gt;"]];
  familyProvider[["familyProvider</br>FamilyFamily"]];
  _privateProvider[["_privateProvider</br>AutoDisposeProvider&lt; String&gt;"]];
  publicClassProvider[["publicClassProvider</br>AutoDisposeNotifierProviderImpl&lt; PublicClass, String&gt;"]];
  _privateClassProvider[["_privateClassProvider</br>AutoDisposeNotifierProviderImpl&lt; _PrivateClass, String&gt;"]];
  familyClassProvider[["familyClassProvider</br>FamilyClassFamily"]];
  supports$InClassNameProvider[["supports$InClassNameProvider</br>AutoDisposeNotifierProviderImpl&lt; Supports$InClassName, String&gt;"]];

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

supports$inNamesProvider: "supports$inNamesProvider\nAutoDisposeProvider<String>"
supports$inNamesProvider.shape: rectangle
publicProvider: "publicProvider\nAutoDisposeProvider<String>"
publicProvider.shape: rectangle
familyProvider: "familyProvider\nFamilyFamily"
familyProvider.shape: rectangle
_privateProvider: "_privateProvider\nAutoDisposeProvider<String>"
_privateProvider.shape: rectangle
publicClassProvider: "publicClassProvider\nAutoDisposeNotifierProviderImpl<PublicClass, String>"
publicClassProvider.shape: rectangle
_privateClassProvider: "_privateClassProvider\nAutoDisposeNotifierProviderImpl<_PrivateClass, String>"
_privateClassProvider.shape: rectangle
familyClassProvider: "familyClassProvider\nFamilyClassFamily"
familyClassProvider.shape: rectangle
supports$InClassNameProvider: "supports$InClassNameProvider\nAutoDisposeNotifierProviderImpl<Supports$InClassName, String>"
supports$InClassNameProvider.shape: rectangle

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
