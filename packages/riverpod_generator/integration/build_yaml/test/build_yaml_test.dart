import 'package:build_verify/build_verify.dart';
import 'package:build_yaml/main.dart';
import 'package:test/test.dart';

void main() {
  test(
    'ensure_build',
    () => expectBuildClean(
      packageRelativeDirectory:
          'packages/riverpod_generator/integration/build_yaml',
    ),
    timeout: const Timeout(Duration(minutes: 1)),
  );

  test('provider names', () {
    expect(countPod.name, 'countPod');
    expect(countFuturePod.name, 'countFuturePod');
    expect(countStreamPod.name, 'countStreamPod');
    expect(countNotifierPod.name, 'countNotifierPod');
    expect(countAsyncNotifierPod.name, 'countAsyncNotifierPod');
    expect(countStreamNotifierPod.name, 'countStreamNotifierPod');
  });

  test('provider family names', () {
    expect(count2ProviderFamily.name, 'count2ProviderFamily');
    expect(countFuture2ProviderFamily.name, 'countFuture2ProviderFamily');
    expect(countStream2ProviderFamily.name, 'countStream2ProviderFamily');
    expect(countNotifier2ProviderFamily.name, 'countNotifier2ProviderFamily');
    expect(
      countAsyncNotifier2ProviderFamily.name,
      'countAsyncNotifier2ProviderFamily',
    );
    expect(
      countStreamNotifier2ProviderFamily.name,
      'countStreamNotifier2ProviderFamily',
    );
  });
}
