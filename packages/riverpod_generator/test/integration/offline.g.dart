// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(CustomAnnotation)
@MyAnnotation()
const customAnnotationProvider = CustomAnnotationProvider._();

final class CustomAnnotationProvider
    extends $NotifierProvider<CustomAnnotation, String> {
  const CustomAnnotationProvider._(
      {super.runNotifierBuildOverride, CustomAnnotation Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'customAnnotationProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final CustomAnnotation Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$customAnnotationHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  CustomAnnotation create() => _createCb?.call() ?? CustomAnnotation();

  @$internal
  @override
  CustomAnnotationProvider $copyWithCreate(
    CustomAnnotation Function() create,
  ) {
    return CustomAnnotationProvider._(create: create);
  }

  @$internal
  @override
  CustomAnnotationProvider $copyWithBuild(
    String Function(
      Ref,
      CustomAnnotation,
    ) build,
  ) {
    return CustomAnnotationProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<CustomAnnotation, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$customAnnotationHash() => r'85fb763c60c735b97b24fdcbae8a2882cf5be8b8';

abstract class _$CustomAnnotationBase extends $Notifier<String> {
  String build();
  @$internal
  @override
  void runBuild({
    required bool isFirstBuild,
    required bool didChangeDependency,
  }) {
    final created = build();
    final ref = this.ref as $Ref<String>;
    final element = ref.element as $ClassProviderElement<NotifierBase<String>,
        String, Object?, Object?>;
    element.handleValue(
      created,
      seamless: !didChangeDependency,
      isFirstBuild: isFirstBuild,
    );
  }
}

@ProviderFor(Json)
@JsonPersist()
const jsonProvider = JsonFamily._();

final class JsonProvider
    extends $AsyncNotifierProvider<Json, Map<String, List<int>>> {
  const JsonProvider._(
      {required JsonFamily super.from,
      required String super.argument,
      super.runNotifierBuildOverride,
      Json Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'jsonProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Json Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$jsonHash();

  @override
  String toString() {
    return r'jsonProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Json create() => _createCb?.call() ?? Json();

  @$internal
  @override
  JsonProvider $copyWithCreate(
    Json Function() create,
  ) {
    return JsonProvider._(
        argument: argument as String,
        from: from! as JsonFamily,
        create: create);
  }

  @$internal
  @override
  JsonProvider $copyWithBuild(
    FutureOr<Map<String, List<int>>> Function(
      Ref,
      Json,
    ) build,
  ) {
    return JsonProvider._(
        argument: argument as String,
        from: from! as JsonFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<Json, Map<String, List<int>>> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);

  @override
  bool operator ==(Object other) {
    return other is JsonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jsonHash() => r'bce99d50cc06dc6862ce4667ec45374508675300';

final class JsonFamily extends Family {
  const JsonFamily._()
      : super(
          retry: null,
          name: r'jsonProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  JsonProvider call(
    String arg,
  ) =>
      JsonProvider._(argument: arg, from: this);

  @override
  String debugGetCreateSourceHash() => _$jsonHash();

  @override
  String toString() => r'jsonProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Json Function(
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as JsonProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<Map<String, List<int>>> Function(
            Ref ref, Json notifier, String argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as JsonProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$JsonBase extends $AsyncNotifier<Map<String, List<int>>> {
  late final _$args = ref.$arg as String;
  String get arg => _$args;

  FutureOr<Map<String, List<int>>> build(
    String arg,
  );
  @$internal
  @override
  void runBuild({
    required bool isFirstBuild,
    required bool didChangeDependency,
  }) {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<Map<String, List<int>>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<AsyncValue<Map<String, List<int>>>>,
        AsyncValue<Map<String, List<int>>>,
        Object?,
        Object?>;
    element.handleValue(
      created,
      seamless: !didChangeDependency,
      isFirstBuild: isFirstBuild,
    );
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// JsonGenerator
// **************************************************************************

abstract class _$Json extends _$JsonBase
    with NotifierEncoder<String, Map<String, List<int>>, String> {
  @override
  String get persistKey {
    final args = arg;
    return 'Json($args)';
  }

  @override
  String encode() {
    return $jsonCodex.encode(state.requireValue);
  }

  @override
  Map<String, List<int>> decode(String value) {
    final e = $jsonCodex.decode(value);
    return (e as Map).map((k, v) =>
        MapEntry(e as String, (e as List).map((e) => e as int).toList()));
  }
}
