// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(keepAlive)
const keepAliveProvider = KeepAliveProvider._();

final class KeepAliveProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const KeepAliveProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'keepAliveProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$keepAliveHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  KeepAliveProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return KeepAliveProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? keepAlive;
    return _$cb(ref);
  }
}

String _$keepAliveHash() => r'44af50bf7e6dcfddc61a1f32855855b534a7fe4f';

@ProviderFor(notKeepAlive)
const notKeepAliveProvider = NotKeepAliveProvider._();

final class NotKeepAliveProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const NotKeepAliveProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'notKeepAliveProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$notKeepAliveHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  NotKeepAliveProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return NotKeepAliveProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? notKeepAlive;
    return _$cb(ref);
  }
}

String _$notKeepAliveHash() => r'e60c952d04ffd7548294908c2e1ef472614c284b';

@ProviderFor(defaultKeepAlive)
const defaultKeepAliveProvider = DefaultKeepAliveProvider._();

final class DefaultKeepAliveProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const DefaultKeepAliveProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'defaultKeepAliveProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$defaultKeepAliveHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  DefaultKeepAliveProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return DefaultKeepAliveProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? defaultKeepAlive;
    return _$cb(ref);
  }
}

String _$defaultKeepAliveHash() => r'76485c3c7574c38dcba6dda28c94a59c09b339c0';

@ProviderFor(keepAliveFamily)
const keepAliveFamilyProvider = KeepAliveFamilyFamily._();

final class KeepAliveFamilyProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const KeepAliveFamilyProvider._(
      {required KeepAliveFamilyFamily super.from,
      required int super.argument,
      int Function(
        Ref ref,
        int a,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'keepAliveFamilyProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
    int a,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$keepAliveFamilyHash();

  @override
  String toString() {
    return r'keepAliveFamilyProvider'
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  KeepAliveFamilyProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return KeepAliveFamilyProvider._(
        argument: argument as int,
        from: from! as KeepAliveFamilyFamily,
        create: (
          ref,
          int a,
        ) =>
            create(ref));
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? keepAliveFamily;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
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

final class KeepAliveFamilyFamily extends Family {
  const KeepAliveFamilyFamily._()
      : super(
          retry: null,
          name: r'keepAliveFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  KeepAliveFamilyProvider call(
    int a,
  ) =>
      KeepAliveFamilyProvider._(argument: a, from: this);

  @override
  String debugGetCreateSourceHash() => _$keepAliveFamilyHash();

  @override
  String toString() => r'keepAliveFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      Ref ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as KeepAliveFamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(notKeepAliveFamily)
const notKeepAliveFamilyProvider = NotKeepAliveFamilyFamily._();

final class NotKeepAliveFamilyProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const NotKeepAliveFamilyProvider._(
      {required NotKeepAliveFamilyFamily super.from,
      required int super.argument,
      int Function(
        Ref ref,
        int a,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'notKeepAliveFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
    int a,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$notKeepAliveFamilyHash();

  @override
  String toString() {
    return r'notKeepAliveFamilyProvider'
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  NotKeepAliveFamilyProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return NotKeepAliveFamilyProvider._(
        argument: argument as int,
        from: from! as NotKeepAliveFamilyFamily,
        create: (
          ref,
          int a,
        ) =>
            create(ref));
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? notKeepAliveFamily;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
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

final class NotKeepAliveFamilyFamily extends Family {
  const NotKeepAliveFamilyFamily._()
      : super(
          retry: null,
          name: r'notKeepAliveFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  NotKeepAliveFamilyProvider call(
    int a,
  ) =>
      NotKeepAliveFamilyProvider._(argument: a, from: this);

  @override
  String debugGetCreateSourceHash() => _$notKeepAliveFamilyHash();

  @override
  String toString() => r'notKeepAliveFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      Ref ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as NotKeepAliveFamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(defaultKeepAliveFamily)
const defaultKeepAliveFamilyProvider = DefaultKeepAliveFamilyFamily._();

final class DefaultKeepAliveFamilyProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const DefaultKeepAliveFamilyProvider._(
      {required DefaultKeepAliveFamilyFamily super.from,
      required int super.argument,
      int Function(
        Ref ref,
        int a,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'defaultKeepAliveFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
    int a,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$defaultKeepAliveFamilyHash();

  @override
  String toString() {
    return r'defaultKeepAliveFamilyProvider'
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  DefaultKeepAliveFamilyProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return DefaultKeepAliveFamilyProvider._(
        argument: argument as int,
        from: from! as DefaultKeepAliveFamilyFamily,
        create: (
          ref,
          int a,
        ) =>
            create(ref));
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? defaultKeepAliveFamily;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
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

final class DefaultKeepAliveFamilyFamily extends Family {
  const DefaultKeepAliveFamilyFamily._()
      : super(
          retry: null,
          name: r'defaultKeepAliveFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  DefaultKeepAliveFamilyProvider call(
    int a,
  ) =>
      DefaultKeepAliveFamilyProvider._(argument: a, from: this);

  @override
  String debugGetCreateSourceHash() => _$defaultKeepAliveFamilyHash();

  @override
  String toString() => r'defaultKeepAliveFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      Ref ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as DefaultKeepAliveFamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
