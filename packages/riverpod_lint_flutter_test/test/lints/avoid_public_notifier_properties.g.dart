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
      required int super.argument,
      super.runNotifierBuildOverride,
      GeneratedNotifier Function()? create})
      : _createCb = create,
        super(
          name: r'generatedNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final GeneratedNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$generatedNotifierHash();

  @override
  String toString() {
    return r'generatedNotifierProvider'
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
  GeneratedNotifier create() => _createCb?.call() ?? GeneratedNotifier();

  @$internal
  @override
  GeneratedNotifierProvider $copyWithCreate(
    GeneratedNotifier Function() create,
  ) {
    return GeneratedNotifierProvider._(
        argument: argument as int,
        from: from! as GeneratedNotifierFamily,
        create: create);
  }

  @$internal
  @override
  GeneratedNotifierProvider $copyWithBuild(
    int Function(
      Ref<int>,
      GeneratedNotifier,
    ) build,
  ) {
    return GeneratedNotifierProvider._(
        argument: argument as int,
        from: from! as GeneratedNotifierFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<GeneratedNotifier, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

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

final class GeneratedNotifierFamily extends Family {
  const GeneratedNotifierFamily._()
      : super(
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
  String debugGetCreateSourceHash() => _$generatedNotifierHash();

  @override
  String toString() => r'generatedNotifierProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    GeneratedNotifier Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as GeneratedNotifierProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function(Ref<int> ref, GeneratedNotifier notifier, int argument) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as GeneratedNotifierProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$GeneratedNotifier extends $Notifier<int> {
  late final _$args = (ref as $NotifierProviderElement).origin.argument as int;
  int get param => _$args;

  int build(
    int param,
  );
  @$internal
  @override
  int runBuild() => build(
        _$args,
      );
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
