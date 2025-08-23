// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'async_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AsyncTodosNotifier)
const asyncTodosProvider = AsyncTodosNotifierProvider._();

final class AsyncTodosNotifierProvider
    extends $AsyncNotifierProvider<AsyncTodosNotifier, List<Todo>> {
  const AsyncTodosNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'asyncTodosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$asyncTodosNotifierHash();

  @$internal
  @override
  AsyncTodosNotifier create() => AsyncTodosNotifier();
}

String _$asyncTodosNotifierHash() =>
    r'10207327c7dee180e9da8beece5bfffedcf86e98';

abstract class _$AsyncTodosNotifier extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Todo>>, List<Todo>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Todo>>, List<Todo>>,
              AsyncValue<List<Todo>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
