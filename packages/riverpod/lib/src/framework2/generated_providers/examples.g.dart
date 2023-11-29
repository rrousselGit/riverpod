part of 'examples.dart';

const syncExampleProvider = SyncExampleProvider._();

final class SyncExampleProvider extends SyncProvider<int> {
  const SyncExampleProvider._()
      : super(
          name: 'syncExample',
          from: null,
          arguments: null,
          debugSource: kDebugMode
              ? 'package:riverpod/src/framework2/generated_providers/examples.dart:syncExample'
              : null,
        );

  @override
  int build(Ref<int> ref) => syncExample(ref);
}
