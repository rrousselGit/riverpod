// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'completed_todos.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(completedTodos)
const completedTodosProvider = CompletedTodosProvider._();

final class CompletedTodosProvider
    extends $FunctionalProvider<List<Todo>, List<Todo>>
    with $Provider<List<Todo>> {
  const CompletedTodosProvider._(
      {List<Todo> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'completedTodosProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<Todo> Function(
    Ref ref,
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
  $ProviderElement<List<Todo>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  CompletedTodosProvider $copyWithCreate(
    List<Todo> Function(
      Ref ref,
    ) create,
  ) {
    return CompletedTodosProvider._(create: create);
  }

  @override
  List<Todo> create(Ref ref) {
    final _$cb = _createCb ?? completedTodos;
    return _$cb(ref);
  }
}

String _$completedTodosHash() => r'0a6a67db7f22556b2cd64236815fdd4d2e72a72b';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
