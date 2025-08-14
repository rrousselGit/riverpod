import 'package:build_yaml/dependencies.dart';
import 'package:build_yaml/main.dart';
import 'package:riverpod_annotation/experimental/scope.dart';
import 'package:test/test.dart';

@Dependencies([calc2])
void main() {
  test('provider names', () {
    expect(myCountPod.name, 'myCountPod');
    expect(myCountFuturePod.name, 'myCountFuturePod');
    expect(myCountStreamPod.name, 'myCountStreamPod');
    expect(myCountNotifierPod.name, 'myCountNotifierPod');
    expect(myCountAsyncNotifierPod.name, 'myCountAsyncNotifierPod');
    expect(myCountStreamNotifierPod.name, 'myCountStreamNotifierPod');
  });

  test('provider family names', () {
    expect(myFamilyCount2ProviderFamily.name, 'myFamilyCount2ProviderFamily');
    expect(
      myFamilyCountFuture2ProviderFamily.name,
      'myFamilyCountFuture2ProviderFamily',
    );
    expect(
      myFamilyCountStream2ProviderFamily.name,
      'myFamilyCountStream2ProviderFamily',
    );
    expect(
      myFamilyCountNotifier2ProviderFamily.name,
      'myFamilyCountNotifier2ProviderFamily',
    );
    expect(
      myFamilyCountAsyncNotifier2ProviderFamily.name,
      'myFamilyCountAsyncNotifier2ProviderFamily',
    );
    expect(
      myFamilyCountStreamNotifier2ProviderFamily.name,
      'myFamilyCountStreamNotifier2ProviderFamily',
    );
  });

  test('dependencies', () {
    expect(
      myFamilyCalc2ProviderFamily.dependencies,
      unorderedEquals([
        myCountPod,
        myCountFuturePod,
        myCountStreamPod,
        myCountNotifierPod,
        myCountAsyncNotifierPod,
        myCountStreamNotifierPod,
        // Family
        myFamilyCount2ProviderFamily,
        myFamilyCountFuture2ProviderFamily,
        myFamilyCountStream2ProviderFamily,
        myFamilyCountNotifier2ProviderFamily,
        myFamilyCountAsyncNotifier2ProviderFamily,
        myFamilyCountStreamNotifier2ProviderFamily,
      ]),
    );
  });

  test('strip pattern', () {
    expect(myTimePod.name, 'myTimePod');
    expect(myFamilyTimeProviderFamily.name, 'myFamilyTimeProviderFamily');
  });
}
