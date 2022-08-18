// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync.g.dart';

@provider
String _publicProvider(_PublicProviderRef ref) {
  return 'Hello world';
}

@provider
String _supports$inNames(_Supports$inNamesRef ref) {
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
  return '(first: $first, second: $second, third: $third, forth: $forth, fifth: $fifth)';
}

const privateProvider = _PrivateProvider;

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

const privateClassProvider = _PrivateClassProvider;

@provider
class __PrivateClassProvider extends _$PrivateClassProvider {
  @override
  String build() {
    return 'Hello world';
  }
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

@provider
class _Supports$InClassName extends _$Supports$InClassName {
  @override
  String build() {
    return 'Hello world';
  }
}
