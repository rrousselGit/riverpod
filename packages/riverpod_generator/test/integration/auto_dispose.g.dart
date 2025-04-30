// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(keepAlive)
const keepAliveProvider = KeepAliveProvider._();

final class KeepAliveProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const KeepAliveProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'keepAliveProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$keepAliveHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return keepAlive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$keepAliveHash() => r'44af50bf7e6dcfddc61a1f32855855b534a7fe4f';

@ProviderFor(notKeepAlive)
const notKeepAliveProvider = NotKeepAliveProvider._();

final class NotKeepAliveProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const NotKeepAliveProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notKeepAliveProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notKeepAliveHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return notKeepAlive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$notKeepAliveHash() => r'e60c952d04ffd7548294908c2e1ef472614c284b';

@ProviderFor(defaultKeepAlive)
const defaultKeepAliveProvider = DefaultKeepAliveProvider._();

final class DefaultKeepAliveProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const DefaultKeepAliveProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'defaultKeepAliveProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$defaultKeepAliveHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return defaultKeepAlive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$defaultKeepAliveHash() => r'76485c3c7574c38dcba6dda28c94a59c09b339c0';

@ProviderFor(keepAliveFamily)
const keepAliveFamilyProvider = KeepAliveFamilyFamily._();

final class KeepAliveFamilyProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const KeepAliveFamilyProvider._(
      {required KeepAliveFamilyFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'keepAliveFamilyProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$keepAliveFamilyHash();

  @override
  String toString() {
    return r'keepAliveFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as int;
    return keepAliveFamily(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KeepAliveFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$keepAliveFamilyHash() => r'd1eb1243ea9463617b08a6e9cc5ae6b2df499ba2';

final class KeepAliveFamilyFamily extends $Family
    with $FunctionalFamilyOverride<int, int> {
  const KeepAliveFamilyFamily._()
      : super(
          retry: null,
          name: r'keepAliveFamilyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  KeepAliveFamilyProvider call(
    int a,
  ) =>
      KeepAliveFamilyProvider._(argument: a, from: this);

  @override
  String toString() => r'keepAliveFamilyProvider';
}

@ProviderFor(notKeepAliveFamily)
const notKeepAliveFamilyProvider = NotKeepAliveFamilyFamily._();

final class NotKeepAliveFamilyProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const NotKeepAliveFamilyProvider._(
      {required NotKeepAliveFamilyFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'notKeepAliveFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notKeepAliveFamilyHash();

  @override
  String toString() {
    return r'notKeepAliveFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as int;
    return notKeepAliveFamily(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NotKeepAliveFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notKeepAliveFamilyHash() =>
    r'a721713b026088b65be6c0f7f9beb1083a377a7c';

final class NotKeepAliveFamilyFamily extends $Family
    with $FunctionalFamilyOverride<int, int> {
  const NotKeepAliveFamilyFamily._()
      : super(
          retry: null,
          name: r'notKeepAliveFamilyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  NotKeepAliveFamilyProvider call(
    int a,
  ) =>
      NotKeepAliveFamilyProvider._(argument: a, from: this);

  @override
  String toString() => r'notKeepAliveFamilyProvider';
}

@ProviderFor(defaultKeepAliveFamily)
const defaultKeepAliveFamilyProvider = DefaultKeepAliveFamilyFamily._();

final class DefaultKeepAliveFamilyProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const DefaultKeepAliveFamilyProvider._(
      {required DefaultKeepAliveFamilyFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'defaultKeepAliveFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$defaultKeepAliveFamilyHash();

  @override
  String toString() {
    return r'defaultKeepAliveFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as int;
    return defaultKeepAliveFamily(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DefaultKeepAliveFamilyProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$defaultKeepAliveFamilyHash() =>
    r'e79f3d9ccd6713aade34c1701699c578f9236e9e';

final class DefaultKeepAliveFamilyFamily extends $Family
    with $FunctionalFamilyOverride<int, int> {
  const DefaultKeepAliveFamilyFamily._()
      : super(
          retry: null,
          name: r'defaultKeepAliveFamilyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  DefaultKeepAliveFamilyProvider call(
    int a,
  ) =>
      DefaultKeepAliveFamilyProvider._(argument: a, from: this);

  @override
  String toString() => r'defaultKeepAliveFamilyProvider';
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
