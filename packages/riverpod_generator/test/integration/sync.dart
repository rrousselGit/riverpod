import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/src/internals.dart';

part 'sync.g.dart';

@provider
String _publicProvider(_PublicProviderRef ref) {
  return 'Hello world';
}

@provider
String _family(
  _FamilyRef ref,
  int first, {
  String? second,
  required double third,
  bool forth = true,
  List<String>? fifth,
}) {
  return 'Hello world';
}

@provider
String __privateProvider(__PrivateProviderRef ref) {
  return 'Hello world';
}

@provider
class _PublicClassProvider extends _$PublicClassProvider {
  @override
  String build() {
    return 'Hello world';
  }
}

@provider
class _ClassFamily extends _$ClassFamily {
  @override
  String build() {
    return 'Hello world';
  }
}

@provider
class __PrivateClassProvider extends _$PrivateClassProvider {
  @override
  String build() {
    return 'Hello world';
  }
}

void main() {
  final container = ProviderContainer();

  final x = container.read(PublicProvider);
  final y = container.read(PublicClassProvider);
}
