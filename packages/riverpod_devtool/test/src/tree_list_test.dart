import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/tree_list.dart';

class TestNode extends Node<TestNode> {
  TestNode(
    this.name, {
    List<TestNode>? children,
    void Function(String)? onRemove,
  }) : children = children ?? const [],
       _onRemove = onRemove;

  final String name;
  @override
  final List<TestNode> children;
  final void Function(String)? _onRemove;

  @override
  void onRemove() => _onRemove?.call(name);
}

List<int> _entryLengths(TreeList<TestNode> tree) {
  return [for (final entry in tree.debugEntries) entry.length];
}

void main() {
  group('TreeList', () {
    test('starts empty', () {
      final tree = TreeList<TestNode>();

      expect(tree.isEmpty, isTrue);
      expect(tree.length, 0);
    });

    test('adds nodes depth-first', () {
      final tree = TreeList<TestNode>();
      final root = TestNode(
        'root',
        children: [
          TestNode('child-1'),
          TestNode('child-2', children: [TestNode('grandchild')]),
        ],
      );

      tree.add(root);

      expect(tree.length, 4);
      expect(
        [for (var i = 0; i < tree.length; i++) tree[i].name],
        ['root', 'child-1', 'child-2', 'grandchild'],
      );
      expect(_entryLengths(tree), [4, 1, 2, 1]);
      expect(tree.indexWhere((node) => node.name == 'child-2'), 2);
      expect(tree.indexWhere((node) => node.name == 'missing'), isNull);
    });

    test('removeAt removes a whole subtree and calls onRemove', () {
      final removed = <String>[];
      final tree = TreeList<TestNode>();
      tree.add(
        TestNode(
          'root',
          onRemove: removed.add,
          children: [
            TestNode('child', onRemove: removed.add),
            TestNode('grandchild', onRemove: removed.add),
          ],
        ),
      );
      tree.add(TestNode('sibling'));

      tree.removeAt(0);

      expect(tree.length, 1);
      expect(tree[0].name, 'sibling');
      expect(removed, ['root', 'child', 'grandchild']);
    });

    test(
      'replacing a node swaps its subtree and disposes the previous one',
      () {
        final removed = <String>[];
        final tree = TreeList<TestNode>();
        tree.add(
          TestNode(
            'old-root',
            onRemove: removed.add,
            children: [TestNode('old-child', onRemove: removed.add)],
          ),
        );

        tree[0] = TestNode(
          'new-root',
          children: [TestNode('new-child-1'), TestNode('new-child-2')],
        );

        expect(removed, ['old-root', 'old-child']);
        expect(
          [for (var i = 0; i < tree.length; i++) tree[i].name],
          ['new-root', 'new-child-1', 'new-child-2'],
        );
      },
    );

    test('replacing a nested subtree updates ancestor spans', () {
      final removed = <String>[];
      final tree = TreeList<TestNode>();
      tree.add(
        TestNode(
          'root',
          onRemove: removed.add,
          children: [
            TestNode(
              'branch',
              onRemove: removed.add,
              children: [TestNode('leaf', onRemove: removed.add)],
            ),
            TestNode('sibling', onRemove: removed.add),
          ],
        ),
      );
      tree.add(
        TestNode(
          'other-root',
          onRemove: removed.add,
          children: [TestNode('other-child', onRemove: removed.add)],
        ),
      );

      tree[1] = TestNode(
        'branch-2',
        onRemove: removed.add,
        children: [
          TestNode('leaf-1', onRemove: removed.add),
          TestNode('leaf-2', onRemove: removed.add),
        ],
      );

      expect(
        [for (var i = 0; i < tree.length; i++) tree[i].name],
        [
          'root',
          'branch-2',
          'leaf-1',
          'leaf-2',
          'sibling',
          'other-root',
          'other-child',
        ],
      );
      expect(_entryLengths(tree), [5, 3, 1, 1, 1, 2, 1]);

      tree.removeAt(0);

      expect(
        [for (var i = 0; i < tree.length; i++) tree[i].name],
        ['other-root', 'other-child'],
      );
      expect(_entryLengths(tree), [2, 1]);
      expect(removed, [
        'branch',
        'leaf',
        'root',
        'branch-2',
        'leaf-1',
        'leaf-2',
        'sibling',
      ]);
    });

    test('removing a nested subtree updates ancestor spans', () {
      final removed = <String>[];
      final tree = TreeList<TestNode>();
      tree.add(
        TestNode(
          'root',
          onRemove: removed.add,
          children: [
            TestNode(
              'branch',
              onRemove: removed.add,
              children: [TestNode('leaf', onRemove: removed.add)],
            ),
            TestNode('sibling', onRemove: removed.add),
          ],
        ),
      );
      tree.add(
        TestNode(
          'other-root',
          onRemove: removed.add,
          children: [TestNode('other-child', onRemove: removed.add)],
        ),
      );

      tree.removeAt(1);

      expect(
        [for (var i = 0; i < tree.length; i++) tree[i].name],
        ['root', 'sibling', 'other-root', 'other-child'],
      );
      expect(_entryLengths(tree), [2, 1, 2, 1]);

      tree.removeAt(0);

      expect(
        [for (var i = 0; i < tree.length; i++) tree[i].name],
        ['other-root', 'other-child'],
      );
      expect(_entryLengths(tree), [2, 1]);
      expect(removed, ['branch', 'leaf', 'root', 'sibling']);
    });

    test('modifying the second root does not impact the first root', () {
      final removed = <String>[];
      final tree = TreeList<TestNode>();
      tree.add(
        TestNode(
          'root',
          onRemove: removed.add,
          children: [
            TestNode('child', onRemove: removed.add),
            TestNode('sibling', onRemove: removed.add),
          ],
        ),
      );
      tree.add(
        TestNode(
          'other-root',
          onRemove: removed.add,
          children: [
            TestNode(
              'other-branch',
              onRemove: removed.add,
              children: [TestNode('other-leaf', onRemove: removed.add)],
            ),
          ],
        ),
      );

      tree[4] = TestNode(
        'other-branch-2',
        onRemove: removed.add,
        children: [
          TestNode('other-leaf-1', onRemove: removed.add),
          TestNode('other-leaf-2', onRemove: removed.add),
        ],
      );

      expect(
        [for (var i = 0; i < tree.length; i++) tree[i].name],
        [
          'root',
          'child',
          'sibling',
          'other-root',
          'other-branch-2',
          'other-leaf-1',
          'other-leaf-2',
        ],
      );
      expect(_entryLengths(tree), [3, 1, 1, 4, 3, 1, 1]);
      expect(removed, ['other-branch', 'other-leaf']);
    });
  });
}
