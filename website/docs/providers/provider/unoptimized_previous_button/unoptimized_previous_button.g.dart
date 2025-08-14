// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'unoptimized_previous_button.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pageIndexHash();

  @$internal
  @override
  PageIndex create() => PageIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$pageIndexHash() => r'59307ecf23b5b2432833da5ad6b312bf36435d0e';

abstract class _$PageIndex extends $Notifier<int> {
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
