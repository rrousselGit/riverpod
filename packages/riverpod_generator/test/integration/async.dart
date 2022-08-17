import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async.g.dart';

@provider
Future<String> _publicProvider(_PublicProviderRef ref) async {
  return 'Hello world';
}

@provider
Future<String> __privateProvider(__PrivateProviderRef ref) async {
  return 'Hello world';
}

@provider
class _PublicClassProvider extends _$PublicClassProvider {
  @override
  Future<String> build() async {
    return 'Hello world';
  }
}

@provider
class __PrivateClassProvider extends _$PrivateClassProvider {
  @override
  Future<String> build() async {
    return 'Hello world';
  }
}

void main() {
  final container = ProviderContainer();

  final x = container.read(PublicProvider);
  final y = container.read(PublicClassProvider);
}
