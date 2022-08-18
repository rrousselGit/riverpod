// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync.g.dart';

@provider
String public(PublicRef ref) {
  return 'Hello world';
}

@provider
String supports$inNames(Supports$inNamesRef ref) {
  return 'Hello world';
}

@provider
String family(
  FamilyRef ref,
  int first, {
  String? second,
  required double third,
  bool forth = true,
  List<String>? fifth,
}) {
  return '(first: $first, second: $second, third: $third, forth: $forth, fifth: $fifth)';
}

const privateProvider = _PrivateProvider;

@provider
String _private(_PrivateRef ref) {
  return 'Hello world';
}

@provider
class PublicClass extends _$PublicClass {
  @override
  String build() {
    return 'Hello world';
  }
}

const privateClassProvider = _PrivateClassProvider;

@provider
class _PrivateClass extends _$PrivateClass {
  @override
  String build() {
    return 'Hello world';
  }
}

@provider
class FamilyClass extends _$FamilyClass {
  @override
  String build(
    int first, {
    String? second,
    required double third,
    bool forth = true,
    List<String>? fifth,
  }) {
    return '(first: $first, second: $second, third: $third, forth: $forth, fifth: $fifth)';
  }
}

@provider
class Supports$InClassName extends _$Supports$InClassName {
  @override
  String build() {
    return 'Hello world';
  }
}
