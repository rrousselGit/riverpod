// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avoid_public_notifier_properties.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(GeneratedNotifier)
const generatedNotifierProvider = GeneratedNotifierFamily._();

final class GeneratedNotifierProvider
    extends $NotifierProvider<GeneratedNotifier, int> {
  const GeneratedNotifierProvider._(
      {required GeneratedNotifierFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'generatedNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$generatedNotifierHash();

  @override
  String toString() {
    return r'generatedNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GeneratedNotifier create() => GeneratedNotifier();

  @$internal
  @override
  $NotifierProviderElement<GeneratedNotifier, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
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

final class GeneratedNotifierFamily extends $Family {
  const GeneratedNotifierFamily._()
      : super(
          retry: null,
          name: r'generatedNotifierProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GeneratedNotifierProvider call(
    int param,
  ) =>
      GeneratedNotifierProvider._(argument: param, from: this);

  @override
  String toString() => r'generatedNotifierProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          GeneratedNotifier Function(
            int args,
          ) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GeneratedNotifierProvider;
            final argument = provider.argument as int;
            return provider
                .$view(create: () => create(argument))
                .$createElement(pointer);
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          int Function(Ref ref, GeneratedNotifier notifier, int argument)
              build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GeneratedNotifierProvider;
            final argument = provider.argument as int;
            return provider
                .$view(
                    runNotifierBuildOverride: (ref, notifier) =>
                        build(ref, notifier, argument))
                .$createElement(pointer);
          });
}

abstract class _$GeneratedNotifier extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get param => _$args;

  int build(
    int param,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
