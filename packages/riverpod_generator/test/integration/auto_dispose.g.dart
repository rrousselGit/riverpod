// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef KeepAliveRef = Ref<int>;

@ProviderFor(keepAlive)
const keepAliveProvider = KeepAliveProvider._();

final class KeepAliveProvider extends $FunctionalProvider<int, int>
    with $Provider<int, KeepAliveRef> {
  const KeepAliveProvider._(
      {int Function(
        KeepAliveRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'keepAliveProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    KeepAliveRef ref,
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
      KeepAliveRef ref,
    ) create,
  ) {
    return KeepAliveProvider._(create: create);
  }

  @override
  int create(KeepAliveRef ref) {
    final _$cb = _createCb ?? keepAlive;
    return _$cb(ref);
  }
}

String _$keepAliveHash() => r'72dd192676126d487c24c7695a91d59410c62696';

typedef NotKeepAliveRef = Ref<int>;

@ProviderFor(notKeepAlive)
const notKeepAliveProvider = NotKeepAliveProvider._();

final class NotKeepAliveProvider extends $FunctionalProvider<int, int>
    with $Provider<int, NotKeepAliveRef> {
  const NotKeepAliveProvider._(
      {int Function(
        NotKeepAliveRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'notKeepAliveProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    NotKeepAliveRef ref,
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
      NotKeepAliveRef ref,
    ) create,
  ) {
    return NotKeepAliveProvider._(create: create);
  }

  @override
  int create(NotKeepAliveRef ref) {
    final _$cb = _createCb ?? notKeepAlive;
    return _$cb(ref);
  }
}

String _$notKeepAliveHash() => r'1ccc497d7c651f8e730ec1bcecf271ffe9615d83';

typedef DefaultKeepAliveRef = Ref<int>;

@ProviderFor(defaultKeepAlive)
const defaultKeepAliveProvider = DefaultKeepAliveProvider._();

final class DefaultKeepAliveProvider extends $FunctionalProvider<int, int>
    with $Provider<int, DefaultKeepAliveRef> {
  const DefaultKeepAliveProvider._(
      {int Function(
        DefaultKeepAliveRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'defaultKeepAliveProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    DefaultKeepAliveRef ref,
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
      DefaultKeepAliveRef ref,
    ) create,
  ) {
    return DefaultKeepAliveProvider._(create: create);
  }

  @override
  int create(DefaultKeepAliveRef ref) {
    final _$cb = _createCb ?? defaultKeepAlive;
    return _$cb(ref);
  }
}

String _$defaultKeepAliveHash() => r'1c236764d83a62ca442c5d5b4a83bd0d6e4548cf';

typedef KeepAliveFamilyRef = Ref<int>;

@ProviderFor(keepAliveFamily)
const keepAliveFamilyProvider = KeepAliveFamilyFamily._();

final class KeepAliveFamilyProvider extends $FunctionalProvider<int, int>
    with $Provider<int, KeepAliveFamilyRef> {
  const KeepAliveFamilyProvider._(
      {required KeepAliveFamilyFamily super.from,
      required int super.argument,
      int Function(
        KeepAliveFamilyRef ref,
        int a,
      )? create})
      : _createCb = create,
        super(
          name: r'keepAliveFamilyProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    KeepAliveFamilyRef ref,
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
      KeepAliveFamilyRef ref,
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
  int create(KeepAliveFamilyRef ref) {
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

String _$keepAliveFamilyHash() => r'80d684923a104e2488ec281097bf9b5b04b4fa5a';

final class KeepAliveFamilyFamily extends Family {
  const KeepAliveFamilyFamily._()
      : super(
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
      KeepAliveFamilyRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer, provider) {
        provider as KeepAliveFamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

typedef NotKeepAliveFamilyRef = Ref<int>;

@ProviderFor(notKeepAliveFamily)
const notKeepAliveFamilyProvider = NotKeepAliveFamilyFamily._();

final class NotKeepAliveFamilyProvider extends $FunctionalProvider<int, int>
    with $Provider<int, NotKeepAliveFamilyRef> {
  const NotKeepAliveFamilyProvider._(
      {required NotKeepAliveFamilyFamily super.from,
      required int super.argument,
      int Function(
        NotKeepAliveFamilyRef ref,
        int a,
      )? create})
      : _createCb = create,
        super(
          name: r'notKeepAliveFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    NotKeepAliveFamilyRef ref,
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
      NotKeepAliveFamilyRef ref,
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
  int create(NotKeepAliveFamilyRef ref) {
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
    r'9f530635a3310431aff36f0f9150f80c56348a51';

final class NotKeepAliveFamilyFamily extends Family {
  const NotKeepAliveFamilyFamily._()
      : super(
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
      NotKeepAliveFamilyRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer, provider) {
        provider as NotKeepAliveFamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

typedef DefaultKeepAliveFamilyRef = Ref<int>;

@ProviderFor(defaultKeepAliveFamily)
const defaultKeepAliveFamilyProvider = DefaultKeepAliveFamilyFamily._();

final class DefaultKeepAliveFamilyProvider extends $FunctionalProvider<int, int>
    with $Provider<int, DefaultKeepAliveFamilyRef> {
  const DefaultKeepAliveFamilyProvider._(
      {required DefaultKeepAliveFamilyFamily super.from,
      required int super.argument,
      int Function(
        DefaultKeepAliveFamilyRef ref,
        int a,
      )? create})
      : _createCb = create,
        super(
          name: r'defaultKeepAliveFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    DefaultKeepAliveFamilyRef ref,
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
      DefaultKeepAliveFamilyRef ref,
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
  int create(DefaultKeepAliveFamilyRef ref) {
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
    r'a1d9a5a40b8d43983428273ebee0660fe39250ed';

final class DefaultKeepAliveFamilyFamily extends Family {
  const DefaultKeepAliveFamilyFamily._()
      : super(
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
      DefaultKeepAliveFamilyRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer, provider) {
        provider as DefaultKeepAliveFamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
