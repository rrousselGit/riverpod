import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dependencies.g.dart';

final stateProvider = StateProvider((ref) => '');

@Riverpod(
  dependencies: [
    _private,
    'stateProvider',
    FamilyClass,
    _PrivateClass,
    PublicClass
  ],
)
String public(PublicRef ref) {
  return 'Hello world';
}

final privateProvider = _privateProvider;

@Riverpod(dependencies: [])
Future<String> _private(_PrivateRef ref) async {
  return 'Hello world';
}

@Riverpod(dependencies: [public])
class PublicClass extends _$PublicClass {
  @override
  String build() {
    return 'Hello world';
  }
}

@Riverpod(dependencies: [public])
class _PrivateClass extends _$PrivateClass {
  @override
  String build() {
    return 'Hello world';
  }
}

@Riverpod(dependencies: [public])
class FamilyClass extends _$FamilyClass {
  @override
  String build(String value) {
    return 'Hello $value';
  }
}

@Riverpod(dependencies: [public, 'stateProvider'])
class FamilyClassString extends _$FamilyClassString {
  @override
  String build(String value) {
    return 'Hello $value';
  }
}
