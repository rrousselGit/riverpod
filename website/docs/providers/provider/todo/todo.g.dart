// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'todo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

@ProviderFor(Todos)
const todosProvider = TodosProvider._();

final class TodosProvider extends $NotifierProvider<Todos, List<Todo>> {
  const TodosProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todosProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todosHash();

  @$internal
  @override
  Todos create() => Todos();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Todo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Todo>>(value),
    );
  }
}

String _$todosHash() => r'4bd25c3c15bfff56ad6e733bd17ecb7284c4ceb2';

abstract class _$Todos extends $Notifier<List<Todo>> {
  List<Todo> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Todo>, List<Todo>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<Todo>, List<Todo>>, List<Todo>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
