import 'dart:io';

import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  test('It should log the structure of the addition project', () async {
    await Process.run(
      'flutter',
      const ['pub', 'get', '../../examples/counter'],
    );
    final process = await TestProcess.start(
      'dart',
      const ['run', 'riverpod_graph', '../../examples/counter'],
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
          endsWith('examples/counter ...'),
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
  Home((Home));
  counterProvider ==> Home;
  counterProvider -.-> Home;
  counterProvider[[counterProvider]];''',
      reason: 'It should log the riverpod graph',
    );
    await process.shouldExit(0);
  });
}
