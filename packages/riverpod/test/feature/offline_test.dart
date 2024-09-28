import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

void main() {
  group('Offline', () {
    test('Legacy providers have type-safe adapters', () {
      // Using `dynamic` for any types we don't care about
      final ProviderBase<int> provider = Provider((ref) => 0);
      Persist<int>? options = provider.persist;

      final FunctionalFamily<int, dynamic, dynamic, dynamic> family =
          Provider.family<int, dynamic>((ref, _) => 0);
      options = family.persist;

      final ClassFamily<dynamic, int, dynamic, dynamic, dynamic> classFamily =
          NotifierProvider.family<FamilyNotifier<int, dynamic>, int, dynamic>(
        () => throw UnimplementedError(),
      );

      options = classFamily.persist;
    });

    test('Can destroy the whole cache using a global destroyKey', () {});

    test('Can destroy a provider using a provider-specific destroyKey', () {});

    test('If a provider has a destroyKey, it still respects the global one',
        () {});

    test('When opted in, initializes a provider based on the DB value', () {});

    test('Can specify an adapter on $ProviderContainer', () {});

    test(
        '$ProviderContainer throws a provider opted to offline but no adapter is found',
        () {});

    test('Providers can specify their adapter', () {});

    test('Adapters support synchronously emitting values from the DB', () {});

    test('Adapters support asynchronously emitting values from the DB', () {});

    test('If a provider sets a value before an asynchronous adapter, it wins',
        () {});

    test('Can specify a destroyKey on a provider', () {});

    test(
        'Initializing a provider with a destroyKey throws if the provider did not opt-in to offline',
        () {});

    test('AsyncValue has a field to know if the value is from the DB or not',
        () {});

    test('Notifiers have a way to await the DB reads', () {});
    test('Notifiers have a way to await the DB writes', () {});

    test('When a provider emits an update, notify the DB adapter', () {});

    test(
        'When creating a $ProviderContainer, notify the DB adapter of the list of opted-in providers',
        () {});

    test('Rebuilding a provider does not re-initialize the value from DB',
        () {});

    test(
        'If a provider is fully disposed, remounting it restores value from DB',
        () {});

    test('ProviderScope throws if `offline` changes on update', () {});

    test('ProviderScope throws if `offline` is specified but not adapter',
        () {});

    test("Scoped providers opted-in to offline use their container's adapter",
        () {});

    test('overrideWithValue does not ask adapters for initializations', () {});

    test('overrideWith does ask adapters for initializations', () {});

    test('Give adapters the list of static members of a Model', () {});

    test('Supports Map<Model, Model2>', () {});

    test('Primitive types do not need specific encoding methods', () {});

    test('$ProviderContainer can dump the DB state', () {});

    test(
        'Families can opt-in to offline, as long as their arguments are supported by the adapter',
        () {});

    test('Supports generics providers', () {});

    test('Verify that unused Model static members are tree-shaken away', () {});
    test('Verify that unused Model methods are tree-shaken away', () {});
  });
}
