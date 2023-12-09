// import 'package:riverpod/riverpod.dart';
// import 'package:riverpod/src/provider.dart';
// import 'package:test/test.dart';

// import '../matchers.dart';

void main() {
  // late PostEventSpy spy;

  // setUp(() {
  //   spy = spyPostEvent();
  // });

  // tearDown(() => spy.dispose());

  // test('calls postEvent whenever a provider is updated', () {
  //   expect(RiverpodBinding.debugInstance.containers, isEmpty);
  //   expect(spy.logs, isEmpty);

  //   final container = ProviderContainer();
  //   addTearDown(container.dispose);

  //   final provider = StateProvider((ref) => 42);

  //   final state = container.read(provider);
  //   spy.logs.clear();

  //   expect(spy.logs, isEmpty);

  //   state.state++;

  //   expect(
  //     spy.logs,
  //     [
  //       isPostEventCall('riverpod:provider_changed', {
  //         'container_id': container.debugId,
  //         'provider_id': provider.debugId,
  //       }),
  //     ],
  //   );
  //   spy.logs.clear();
  // });

  // test('RiverpodBinding contains the list of ProviderContainers', () {
  //   expect(RiverpodBinding.debugInstance.containers, isEmpty);
  //   expect(spy.logs, isEmpty);

  //   final first = ProviderContainer();

  //   expect(
  //     spy.logs,
  //     [isPostEventCall('riverpod:container_list_changed', isEmpty)],
  //   );
  //   spy.logs.clear();
  //   expect(
  //     RiverpodBinding.debugInstance.containers,
  //     {first.debugId: first},
  //   );

  //   final second = ProviderContainer();

  //   expect(
  //     spy.logs,
  //     [isPostEventCall('riverpod:container_list_changed', isEmpty)],
  //   );
  //   spy.logs.clear();
  //   expect(
  //     RiverpodBinding.debugInstance.containers,
  //     {first.debugId: first, second.debugId: second},
  //   );

  //   first.dispose();

  //   expect(
  //     spy.logs,
  //     [isPostEventCall('riverpod:container_list_changed', isEmpty)],
  //   );
  //   spy.logs.clear();
  //   expect(
  //     RiverpodBinding.debugInstance.containers,
  //     {second.debugId: second},
  //   );

  //   second.dispose();

  //   expect(
  //     spy.logs,
  //     [isPostEventCall('riverpod:container_list_changed', isEmpty)],
  //   );
  //   spy.logs.clear();
  //   expect(RiverpodBinding.debugInstance.containers, isEmpty);
  // });

  // test(
  //     'ProviderContainer calls postEvent whenever it mounts/unmount a provider',
  //     () async {
  //   final container = ProviderContainer();
  //   addTearDown(container.dispose);
  //   spy.logs.clear();

  //   final provider = Provider.autoDispose((ref) => 0);
  //   final provider2 = Provider((ref) => 0);

  //   expect(spy.logs, isEmpty);

  //   var sub = container.listen(provider, (_) {});

  //   expect(
  //     spy.logs,
  //     [
  //       isPostEventCall(
  //         'riverpod:provider_list_changed',
  //         <Object?, Object?>{'container_id': container.debugId},
  //       )
  //     ],
  //   );
  //   spy.logs.clear();

  //   var sub2 = container.listen(provider2, (_) {});

  //   expect(
  //     spy.logs,
  //     [
  //       isPostEventCall(
  //         'riverpod:provider_list_changed',
  //         <Object?, Object?>{'container_id': container.debugId},
  //       )
  //     ],
  //   );
  //   spy.logs.clear();

  //   sub.close();

  //   expect(spy.logs, isEmpty);
  //   await Future.value(null);

  //   expect(
  //     spy.logs,
  //     [
  //       isPostEventCall(
  //         'riverpod:provider_list_changed',
  //         <Object?, Object?>{'container_id': container.debugId},
  //       )
  //     ],
  //   );
  //   spy.logs.clear();

  //   sub2.close();
  //   await Future.value(null);

  //   expect(spy.logs, isEmpty);
  //   await Future.value(null);

  //   expect(spy.logs, isEmpty, reason: 'provider2 is not autoDispose');

  //   // re-subscribe to the provider that was unmounted
  //   sub = container.listen(provider, (_) {});

  //   expect(
  //     spy.logs,
  //     [
  //       isPostEventCall(
  //         'riverpod:provider_list_changed',
  //         <Object?, Object?>{'container_id': container.debugId},
  //       )
  //     ],
  //   );
  //   spy.logs.clear();

  //   // re-subscribe to the provider that was no longer listened to but still mounted
  //   sub2 = container.listen(provider2, (_) {});

  //   expect(spy.logs, isEmpty);
  // });
}
