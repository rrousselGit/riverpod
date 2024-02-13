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
    expect(countPod.name, 'myCountPod');
    expect(countFuturePod.name, 'myCountFuturePod');
    expect(countStreamPod.name, 'myCountStreamPod');
    expect(countNotifierPod.name, 'myCountNotifierPod');
    expect(countAsyncNotifierPod.name, 'myCountAsyncNotifierPod');
    expect(countStreamNotifierPod.name, 'myCountStreamNotifierPod');
  });

  test('provider family names', () {
    expect(count2ProviderFamily.name, 'myFamilyCount2ProviderFamily');
    expect(
      countFuture2ProviderFamily.name,
      'myFamilyCountFuture2ProviderFamily',
    );
    expect(
      countStream2ProviderFamily.name,
      'myFamilyCountStream2ProviderFamily',
    );
    expect(
      countNotifier2ProviderFamily.name,
      'myFamilyCountNotifier2ProviderFamily',
    );
    expect(
      countAsyncNotifier2ProviderFamily.name,
      'myFamilyCountAsyncNotifier2ProviderFamily',
    );
    expect(
      countStreamNotifier2ProviderFamily.name,
      'myFamilyCountStreamNotifier2ProviderFamily',
    );
  });
}
