import 'package:build_verify/build_verify.dart';
import 'package:build_yaml/build_yaml.dart';
import 'package:test/test.dart';

void main() {
  test(
    'ensure_build',
    () => expectBuildClean(
      packageRelativeDirectory:
          'packages/riverpod_generator/examples/build_yaml',
    ),
  );

  test('provider names', () {
    expect(countPod.name, 'countPod');
    expect(countFuturePod.name, 'countFuturePod');
    expect(countNotifierPod.name, 'countNotifierPod');
    expect(countAsyncNotifierPod.name, 'countAsyncNotifierPod');
  });
}
