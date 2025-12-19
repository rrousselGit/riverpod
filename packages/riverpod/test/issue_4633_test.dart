import 'package:riverpod/riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

class Equatable {
  final int id;
  Equatable(this.id);

  @override
  bool operator ==(Object other) => other is Equatable && other.id == id;

  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() => 'Equatable($id)';
}

class MyStateNotifier extends StateNotifier<Equatable> {
  MyStateNotifier() : super(Equatable(0));

  void update() {
    state = Equatable(0);
  }
}

final provider = StateNotifierProvider<MyStateNotifier, Equatable>((ref) => MyStateNotifier());

void main() {
  test('ref.listen should not fire if current and previous are equal (StateNotifier)', () {
    final container = ProviderContainer();
    
    var callCount = 0;

    container.listen<Equatable>(
      provider,
      (p, n) {
        callCount++;
        print('Called with prev: $p, next: $n');
      },
    );

    container.read(provider.notifier).update();

    expect(callCount, 0, reason: 'Listener should not have been called');
  });
}
