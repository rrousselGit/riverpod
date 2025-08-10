// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

@ProviderFor(calc2)
const myFamilyCalc2ProviderFamily = Calc2Family._();

final class Calc2Provider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const Calc2Provider._(
      {required Calc2Family super.from, required String super.argument})
      : super(
          retry: null,
          name: r'myFamilyCalc2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  static const $allTransitiveDependencies0 = myCountPod;
  static const $allTransitiveDependencies1 = myCountFuturePod;
  static const $allTransitiveDependencies2 = myCountStreamPod;
  static const $allTransitiveDependencies3 = myCountNotifierPod;
  static const $allTransitiveDependencies4 = myCountAsyncNotifierPod;
  static const $allTransitiveDependencies5 = myCountStreamNotifierPod;
  static const $allTransitiveDependencies6 = myFamilyCount2ProviderFamily;
  static const $allTransitiveDependencies7 = myFamilyCountFuture2ProviderFamily;
  static const $allTransitiveDependencies8 = myFamilyCountStream2ProviderFamily;
  static const $allTransitiveDependencies9 =
      myFamilyCountNotifier2ProviderFamily;
  static const $allTransitiveDependencies10 =
      myFamilyCountAsyncNotifier2ProviderFamily;
  static const $allTransitiveDependencies11 =
      myFamilyCountStreamNotifier2ProviderFamily;

  @override
  String debugGetCreateSourceHash() => _$calc2Hash();

  @override
  String toString() {
    return r'myFamilyCalc2ProviderFamily'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as String;
    return calc2(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Calc2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$calc2Hash() => r'ae1d601ff7cdda569255e8014bd5d8d1c178b3eb';

final class Calc2Family extends $Family
    with $FunctionalFamilyOverride<int, String> {
  const Calc2Family._()
      : super(
          retry: null,
          name: r'myFamilyCalc2ProviderFamily',
          dependencies: const <ProviderOrFamily>[
            myCountPod,
            myCountFuturePod,
            myCountStreamPod,
            myCountNotifierPod,
            myCountAsyncNotifierPod,
            myCountStreamNotifierPod,
            myFamilyCount2ProviderFamily,
            myFamilyCountFuture2ProviderFamily,
            myFamilyCountStream2ProviderFamily,
            myFamilyCountNotifier2ProviderFamily,
            myFamilyCountAsyncNotifier2ProviderFamily,
            myFamilyCountStreamNotifier2ProviderFamily
          ],
          $allTransitiveDependencies: const <ProviderOrFamily>{
            Calc2Provider.$allTransitiveDependencies0,
            Calc2Provider.$allTransitiveDependencies1,
            Calc2Provider.$allTransitiveDependencies2,
            Calc2Provider.$allTransitiveDependencies3,
            Calc2Provider.$allTransitiveDependencies4,
            Calc2Provider.$allTransitiveDependencies5,
            Calc2Provider.$allTransitiveDependencies6,
            Calc2Provider.$allTransitiveDependencies7,
            Calc2Provider.$allTransitiveDependencies8,
            Calc2Provider.$allTransitiveDependencies9,
            Calc2Provider.$allTransitiveDependencies10,
            Calc2Provider.$allTransitiveDependencies11,
          },
          isAutoDispose: true,
        );

  Calc2Provider call(
    String id,
  ) =>
      Calc2Provider._(argument: id, from: this);

  @override
  String toString() => r'myFamilyCalc2ProviderFamily';
}
