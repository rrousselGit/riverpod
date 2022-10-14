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
  publicClassProvider[[publicClassProvider]];
  publicProvider ==> publicClassProvider;
  publicProvider[[publicProvider]];
  _privateClassProvider[[_privateClassProvider]];
  publicProvider ==> _privateClassProvider;
  familyClassProvider[[familyClassProvider]];
  publicProvider ==> familyClassProvider;
  supports$InClassNameProvider[[supports$InClassNameProvider]];
  publicProvider ==> supports$InClassNameProvider;
  supports$inNamesProvider[[supports$inNamesProvider]];
  publicProvider ==> supports$inNamesProvider;
  familyProvider[[familyProvider]];
  publicProvider ==> familyProvider;
  _privateProvider[[_privateProvider]];
  publicProvider ==> _privateProvider;''',
      reason: 'It should log the riverpod graph',
    );
    await process.shouldExit(0);
  });
}
