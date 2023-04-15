// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/auto_dispose.dart';
import 'utils.dart';

void main() {
  test('Respects keepAlive parameter', () {
    final container = createContainer();

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
