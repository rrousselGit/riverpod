// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'optimized_previous_button.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef CanGoToPreviousPageRef = Ref<bool>;

@ProviderFor(canGoToPreviousPage)
const canGoToPreviousPageProvider = CanGoToPreviousPageProvider._();

final class CanGoToPreviousPageProvider
    extends $FunctionalProvider<bool, bool, CanGoToPreviousPageRef>
    with $Provider<bool, CanGoToPreviousPageRef> {
  const CanGoToPreviousPageProvider._(
      {bool Function(
        CanGoToPreviousPageRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'canGoToPreviousPageProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final bool Function(
    CanGoToPreviousPageRef ref,
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
  $ProviderElement<bool> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  CanGoToPreviousPageProvider $copyWithCreate(
    bool Function(
      CanGoToPreviousPageRef ref,
    ) create,
  ) {
    return CanGoToPreviousPageProvider._(create: create);
  }

  @override
  bool create(CanGoToPreviousPageRef ref) {
    final _$cb = _createCb ?? canGoToPreviousPage;
    return _$cb(ref);
  }
}

String _$canGoToPreviousPageHash() =>
    r'801fe8182a37cd21ae83bdfccbe36c125b4d14fb';

@ProviderFor(PageIndex)
const pageIndexProvider = PageIndexProvider._();

final class PageIndexProvider extends $NotifierProvider<PageIndex, int> {
  const PageIndexProvider._(
      {super.runNotifierBuildOverride, PageIndex Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
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
      Ref<int>,
      PageIndex,
    ) build,
  ) {
    return PageIndexProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<PageIndex, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$pageIndexHash() => r'59307ecf23b5b2432833da5ad6b312bf36435d0e';

abstract class _$PageIndex extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
