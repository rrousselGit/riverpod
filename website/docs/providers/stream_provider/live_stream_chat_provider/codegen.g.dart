// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ChatRef = Ref<AsyncValue<List<String>>>;

@ProviderFor(chat)
const chatProvider = ChatProvider._();

final class ChatProvider extends $FunctionalProvider<AsyncValue<List<String>>,
        Stream<List<String>>, ChatRef>
    with $FutureModifier<List<String>>, $StreamProvider<List<String>, ChatRef> {
  const ChatProvider._(
      {Stream<List<String>> Function(
        ChatRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'chatProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<List<String>> Function(
    ChatRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$chatHash();

  @override
  $StreamProviderElement<List<String>> createElement(
          ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  ChatProvider $copyWithCreate(
    Stream<List<String>> Function(
      ChatRef ref,
    ) create,
  ) {
    return ChatProvider._(create: create);
  }

  @override
  Stream<List<String>> create(ChatRef ref) {
    final _$cb = _createCb ?? chat;
    return _$cb(ref);
  }
}

String _$chatHash() => r'db1302132f90e854fe2f5da9d97d89c9a3c8b858';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
