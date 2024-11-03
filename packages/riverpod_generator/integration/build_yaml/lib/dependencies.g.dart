// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(calc2)
const myFamilyCalc2ProviderFamily = Calc2Family._();

final class Calc2Provider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const Calc2Provider._(
      {required Calc2Family super.from,
      required String super.argument,
      int Function(
        Ref ref,
        String id,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'myFamilyCalc2ProviderFamily',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
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

  final int Function(
    Ref ref,
    String id,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$calc2Hash();

  @override
  String toString() {
    return r'myFamilyCalc2ProviderFamily'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  Calc2Provider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return Calc2Provider._(
        argument: argument as String,
        from: from! as Calc2Family,
        create: (
          ref,
          String id,
        ) =>
            create(ref));
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? calc2;
    final argument = this.argument as String;
    return _$cb(
      ref,
      argument,
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

final class Calc2Family extends Family {
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
          allTransitiveDependencies: const <ProviderOrFamily>{
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
  String debugGetCreateSourceHash() => _$calc2Hash();

  @override
  String toString() => r'myFamilyCalc2ProviderFamily';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      Ref ref,
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as Calc2Provider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
