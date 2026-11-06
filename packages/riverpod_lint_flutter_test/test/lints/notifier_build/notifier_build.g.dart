// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier_build.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExampleProvider)
final exampleProviderProvider = ExampleProviderProvider._();

final class ExampleProviderProvider
    extends $NotifierProvider<ExampleProvider, int> {
  ExampleProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exampleProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exampleProviderHash();

  @$internal
  @override
  ExampleProvider create() => ExampleProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$exampleProviderHash() => r'198bb6a75a43d8bfb2587b1a3bbbbadd4e54313a';

abstract class _$ExampleProvider extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
