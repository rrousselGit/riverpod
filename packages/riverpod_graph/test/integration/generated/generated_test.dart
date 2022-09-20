import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
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
      stdoutList.first,
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
  nonGeneratedProvider2[[nonGeneratedProvider2]];
  nonGeneratedProvider ==> nonGeneratedProvider2;
  nonGeneratedProvider[[nonGeneratedProvider]];
  PublicClassProvider[[PublicClassProvider]];
  PublicProvider ==> PublicClassProvider;
  PublicProvider[[PublicProvider]];
  _PrivateClassProvider[[_PrivateClassProvider]];
  PublicProvider ==> _PrivateClassProvider;
  Supports$InClassNameProvider[[Supports$InClassNameProvider]];
  PublicProvider ==> Supports$InClassNameProvider;
  Supports$inNamesProvider[[Supports$inNamesProvider]];
  PublicProvider ==> Supports$inNamesProvider;
  _PrivateProvider[[_PrivateProvider]];
  PublicProvider ==> _PrivateProvider;''',
      reason: 'It should log the riverpod graph',
    );
    await process.shouldExit(0);
  });
}
