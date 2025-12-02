// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incorrect_extends.notifier_extends-0.fix.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WrongExtends)
final wrongExtendsProvider = WrongExtendsProvider._();

final class WrongExtendsProvider extends $NotifierProvider<WrongExtends, int> {
  WrongExtendsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wrongExtendsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wrongExtendsHash();

  @$internal
  @override
  WrongExtends create() => WrongExtends();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$wrongExtendsHash() => r'b1e2c81787da0977aaa5c4604d94c661ec72b26c';

abstract class _$WrongExtends extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
