// ignore_for_file: omit_local_variable_types, unused_local_variable, invalid_use_of_internal_member

import 'package:riverpod/riverpod.dart' show ProviderContainer;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/auto_dispose.dart';

void main() {
  test('Respects keepAlive parameter', () {
    final container = ProviderContainer.test();

    container.read(keepAliveProvider);

    expect(
      container.readProviderElement(keepAliveProvider),
      isA<ProviderElement<Object?>>(),
    );
    expect(
      container.readProviderElement(keepAliveProvider),
      isNot(isA<AutoDisposeProviderElement<Object?>>()),
    );
  });
}
