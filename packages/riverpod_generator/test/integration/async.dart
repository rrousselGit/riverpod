// ignore_for_file: omit_local_variable_types, prefer_final_locals, unused_local_variable

import 'package:riverpod/riverpod.dart';
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
FutureOr<String> _familyExample(
  _FamilyExampleRef ref,
  int first, {
  String? second,
  required double third,
  bool forth = true,
  List<String>? fifth,
}) {
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

  AsyncValue<String> x = container.read(PublicProvider);
  AsyncValue<String> y = container.read(PublicClassProvider);
}

@provider
class _MyNotifierFamily extends _$MyNotifierFamily {
  @override
  FutureOr<String> build(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  }) {
    return 'Hello world';
  }
}
