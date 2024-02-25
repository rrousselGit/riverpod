// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'completed_todos.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef CompletedTodosRef = Ref<List<Todo>>;

@ProviderFor(completedTodos)
const completedTodosProvider = CompletedTodosProvider._();

final class CompletedTodosProvider
    extends $FunctionalProvider<List<Todo>, List<Todo>, CompletedTodosRef>
    with $Provider<List<Todo>, CompletedTodosRef> {
  const CompletedTodosProvider._(
      {List<Todo> Function(
        CompletedTodosRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'completedTodosProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<Todo> Function(
    CompletedTodosRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$completedTodosHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Todo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<Todo>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<List<Todo>> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  CompletedTodosProvider $copyWithCreate(
    List<Todo> Function(
      CompletedTodosRef ref,
    ) create,
  ) {
    return CompletedTodosProvider._(create: create);
  }

  @override
  List<Todo> create(CompletedTodosRef ref) {
    final _$cb = _createCb ?? completedTodos;
    return _$cb(ref);
  }
}

String _$completedTodosHash() => r'855706c09268f428696b3b382ae1605818361b83';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
