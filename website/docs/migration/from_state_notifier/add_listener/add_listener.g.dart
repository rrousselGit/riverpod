// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'add_listener.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(MyNotifier)
const myNotifierProvider = MyNotifierProvider._();

final class MyNotifierProvider extends $NotifierProvider<MyNotifier, int> {
  const MyNotifierProvider._(
      {super.runNotifierBuildOverride, MyNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'myNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MyNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$myNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  MyNotifier create() => _createCb?.call() ?? MyNotifier();

  @$internal
  @override
  MyNotifierProvider $copyWithCreate(
    MyNotifier Function() create,
  ) {
    return MyNotifierProvider._(create: create);
  }

  @$internal
  @override
  MyNotifierProvider $copyWithBuild(
    int Function(
      Ref<int>,
      MyNotifier,
    ) build,
  ) {
    return MyNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<MyNotifier, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$myNotifierHash() => r'7ff4b7b8f822ca720b55e2d29ed07d7f0b3485e8';

abstract class _$MyNotifier extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
