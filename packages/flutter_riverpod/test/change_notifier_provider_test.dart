import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('can specify name', () {
    final provider = ChangeNotifierProvider(
      (_) => ValueNotifier(0),
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 = ChangeNotifierProvider((_) => ValueNotifier(0));

    expect(provider2.name, isNull);
  });
}
