// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/src/internals.dart';
import 'package:flutter_test/flutter_test.dart';

class _Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

void main() {
  testWidgets('counter and dependent updates share a devtool frame', (
    tester,
  ) async {
    final devtool = RiverpodDevtool.instance;
    final notifications = spyPostEvent();
    final previousTracking = debugTrackProviderHistory;
    final container = ProviderContainer();
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox());
      container.dispose();
      await tester.pump();
      debugTrackProviderHistory = previousTracking;
      devtool.frames.clear();
      notifications.dispose();
    });
    debugTrackProviderHistory = true;
    final counter = NotifierProvider.autoDispose<_Counter, int>(
      _Counter.new,
      name: 'counterProvider',
    );
    final complex = Provider(
      (ref) => ref.watch(counter) * 2,
      name: 'complexProvider',
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, _) => Text(
            '${ref.watch(counter)}:${ref.watch(complex)}',
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('0:0'), findsOneWidget);
    final initialFrames = devtool.frames.length;
    notifications.logs.clear();

    for (var value = 1; value <= 2; value++) {
      container.read(counter.notifier).increment();
      await tester.idle();
      await tester.pump();
      expect(find.text('$value:${value * 2}'), findsOneWidget);
      expect(devtool.frames, hasLength(initialFrames + value));
      expect(notifications.logs, hasLength(1));
      final updates = devtool.frames.last.events
          .whereType<ProviderElementUpdateEvent>();
      expect(updates.map((event) => event.next.state), [value, value * 2]);
      notifications.logs.clear();
    }
  });
}
