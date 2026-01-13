// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'functional_ref.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(nameless)
final namelessProvider = NamelessProvider._();

final class NamelessProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  NamelessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'namelessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$namelessHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return nameless(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$namelessHash() => r'1a2aa61445a64c65301051820b159c5998195606';

@ProviderFor(generics)
final genericsProvider = GenericsFamily._();

final class GenericsProvider<FirstT extends num, SecondT>
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  GenericsProvider._({required GenericsFamily super.from})
    : super(
        argument: null,
        retry: null,
        name: r'genericsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genericsHash();

  @override
  String toString() {
    return r'genericsProvider'
        '<${FirstT}, ${SecondT}>'
        '()';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return generics<FirstT, SecondT>(ref);
  }

  $R _captureGenerics<$R>($R Function<FirstT extends num, SecondT>() cb) {
    return cb<FirstT, SecondT>();
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
    return other is GenericsProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$genericsHash() => r'1be04375e21867a7ee12713e088b8aea9e820d73';

final class GenericsFamily extends $Family {
  GenericsFamily._()
    : super(
        retry: null,
        name: r'genericsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GenericsProvider<FirstT, SecondT> call<FirstT extends num, SecondT>() =>
      GenericsProvider<FirstT, SecondT>._(from: this);

  @override
  String toString() => r'genericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function<FirstT extends num, SecondT>(Ref ref) create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as GenericsProvider;
      return provider._captureGenerics(<FirstT extends num, SecondT>() {
        provider as GenericsProvider<FirstT, SecondT>;
        return provider
            .$view(create: create<FirstT, SecondT>)
            .$createElement(pointer);
      });
    },
  );
}

@ProviderFor(valid)
final validProvider = ValidProvider._();

final class ValidProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  ValidProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'validProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$validHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return valid(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$validHash() => r'f33913278e3b1615927fe05b3e6e1f781da7729a';
