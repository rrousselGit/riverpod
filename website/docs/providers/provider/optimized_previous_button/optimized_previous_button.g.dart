// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'optimized_previous_button.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(PageIndex)
const pageIndexProvider = PageIndexProvider._();

final class PageIndexProvider extends $NotifierProvider<PageIndex, int> {
  const PageIndexProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pageIndexProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pageIndexHash();

  @$internal
  @override
  PageIndex create() => PageIndex();

  @$internal
  @override
  $NotifierProviderElement<PageIndex, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$pageIndexHash() => r'59307ecf23b5b2432833da5ad6b312bf36435d0e';

abstract class _$PageIndex extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(canGoToPreviousPage)
const canGoToPreviousPageProvider = CanGoToPreviousPageProvider._();

final class CanGoToPreviousPageProvider extends $FunctionalProvider<bool, bool>
    with $Provider<bool> {
  const CanGoToPreviousPageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'canGoToPreviousPageProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$canGoToPreviousPageHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canGoToPreviousPage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<bool>(value),
    );
  }
}

String _$canGoToPreviousPageHash() =>
    r'1cb9c497aa7e5e8ee03c5711f079c2b68a4c28c5';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
