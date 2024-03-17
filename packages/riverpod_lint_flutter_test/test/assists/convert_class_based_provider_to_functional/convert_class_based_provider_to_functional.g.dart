// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_class_based_provider_to_functional.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Some comment
@ProviderFor(Example)
const exampleProvider = ExampleProvider._();

/// Some comment
final class ExampleProvider extends $NotifierProvider<Example, int> {
  /// Some comment
  const ExampleProvider._(
      {super.runNotifierBuildOverride, Example Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'exampleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Example Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  Example create() => _createCb?.call() ?? Example();

  @$internal
  @override
  ExampleProvider $copyWithCreate(
    Example Function() create,
  ) {
    return ExampleProvider._(create: create);
  }

  @$internal
  @override
  ExampleProvider $copyWithBuild(
    int Function(
      Ref<int>,
      Example,
    ) build,
  ) {
    return ExampleProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Example, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$exampleHash() => r'081776126bafed3e1583bba9c1fadef798215ad7';

abstract class _$Example extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

/// Some comment
@ProviderFor(ExampleFamily)
const exampleFamilyProvider = ExampleFamilyFamily._();

/// Some comment
final class ExampleFamilyProvider
    extends $NotifierProvider<ExampleFamily, int> {
  /// Some comment
  const ExampleFamilyProvider._(
      {required ExampleFamilyFamily super.from,
      required ({
        int a,
        String b,
      })
          super.argument,
      super.runNotifierBuildOverride,
      ExampleFamily Function()? create})
      : _createCb = create,
        super(
          name: r'exampleFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ExampleFamily Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleFamilyHash();

  @override
  String toString() {
    return r'exampleFamilyProvider'
        ''
        '$argument';
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
  ExampleFamily create() => _createCb?.call() ?? ExampleFamily();

  @$internal
  @override
  ExampleFamilyProvider $copyWithCreate(
    ExampleFamily Function() create,
  ) {
    return ExampleFamilyProvider._(
        argument: argument as ({
          int a,
          String b,
        }),
        from: from! as ExampleFamilyFamily,
        create: create);
  }

  @$internal
  @override
  ExampleFamilyProvider $copyWithBuild(
    int Function(
      Ref<int>,
      ExampleFamily,
    ) build,
  ) {
    return ExampleFamilyProvider._(
        argument: argument as ({
          int a,
          String b,
        }),
        from: from! as ExampleFamilyFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ExampleFamily, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

  @override
  bool operator ==(Object other) {
    return other is ExampleFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exampleFamilyHash() => r'37d4a4fd66999562cd92051f91266270d5a1e5ea';

/// Some comment
final class ExampleFamilyFamily extends Family {
  const ExampleFamilyFamily._()
      : super(
          name: r'exampleFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Some comment
  ExampleFamilyProvider call({
    required int a,
    String b = '42',
  }) =>
      ExampleFamilyProvider._(argument: (
        a: a,
        b: b,
      ), from: this);

  @override
  String debugGetCreateSourceHash() => _$exampleFamilyHash();

  @override
  String toString() => r'exampleFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    ExampleFamily Function(
      ({
        int a,
        String b,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ExampleFamilyProvider;

        final argument = provider.argument as ({
          int a,
          String b,
        });

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function(
            Ref<int> ref,
            ExampleFamily notifier,
            ({
              int a,
              String b,
            }) argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ExampleFamilyProvider;

        final argument = provider.argument as ({
          int a,
          String b,
        });

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$ExampleFamily extends $Notifier<int> {
  late final _$args = ref.$arg as ({
    int a,
    String b,
  });
  int get a => _$args.a;
  String get b => _$args.b;

  int build({
    required int a,
    String b = '42',
  });
  @$internal
  @override
  int runBuild() => build(
        a: _$args.a,
        b: _$args.b,
      );
}

@ProviderFor(Generic)
const genericProvider = GenericFamily._();

final class GenericProvider<A, B>
    extends $NotifierProvider<Generic<A, B>, int> {
  const GenericProvider._(
      {required GenericFamily super.from,
      super.runNotifierBuildOverride,
      Generic<A, B> Function()? create})
      : _createCb = create,
        super(
          argument: null,
          name: r'genericProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Generic<A, B> Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$genericHash();

  GenericProvider<A, B> _copyWithCreate(
    Generic<A, B> Function<A, B>() create,
  ) {
    return GenericProvider<A, B>._(
        from: from! as GenericFamily, create: create<A, B>);
  }

  GenericProvider<A, B> _copyWithBuild(
    int Function<A, B>(
      Ref<int>,
      Generic<A, B>,
    ) build,
  ) {
    return GenericProvider<A, B>._(
        from: from! as GenericFamily, runNotifierBuildOverride: build<A, B>);
  }

  @override
  String toString() {
    return r'genericProvider'
        '<${A}, ${B}>'
        '()';
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
  Generic<A, B> create() => _createCb?.call() ?? Generic<A, B>();

  @$internal
  @override
  GenericProvider<A, B> $copyWithCreate(
    Generic<A, B> Function() create,
  ) {
    return GenericProvider<A, B>._(
        from: from! as GenericFamily, create: create);
  }

  @$internal
  @override
  GenericProvider<A, B> $copyWithBuild(
    int Function(
      Ref<int>,
      Generic<A, B>,
    ) build,
  ) {
    return GenericProvider<A, B>._(
        from: from! as GenericFamily, runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Generic<A, B>, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

  @override
  bool operator ==(Object other) {
    return other is GenericProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$genericHash() => r'0a3792d7b59723aebd92715eef2c74d2f267cbd2';

final class GenericFamily extends Family {
  const GenericFamily._()
      : super(
          name: r'genericProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GenericProvider<A, B> call<A, B>() => GenericProvider<A, B>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$genericHash();

  @override
  String toString() => r'genericProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Generic<A, B> Function<A, B>() create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as GenericProvider;

        return provider._copyWithCreate(create).$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function<A, B>(Ref<int> ref, Generic<A, B> notifier) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as GenericProvider;

        return provider._copyWithBuild(build).$createElement(pointer);
      },
    );
  }
}

abstract class _$Generic<A, B> extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
