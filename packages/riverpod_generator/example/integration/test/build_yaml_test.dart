import 'package:build_verify/build_verify.dart';
import 'package:integration/main.dart';
import 'package:test/test.dart';

void main() {
  test(
    'ensure_build',
    () => expectBuildClean(
      packageRelativeDirectory:
          'packages/riverpod_generator/examples/build_yaml',
    ),
    timeout: const Timeout(Duration(minutes: 1)),
  );

  test('provider names', () {
    expect(countPod.name, 'countPod');
    expect(countFuturePod.name, 'countFuturePod');
    expect(countNotifierPod.name, 'countNotifierPod');
    expect(countAsyncNotifierPod.name, 'countAsyncNotifierPod');
  });
}
