// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(calc2)
final myFamilyCalc2ProviderFamily = Calc2Family._();

final class Calc2Provider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  Calc2Provider._({
    required Calc2Family super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'myFamilyCalc2ProviderFamily',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = myCountPod;
  static final $allTransitiveDependencies1 = myCountFuturePod;
  static final $allTransitiveDependencies2 = myCountStreamPod;
  static final $allTransitiveDependencies3 = myCountNotifierPod;
  static final $allTransitiveDependencies4 = myCountAsyncNotifierPod;
  static final $allTransitiveDependencies5 = myCountStreamNotifierPod;
  static final $allTransitiveDependencies6 = myFamilyCount2ProviderFamily;
  static final $allTransitiveDependencies7 = myFamilyCountFuture2ProviderFamily;
  static final $allTransitiveDependencies8 = myFamilyCountStream2ProviderFamily;
  static final $allTransitiveDependencies9 =
      myFamilyCountNotifier2ProviderFamily;
  static final $allTransitiveDependencies10 =
      myFamilyCountAsyncNotifier2ProviderFamily;
  static final $allTransitiveDependencies11 =
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
    return calc2(ref, argument);
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
  Calc2Family._()
    : super(
        retry: null,
        name: r'myFamilyCalc2ProviderFamily',
        dependencies: <ProviderOrFamily>[
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
          myFamilyCountStreamNotifier2ProviderFamily,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
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

  Calc2Provider call(String id) => Calc2Provider._(argument: id, from: this);

  @override
  String toString() => r'myFamilyCalc2ProviderFamily';
}
