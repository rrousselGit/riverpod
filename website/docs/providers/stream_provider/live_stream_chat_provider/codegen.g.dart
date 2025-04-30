// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(chat)
const chatProvider = ChatProvider._();

final class ChatProvider
    extends $FunctionalProvider<AsyncValue<List<String>>, Stream<List<String>>>
    with $FutureModifier<List<String>>, $StreamProvider<List<String>> {
  const ChatProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatHash();

  @$internal
  @override
  $StreamProviderElement<List<String>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<String>> create(Ref ref) {
    return chat(ref);
  }
}

String _$chatHash() => r'bad093d5344471463a1e71688281924642f3a58c';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
