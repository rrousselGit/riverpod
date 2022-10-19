import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async.g.dart';

@riverpod
FutureOr<String> public(PublicRef ref) {
  return 'Hello world';
}

final privateProvider = _privateProvider;

@riverpod
Future<String> _private(_PrivateRef ref) async {
  return 'Hello world';
}

@Riverpod(dependencies: [PublicClass, public])
FutureOr<String> family(
  FamilyRef ref,
  int first, {
  String? second,
  required double third,
  bool fourth = true,
  List<String>? fifth,
}) {
  ref.watch(privateClassProvider);
  ref.watch(publicProvider);
  return '(first: $first, second: $second, third: $third, fourth: $fourth, fifth: $fifth)';
}

@riverpod
class PublicClass extends _$PublicClass {
  @override
  FutureOr<String> build() {
    return 'Hello world';
  }
}

final privateClassProvider = _privateClassProvider;

@riverpod
class _PrivateClass extends _$PrivateClass {
  @override
  Future<String> build() async {
    return 'Hello world';
  }
}

final stateProvider = StateProvider((ref) => '');

@Riverpod(dependencies: [public, family, 'stateProvider'])
class FamilyClass extends _$FamilyClass {
  @override
  FutureOr<String> build(
    int first, {
    String? second,
    required double third,
    bool fourth = true,
    List<String>? fifth,
  }) {
    ref.watch(publicProvider);

    return '(first: $first, second: $second, third: $third, fourth: $fourth, fifth: $fifth)';
  }

  void hi() {
    ref.read(familyProvider(1, third: 2));
  }
}
