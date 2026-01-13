// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avoid_public_notifier_properties.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GeneratedNotifier)
final generatedProvider = GeneratedNotifierFamily._();

final class GeneratedNotifierProvider
    extends $NotifierProvider<GeneratedNotifier, int> {
  GeneratedNotifierProvider._({
    required GeneratedNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'generatedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$generatedNotifierHash();

  @override
  String toString() {
    return r'generatedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GeneratedNotifier create() => GeneratedNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GeneratedNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$generatedNotifierHash() => r'2b7f4fba816b6e8ccd0e8b7d11fcd207bbb79828';

final class GeneratedNotifierFamily extends $Family
    with $ClassFamilyOverride<GeneratedNotifier, int, int, int, int> {
  GeneratedNotifierFamily._()
    : super(
        retry: null,
        name: r'generatedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GeneratedNotifierProvider call(int param) =>
      GeneratedNotifierProvider._(argument: param, from: this);

  @override
  String toString() => r'generatedProvider';
}

abstract class _$GeneratedNotifier extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  int build(int param);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
