// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prefer_keep_alive_annotation.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(first)
final firstProvider = FirstProvider._();

final class FirstProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  FirstProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return first(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$firstHash() => r'7b9e34770604d85caeb07074408b64817d7ed345';

@ProviderFor(FirstClass)
final firstClassProvider = FirstClassProvider._();

final class FirstClassProvider extends $NotifierProvider<FirstClass, int> {
  FirstClassProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstClassProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstClassHash();

  @$internal
  @override
  FirstClass create() => FirstClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$firstClassHash() => r'6a5004038f173c3e49d67935acbfaed7960dd3df';

abstract class _$FirstClass extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(alreadyAnnotated)
final alreadyAnnotatedProvider = AlreadyAnnotatedProvider._();

final class AlreadyAnnotatedProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  AlreadyAnnotatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alreadyAnnotatedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alreadyAnnotatedHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return alreadyAnnotated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$alreadyAnnotatedHash() => r'6ac70a6a440bddd648030276d61c7ab1efd5b561';

@ProviderFor(conditional)
final conditionalProvider = ConditionalFamily._();

final class ConditionalProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  ConditionalProvider._({
    required ConditionalFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'conditionalProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$conditionalHash();

  @override
  String toString() {
    return r'conditionalProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as bool;
    return conditional(ref, condition: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConditionalProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conditionalHash() => r'916ef9f1cd7025c9114e69753d2ecc0c3310c3a2';

final class ConditionalFamily extends $Family
    with $FunctionalFamilyOverride<int, bool> {
  ConditionalFamily._()
    : super(
        retry: null,
        name: r'conditionalProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ConditionalProvider call({required bool condition}) =>
      ConditionalProvider._(argument: condition, from: this);

  @override
  String toString() => r'conditionalProvider';
}

@ProviderFor(afterAwait)
final afterAwaitProvider = AfterAwaitProvider._();

final class AfterAwaitProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  AfterAwaitProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'afterAwaitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$afterAwaitHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return afterAwait(ref);
  }
}

String _$afterAwaitHash() => r'4fd1dcc0f6f5a6c1f8c7c8cc75fe4a07c99e3b80';

@ProviderFor(linkKept)
final linkKeptProvider = LinkKeptProvider._();

final class LinkKeptProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  LinkKeptProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkKeptProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkKeptHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return linkKept(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$linkKeptHash() => r'5db340f5997490b9c9975a2d723d8786891680da';

@ProviderFor(notFirst)
final notFirstProvider = NotFirstProvider._();

final class NotFirstProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  NotFirstProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notFirstProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notFirstHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return notFirst(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$notFirstHash() => r'acedba5d6352c69a96108680e9ce1346be7d55dc';

@ProviderFor(insideClosure)
final insideClosureProvider = InsideClosureProvider._();

final class InsideClosureProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  InsideClosureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insideClosureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insideClosureHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return insideClosure(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$insideClosureHash() => r'3ed516b839f4a2a0f9c2e8531ee6b8a5d1206bc9';

@ProviderFor(NotBuild)
final notBuildProvider = NotBuildProvider._();

final class NotBuildProvider extends $NotifierProvider<NotBuild, int> {
  NotBuildProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notBuildProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notBuildHash();

  @$internal
  @override
  NotBuild create() => NotBuild();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$notBuildHash() => r'e221abc502cfeb624a9fccfde1baa9266792e1bd';

abstract class _$NotBuild extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
