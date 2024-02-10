// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

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

String _$todosHash() => r'3485c14ec4db07efe5fe52243258a66e6f99b2b4';

abstract class _$Todos extends $Notifier<List<Todo>> {
  List<Todo> build();
  @$internal
  @override
  List<Todo> runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
