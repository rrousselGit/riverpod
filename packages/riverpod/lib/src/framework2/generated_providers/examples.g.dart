part of 'examples.dart';

const syncExampleProvider = SyncExampleProvider._();

final class SyncExampleProvider extends SyncProvider<int> {
  const SyncExampleProvider._()
      : super(
          name: 'syncExample',
          from: null,
          arguments: null,
          debugSource: kDebugMode
              ? const DebugProviderSource(
                  name: 'syncExample',
                  file:
                      'package:riverpod/src/framework2/generated_providers/examples.dart:syncExample',
                  line: 42,
                  column: 42,
                  hash: '123',
                )
              : null,
        );

  @override
  int build(Ref<int> ref) => syncExample(ref);

  static ProviderContainer? _$root;

  /// For unscoped providers, we can circumvent the override and map lookup
  /// by statically caching the element.
  /// This is only a performance optimization and should not be relied upon.
  static ProviderElement<int>? _$element;

  @override
  ProviderElement<int> getElement(ProviderContainer container) {
    final target = container.root ?? container;

    final element = _$element;
    if (element != null && _$root == target) return element;

    return _$element = super.getElement(_$root = target);
  }
}
