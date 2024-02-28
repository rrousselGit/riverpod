// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'todo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Todos)
const todosProvider = TodosProvider._();

final class TodosProvider extends $NotifierProvider<Todos, List<Todo>> {
  const TodosProvider._(
      {super.runNotifierBuildOverride, Todos Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'todosProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Todos Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$todosHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Todo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<Todo>>(value),
    );
  }

  @$internal
  @override
  Todos create() => _createCb?.call() ?? Todos();

  @$internal
  @override
  TodosProvider $copyWithCreate(
    Todos Function() create,
  ) {
    return TodosProvider._(create: create);
  }

  @$internal
  @override
  TodosProvider $copyWithBuild(
    List<Todo> Function(
      Ref<List<Todo>>,
      Todos,
    ) build,
  ) {
    return TodosProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Todos, List<Todo>> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$todosHash() => r'4bd25c3c15bfff56ad6e733bd17ecb7284c4ceb2';

abstract class _$Todos extends $Notifier<List<Todo>> {
  List<Todo> build();
  @$internal
  @override
  List<Todo> runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
