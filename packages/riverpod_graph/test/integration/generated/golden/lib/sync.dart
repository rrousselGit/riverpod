import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync.g.dart';

/// A public generated provider.
@riverpod
String public(Ref ref) {
  return 'Hello world';
}

/// A generated provider with a '$' in its name.
@riverpod
String supports$inNames(Ref ref) {
  return ref.watch(publicProvider);
}

/// A generated family provider.
@riverpod
String family(
  Ref ref,
  int first, {
  String? second,
  required double third,
  bool forth = true,
  List<String>? fifth,
}) {
  ref.watch(publicProvider);
  return '(first: $first, second: $second, third: $third, forth: $forth, fifth: $fifth)';
}

/// A private generated provider.
final AutoDisposeProvider<String> privateProvider = _privateProvider;

@riverpod
String _private(Ref ref) {
  return ref.watch(publicProvider);
}

/// A generated public provider from a class
@riverpod
class PublicClass extends _$PublicClass {
  @override
  String build() {
    return ref.watch(publicProvider);
  }
}

/// A private generate provider from a class.
final privateClassProvider = _privateClassProvider;

@riverpod
class _PrivateClass extends _$PrivateClass {
  @override
  String build() {
    return ref.watch(publicProvider);
  }
}

/// A generated family provider from a class.
@riverpod
class FamilyClass extends _$FamilyClass {
  @override
  String build(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  }) {
    ref.watch(publicProvider);
    return '(first: $first, second: $second, third: $third, forth: $forth, fifth: $fifth)';
  }
}

/// A generated provider from a class with a '$' in its name.
@riverpod
class Supports$InClassName extends _$Supports$InClassName {
  @override
  String build() {
    return ref.watch(publicProvider);
  }
}
