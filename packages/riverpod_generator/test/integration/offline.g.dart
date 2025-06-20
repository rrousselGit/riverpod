// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(storage)
const storageProvider = StorageProvider._();

final class StorageProvider extends $FunctionalProvider<
        AsyncValue<Storage<String, String>>,
        Storage<String, String>,
        FutureOr<Storage<String, String>>>
    with
        $FutureModifier<Storage<String, String>>,
        $FutureProvider<Storage<String, String>> {
  const StorageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'storageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$storageHash();

  @$internal
  @override
  $FutureProviderElement<Storage<String, String>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Storage<String, String>> create(Ref ref) {
    return storage(ref);
  }
}

String _$storageHash() => r'1feb3def45be8bc9cc695a7282b6d29e5c212b60';

@ProviderFor(CustomAnnotation)
@MyAnnotation()
const customAnnotationProvider = CustomAnnotationProvider._();

final class CustomAnnotationProvider
    extends $AsyncNotifierProvider<CustomAnnotation, String> {
  const CustomAnnotationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'customAnnotationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customAnnotationHash();

  @$internal
  @override
  CustomAnnotation create() => CustomAnnotation();
}

String _$customAnnotationHash() => r'4c741d54be76217c840b239b8838495358b3d1f1';

abstract class _$CustomAnnotationBase extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<String>, String>,
        AsyncValue<String>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Json)
@JsonPersist()
const jsonProvider = JsonFamily._();

final class JsonProvider
    extends $AsyncNotifierProvider<Json, Map<String, List<int>>> {
  const JsonProvider._(
      {required JsonFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'jsonProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

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
  Json create() => Json();

  @override
  bool operator ==(Object other) {
    return other is JsonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jsonHash() => r'54532ee1d9de0979dc96fe8eeb87e2aae92089c5';

final class JsonFamily extends $Family
    with
        $ClassFamilyOverride<Json, AsyncValue<Map<String, List<int>>>,
            Map<String, List<int>>, FutureOr<Map<String, List<int>>>, String> {
  const JsonFamily._()
      : super(
          retry: null,
          name: r'jsonProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  JsonProvider call(
    String arg,
  ) =>
      JsonProvider._(argument: arg, from: this);

  @override
  String toString() => r'jsonProvider';
}

abstract class _$JsonBase extends $AsyncNotifier<Map<String, List<int>>> {
  late final _$args = ref.$arg as String;
  String get arg => _$args;

  FutureOr<Map<String, List<int>>> build(
    String arg,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref
        as $Ref<AsyncValue<Map<String, List<int>>>, Map<String, List<int>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Map<String, List<int>>>, Map<String, List<int>>>,
        AsyncValue<Map<String, List<int>>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Json2)
@JsonPersist()
const json2Provider = Json2Provider._();

final class Json2Provider
    extends $AsyncNotifierProvider<Json2, Map<String, List<int>>> {
  const Json2Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'json2Provider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$json2Hash();

  @$internal
  @override
  Json2 create() => Json2();
}

String _$json2Hash() => r'0cc67d4dde84df76d54ff4c0e52f30a9b3faa9fd';

abstract class _$Json2Base extends $AsyncNotifier<Map<String, List<int>>> {
  FutureOr<Map<String, List<int>>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref
        as $Ref<AsyncValue<Map<String, List<int>>>, Map<String, List<int>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Map<String, List<int>>>, Map<String, List<int>>>,
        AsyncValue<Map<String, List<int>>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CustomJson)
@JsonPersist()
const customJsonProvider = CustomJsonProvider._();

final class CustomJsonProvider
    extends $AsyncNotifierProvider<CustomJson, Map<String, Bar>> {
  const CustomJsonProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'customJsonProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customJsonHash();

  @$internal
  @override
  CustomJson create() => CustomJson();
}

String _$customJsonHash() => r'63e29ca9b3fd9fe21a18e45f1052bbdbc96a6568';

abstract class _$CustomJsonBase extends $AsyncNotifier<Map<String, Bar>> {
  FutureOr<Map<String, Bar>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<Map<String, Bar>>, Map<String, Bar>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Map<String, Bar>>, Map<String, Bar>>,
        AsyncValue<Map<String, Bar>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CustomKey)
@JsonPersist()
const customKeyProvider = CustomKeyProvider._();

final class CustomKeyProvider
    extends $AsyncNotifierProvider<CustomKey, Map<String, Bar>> {
  const CustomKeyProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'customKeyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customKeyHash();

  @$internal
  @override
  CustomKey create() => CustomKey();
}

String _$customKeyHash() => r'3c7e8e451f51b47d295754bdd16527f5c40fa457';

abstract class _$CustomKeyBase extends $AsyncNotifier<Map<String, Bar>> {
  FutureOr<Map<String, Bar>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<Map<String, Bar>>, Map<String, Bar>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Map<String, Bar>>, Map<String, Bar>>,
        AsyncValue<Map<String, Bar>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CustomJsonWithArgs)
@JsonPersist()
const customJsonWithArgsProvider = CustomJsonWithArgsFamily._();

final class CustomJsonWithArgsProvider
    extends $AsyncNotifierProvider<CustomJsonWithArgs, Map<String, Bar>> {
  const CustomJsonWithArgsProvider._(
      {required CustomJsonWithArgsFamily super.from,
      required (
        int,
        String, {
        int? arg3,
      })
          super.argument})
      : super(
          retry: null,
          name: r'customJsonWithArgsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customJsonWithArgsHash();

  @override
  String toString() {
    return r'customJsonWithArgsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  CustomJsonWithArgs create() => CustomJsonWithArgs();

  @override
  bool operator ==(Object other) {
    return other is CustomJsonWithArgsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customJsonWithArgsHash() =>
    r'7ad8d5007b14cf007d145d79eb6bc8ad18f20aeb';

final class CustomJsonWithArgsFamily extends $Family
    with
        $ClassFamilyOverride<
            CustomJsonWithArgs,
            AsyncValue<Map<String, Bar>>,
            Map<String, Bar>,
            FutureOr<Map<String, Bar>>,
            (
              int,
              String, {
              int? arg3,
            })> {
  const CustomJsonWithArgsFamily._()
      : super(
          retry: null,
          name: r'customJsonWithArgsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CustomJsonWithArgsProvider call(
    int arg,
    String arg2, {
    int? arg3,
  }) =>
      CustomJsonWithArgsProvider._(argument: (
        arg,
        arg2,
        arg3: arg3,
      ), from: this);

  @override
  String toString() => r'customJsonWithArgsProvider';
}

abstract class _$CustomJsonWithArgsBase
    extends $AsyncNotifier<Map<String, Bar>> {
  late final _$args = ref.$arg as (
    int,
    String, {
    int? arg3,
  });
  int get arg => _$args.$1;
  String get arg2 => _$args.$2;
  int? get arg3 => _$args.arg3;

  FutureOr<Map<String, Bar>> build(
    int arg,
    String arg2, {
    int? arg3,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      _$args.$2,
      arg3: _$args.arg3,
    );
    final ref =
        this.ref as $Ref<AsyncValue<Map<String, Bar>>, Map<String, Bar>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Map<String, Bar>>, Map<String, Bar>>,
        AsyncValue<Map<String, Bar>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PassEncodeDecodeByHand)
@JsonPersist()
const passEncodeDecodeByHandProvider = PassEncodeDecodeByHandProvider._();

final class PassEncodeDecodeByHandProvider extends $AsyncNotifierProvider<
    PassEncodeDecodeByHand, Map<String, String>> {
  const PassEncodeDecodeByHandProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'passEncodeDecodeByHandProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$passEncodeDecodeByHandHash();

  @$internal
  @override
  PassEncodeDecodeByHand create() => PassEncodeDecodeByHand();
}

String _$passEncodeDecodeByHandHash() =>
    r'3960536b1d2300e99dc2b6344d44f2f354a5e679';

abstract class _$PassEncodeDecodeByHandBase
    extends $AsyncNotifier<Map<String, String>> {
  FutureOr<Map<String, String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<Map<String, String>>, Map<String, String>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Map<String, String>>, Map<String, String>>,
        AsyncValue<Map<String, String>>,
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

abstract class _$Json extends _$JsonBase {
  /// The default key used by [persist].
  String get key {
    late final args = arg;
    late final resolvedKey = 'Json($args)';

    return resolvedKey;
  }

  /// A variant of [persist], for JSON-specific encoding.
  ///
  /// You can override [key] to customize the key used for storage.
  FutureOr<void> persist(
    FutureOr<Storage<String, String>> storage, {
    String? key,
    String Function(Map<String, List<int>> state)? encode,
    Map<String, List<int>> Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    return NotifierPersistX(this).persist<String, String>(
      storage,
      key: key ?? this.key,
      encode: encode ?? $jsonCodex.encode,
      decode: decode ??
          (encoded) {
            final e = $jsonCodex.decode(encoded);
            return (e as Map).map((k, v) => MapEntry(
                k as String, (v as List).map((e) => e as int).toList()));
          },
      options: options,
    );
  }
}

abstract class _$Json2 extends _$Json2Base {
  /// The default key used by [persist].
  String get key {
    const resolvedKey = "Json2";
    return resolvedKey;
  }

  /// A variant of [persist], for JSON-specific encoding.
  ///
  /// You can override [key] to customize the key used for storage.
  FutureOr<void> persist(
    FutureOr<Storage<String, String>> storage, {
    String? key,
    String Function(Map<String, List<int>> state)? encode,
    Map<String, List<int>> Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    return NotifierPersistX(this).persist<String, String>(
      storage,
      key: key ?? this.key,
      encode: encode ?? $jsonCodex.encode,
      decode: decode ??
          (encoded) {
            final e = $jsonCodex.decode(encoded);
            return (e as Map).map((k, v) => MapEntry(
                k as String, (v as List).map((e) => e as int).toList()));
          },
      options: options,
    );
  }
}

abstract class _$CustomJson extends _$CustomJsonBase {
  /// The default key used by [persist].
  String get key {
    const resolvedKey = "CustomJson";
    return resolvedKey;
  }

  /// A variant of [persist], for JSON-specific encoding.
  ///
  /// You can override [key] to customize the key used for storage.
  FutureOr<void> persist(
    FutureOr<Storage<String, String>> storage, {
    String? key,
    String Function(Map<String, Bar> state)? encode,
    Map<String, Bar> Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    return NotifierPersistX(this).persist<String, String>(
      storage,
      key: key ?? this.key,
      encode: encode ?? $jsonCodex.encode,
      decode: decode ??
          (encoded) {
            final e = $jsonCodex.decode(encoded);
            return (e as Map).map((k, v) =>
                MapEntry(k as String, Bar.fromJson(v as Map<String, Object?>)));
          },
      options: options,
    );
  }
}

abstract class _$CustomKey extends _$CustomKeyBase {
  /// The default key used by [persist].
  String get key {
    const resolvedKey = "CustomKey";
    return resolvedKey;
  }

  /// A variant of [persist], for JSON-specific encoding.
  ///
  /// You can override [key] to customize the key used for storage.
  FutureOr<void> persist(
    FutureOr<Storage<String, String>> storage, {
    String? key,
    String Function(Map<String, Bar> state)? encode,
    Map<String, Bar> Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    return NotifierPersistX(this).persist<String, String>(
      storage,
      key: key ?? this.key,
      encode: encode ?? $jsonCodex.encode,
      decode: decode ??
          (encoded) {
            final e = $jsonCodex.decode(encoded);
            return (e as Map).map((k, v) =>
                MapEntry(k as String, Bar.fromJson(v as Map<String, Object?>)));
          },
      options: options,
    );
  }
}

abstract class _$CustomJsonWithArgs extends _$CustomJsonWithArgsBase {
  /// The default key used by [persist].
  String get key {
    late final args = (
      arg,
      arg2,
      arg3: arg3,
    );
    late final resolvedKey = 'CustomJsonWithArgs($args)';

    return resolvedKey;
  }

  /// A variant of [persist], for JSON-specific encoding.
  ///
  /// You can override [key] to customize the key used for storage.
  FutureOr<void> persist(
    FutureOr<Storage<String, String>> storage, {
    String? key,
    String Function(Map<String, Bar> state)? encode,
    Map<String, Bar> Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    return NotifierPersistX(this).persist<String, String>(
      storage,
      key: key ?? this.key,
      encode: encode ?? $jsonCodex.encode,
      decode: decode ??
          (encoded) {
            final e = $jsonCodex.decode(encoded);
            return (e as Map).map((k, v) =>
                MapEntry(k as String, Bar.fromJson(v as Map<String, Object?>)));
          },
      options: options,
    );
  }
}

abstract class _$PassEncodeDecodeByHand extends _$PassEncodeDecodeByHandBase {
  /// The default key used by [persist].
  String get key {
    const resolvedKey = "PassEncodeDecodeByHand";
    return resolvedKey;
  }

  /// A variant of [persist], for JSON-specific encoding.
  ///
  /// You can override [key] to customize the key used for storage.
  FutureOr<void> persist(
    FutureOr<Storage<String, String>> storage, {
    String? key,
    String Function(Map<String, String> state)? encode,
    Map<String, String> Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    return NotifierPersistX(this).persist<String, String>(
      storage,
      key: key ?? this.key,
      encode: encode ?? $jsonCodex.encode,
      decode: decode ??
          (encoded) {
            final e = $jsonCodex.decode(encoded);
            return (e as Map).map((k, v) => MapEntry(k as String, v as String));
          },
      options: options,
    );
  }
}
