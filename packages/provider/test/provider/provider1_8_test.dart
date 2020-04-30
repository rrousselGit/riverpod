import 'package:test/test.dart';
import 'package:provider/provider.dart';

void main() {
  final dependency = Provider((_) => 1);
  final dependency2 = Provider((_) => '2');

  test('Provider1', () {
    final owner = ProviderStateOwner();

    final provider = ProviderBuilder<int>() //
        .add(dependency)
        .build((state, first) {
      // TODO shouldn't have onDispose
      return first.value * 2;
    });

    expect(provider.readOwner(owner), 2);

    owner.dispose();
  });
  test('Provider2', () {
    final owner = ProviderStateOwner();

    final provider = ProviderBuilder<String>() //
        .add(dependency)
        .add(dependency2)
        .build((state, first, second) {
      return '${first.value} ${second.value}';
    });

    expect(provider.readOwner(owner), '1 2');

    owner.dispose();
  });
}
