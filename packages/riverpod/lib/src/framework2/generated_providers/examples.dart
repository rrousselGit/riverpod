import '../framework.dart';
import 'sync_provider.dart';

part 'examples.g.dart';

const riverpod = Object();

@riverpod
int syncExample(Ref ref) => 42;

@riverpod
int syncExample2(Ref ref, {int? arg = 42}) => 42;

@riverpod
class SyncExampleNotifier extends _$SyncExampleNotifier {
  @override
  int build(Ref<int> ref) => syncExample(ref);
}

@riverpod
class ScopedSyncExampleNotifier extends _$ScopedSyncExampleNotifier {
  @override
  int build(Ref<int> ref);
}
