import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  test('probe: overriding one instance of an inherited no-deps family', () {
    final family = Provider.family<String, int>((ref, id) => 'root $id');

    final root = ProviderContainer.test();
    expect(root.read(family(1)), 'root 1');
    expect(root.read(family(2)), 'root 2');

    final child = ProviderContainer.test(
      parent: root,
      overrides: [family(1).overrideWithValue('child 1')],
    );

    expect(child.read(family(1)), 'child 1');
    // The question: did writing the child's override leak into the root?
    expect(root.read(family(1)), 'root 1', reason: 'root must be unaffected');
  });
}
