// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'declaration.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(MyNotifier)
const myNotifierProvider = MyNotifierProvider._();

final class MyNotifierProvider
    extends $AsyncNotifierProvider<MyNotifier, List<Todo>> {
  const MyNotifierProvider._(
      {super.runNotifierBuildOverride, MyNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'myNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MyNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$myNotifierHash();

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
    FutureOr<List<Todo>> Function(
      Ref<AsyncValue<List<Todo>>>,
      MyNotifier,
    ) build,
  ) {
    return MyNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<MyNotifier, List<Todo>> $createElement(
          ProviderContainer container) =>
      $AsyncNotifierProviderElement(this, container);
}

String _$myNotifierHash() => r'fc9a07f8ef9f792da2ac660d76ea0a809335ba18';

abstract class _$MyNotifier extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$internal
  @override
  FutureOr<List<Todo>> runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
