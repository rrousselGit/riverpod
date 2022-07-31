import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync.g.dart';

@provider
void _publicProvider(ProviderRef<String> ref) {
  ref.state = 'Hello world';
}

@provider
void __privateProvider(ProviderRef<String> ref) {
  ref.state = 'Hello world';
}

@provider
class _PublicClassProvider extends _$PublicClassProvider {
  @override
  void build(Ref<String> ref) {
    state = 'Hello world';
  }
}

@provider
class __PrivateClassProvider extends _$PrivateClassProvider {
  @override
  void build(Ref<String> ref) {
    state = 'Hello world';
  }
}
