// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'initialization.dart';

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
          retry: null,
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
      Ref,
      MyNotifier,
    ) build,
  ) {
    return MyNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<MyNotifier, List<Todo>> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);
}

String _$myNotifierHash() => r'1c67c12443102cf8c43efbf6c630d3028d9847c3';

abstract class _$MyNotifier extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$internal
  @override
  FutureOr<List<Todo>> runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
