import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/src/internals.dart';

part 'sync.g.dart';

@provider
String _publicProvider(_PublicProviderRef ref) {
  return 'Hello world';
}

@provider
String _familyExample(
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

@provider
class _MyNotifierFamily extends _$MyNotifierFamily {
  @override
  String build(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  }) {
    return 'Hello world';
  }
}

/// Copied from Dart SDK
class SystemHash {
  SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}
