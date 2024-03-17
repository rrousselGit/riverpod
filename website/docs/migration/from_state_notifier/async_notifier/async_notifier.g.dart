// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'async_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AsyncTodosNotifier)
const asyncTodosNotifierProvider = AsyncTodosNotifierProvider._();

final class AsyncTodosNotifierProvider
    extends $AsyncNotifierProvider<AsyncTodosNotifier, List<Todo>> {
  const AsyncTodosNotifierProvider._(
      {super.runNotifierBuildOverride, AsyncTodosNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'asyncTodosNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final AsyncTodosNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$asyncTodosNotifierHash();

  @$internal
  @override
  AsyncTodosNotifier create() => _createCb?.call() ?? AsyncTodosNotifier();

  @$internal
  @override
  AsyncTodosNotifierProvider $copyWithCreate(
    AsyncTodosNotifier Function() create,
  ) {
    return AsyncTodosNotifierProvider._(create: create);
  }

  @$internal
  @override
  AsyncTodosNotifierProvider $copyWithBuild(
    FutureOr<List<Todo>> Function(
      Ref<AsyncValue<List<Todo>>>,
      AsyncTodosNotifier,
    ) build,
  ) {
    return AsyncTodosNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<AsyncTodosNotifier, List<Todo>> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);
}

String _$asyncTodosNotifierHash() =>
    r'10207327c7dee180e9da8beece5bfffedcf86e98';

abstract class _$AsyncTodosNotifier extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$internal
  @override
  FutureOr<List<Todo>> runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
