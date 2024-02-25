// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family_class.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Example)
const exampleProvider = ExampleFamily._();

final class ExampleProvider extends $NotifierProvider<Example, String> {
  const ExampleProvider._(
      {required ExampleFamily super.from,
      required (
        int, {
        String param2,
      })
          super.argument,
      super.runNotifierBuildOverride,
      Example Function()? create})
      : _createCb = create,
        super(
          name: r'exampleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Example Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @override
  String toString() {
    return r'exampleProvider'
        ''
        '$argument';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
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
    return ExampleProvider._(
        argument: argument as (
          int, {
          String param2,
        }),
        from: from! as ExampleFamily,
        create: create);
  }

  @$internal
  @override
  ExampleProvider $copyWithBuild(
    String Function(
      Ref<String>,
      Example,
    ) build,
  ) {
    return ExampleProvider._(
        argument: argument as (
          int, {
          String param2,
        }),
        from: from! as ExampleFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Example, String> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is ExampleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exampleHash() => r'c81e9d94e763b25403ab6b7fa03f092003570142';

final class ExampleFamily extends Family {
  const ExampleFamily._()
      : super(
          name: r'exampleProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ExampleProvider call(
    int param1, {
    String param2 = 'foo',
  }) =>
      ExampleProvider._(argument: (
        param1,
        param2: param2,
      ), from: this);

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @override
  String toString() => r'exampleProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Example Function(
      (
        int, {
        String param2,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as ExampleProvider;

        final argument = provider.argument as (
          int, {
          String param2,
        });

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    String Function(
            Ref<String> ref,
            Example notifier,
            (
              int, {
              String param2,
            }) argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as ExampleProvider;

        final argument = provider.argument as (
          int, {
          String param2,
        });

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$Example extends $Notifier<String> {
  late final _$args = (ref as $NotifierProviderElement).origin.argument as (
    int, {
    String param2,
  });
  int get param1 => _$args.$1;
  String get param2 => _$args.param2;

  String build(
    int param1, {
    String param2 = 'foo',
  });
  @$internal
  @override
  String runBuild() => build(
        _$args.$1,
        param2: _$args.param2,
      );
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
