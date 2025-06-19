// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'declare.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Count)
const countProvider = CountProvider._();

final class CountProvider extends $NotifierProvider<Count, int> {
  const CountProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'countProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$countHash();

  @$internal
  @override
  Count create() => Count();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$countHash() => r'6fc5f8ad4bbd390899dd0d14c7b902407d4413bd';

abstract class _$Count extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
