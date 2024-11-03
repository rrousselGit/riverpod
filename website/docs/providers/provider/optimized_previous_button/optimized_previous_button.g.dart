// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'optimized_previous_button.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(PageIndex)
const pageIndexProvider = PageIndexProvider._();

final class PageIndexProvider extends $NotifierProvider<PageIndex, int> {
  const PageIndexProvider._(
      {super.runNotifierBuildOverride, PageIndex Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'pageIndexProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final PageIndex Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$pageIndexHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  PageIndex create() => _createCb?.call() ?? PageIndex();

  @$internal
  @override
  PageIndexProvider $copyWithCreate(
    PageIndex Function() create,
  ) {
    return PageIndexProvider._(create: create);
  }

  @$internal
  @override
  PageIndexProvider $copyWithBuild(
    int Function(
      Ref,
      PageIndex,
    ) build,
  ) {
    return PageIndexProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<PageIndex, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$pageIndexHash() => r'59307ecf23b5b2432833da5ad6b312bf36435d0e';

abstract class _$PageIndex extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(canGoToPreviousPage)
const canGoToPreviousPageProvider = CanGoToPreviousPageProvider._();

final class CanGoToPreviousPageProvider extends $FunctionalProvider<bool, bool>
    with $Provider<bool> {
  const CanGoToPreviousPageProvider._(
      {bool Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'canGoToPreviousPageProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final bool Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$canGoToPreviousPageHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<bool>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  CanGoToPreviousPageProvider $copyWithCreate(
    bool Function(
      Ref ref,
    ) create,
  ) {
    return CanGoToPreviousPageProvider._(create: create);
  }

  @override
  bool create(Ref ref) {
    final _$cb = _createCb ?? canGoToPreviousPage;
    return _$cb(ref);
  }
}

String _$canGoToPreviousPageHash() =>
    r'1cb9c497aa7e5e8ee03c5711f079c2b68a4c28c5';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
