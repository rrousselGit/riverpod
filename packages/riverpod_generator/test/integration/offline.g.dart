// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(storage)
const storageProvider = StorageProvider._();

final class StorageProvider extends $FunctionalProvider<
        AsyncValue<Storage<String, String>>, FutureOr<Storage<String, String>>>
    with
        $FutureModifier<Storage<String, String>>,
        $FutureProvider<Storage<String, String>> {
  const StorageProvider._(
      {FutureOr<Storage<String, String>> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'storageProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<Storage<String, String>> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$storageHash();

  @$internal
  @override
  $FutureProviderElement<Storage<String, String>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  StorageProvider $copyWithCreate(
    FutureOr<Storage<String, String>> Function(
      Ref ref,
    ) create,
  ) {
    return StorageProvider._(create: create);
  }

  @override
  FutureOr<Storage<String, String>> create(Ref ref) {
    final _$cb = _createCb ?? storage;
    return _$cb(ref);
  }
}

String _$storageHash() => r'1feb3def45be8bc9cc695a7282b6d29e5c212b60';

@ProviderFor(CustomAnnotation)
@MyAnnotation()
const customAnnotationProvider = CustomAnnotationProvider._();

final class CustomAnnotationProvider
    extends $AsyncNotifierProvider<CustomAnnotation, String> {
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
    FutureOr<String> Function(
      Ref,
      CustomAnnotation,
    ) build,
  ) {
    return CustomAnnotationProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<CustomAnnotation, String> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);
}

String _$customAnnotationHash() => r'abdbe1ad35942aef6e4017f7ebcbfcc7fc6bb986';

abstract class _$CustomAnnotationBase extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<AsyncValue<String>>, AsyncValue<String>, Object?, Object?>;
    element.handleValue(ref, created);
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

String _$jsonHash() => r'fb36d984214529f587e141faf4aae78f2a39474c';

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
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<Map<String, List<int>>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<AsyncValue<Map<String, List<int>>>>,
        AsyncValue<Map<String, List<int>>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// JsonGenerator
// **************************************************************************

abstract class _$Json extends _$JsonBase
    with Persistable<Map<String, List<int>>, String, String> {
  @override
  void persist({
    String? key,
    required FutureOr<Storage<String, String>> storage,
    String Function(Map<String, List<int>> state)? encode,
    Map<String, List<int>> Function(String encoded)? decode,
    PersistOptions options = const PersistOptions(),
  }) {
    final args = arg;
    final resolvedKey = 'Json($args)';

    super.persist(
      key: resolvedKey,
      storage: storage,
      encode: encode ?? (value) => $jsonCodex.encode(state.requireValue),
      decode: decode ??
          (encoded) {
            final e = $jsonCodex.decode(encoded);
            return (e as Map).map((k, v) => MapEntry(
                e as String, (e as List).map((e) => e as int).toList()));
          },
      options: options,
    );
  }
}
