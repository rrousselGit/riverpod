// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'unoptimized_previous_button.dart';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
