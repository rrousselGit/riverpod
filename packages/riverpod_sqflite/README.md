<p>
  <a href="https://flutter.dev/docs/development/packages-and-plugins/favorites">
    <img src="https://raw.githubusercontent.com/rrousselGit/riverpod/master/resources/flutter_favorite.png" width="100" align="left" />
  </a>
  <a href="https://github.com/rrousselGit/riverpod/actions"><img src="https://github.com/rrousselGit/riverpod/workflows/Build/badge.svg" alt="Build Status"></a>
  <a href="https://codecov.io/gh/rrousselgit/riverpod"><img src="https://codecov.io/gh/rrousselgit/riverpod/branch/master/graph/badge.svg" alt="codecov"></a>
  <a href="https://github.com/rrousselgit/riverpod"><img src="https://img.shields.io/github/stars/rrousselgit/riverpod.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
  <a href="https://discord.gg/GSt793j6eT"><img src="https://img.shields.io/discord/765557403865186374.svg?logo=discord&color=blue" alt="Discord"></a>

  <p>
    <a href="https://www.netlify.com">
      <img src="https://www.netlify.com/img/global/badges/netlify-color-accent.svg" alt="Deploys by Netlify" />
    </a>
  </p>

</p>

<p align="center">
  <img src="https://github.com/rrousselGit/riverpod/blob/master/resources/icon/Facebook%20Cover%20A.png?raw=true" width="100%" alt="Riverpod" />
</p>

---

Say Hi to Riverpod_sqflite!

This is an official implementation of offline-persistence in Riverpod
using Sqflite.

## Usage

First, you need to create a connector to the database. This can be done by creating a `storageProvider`:

```dart
final storageProvider = FutureProvider<JsonSqFliteStorage>((ref) async {
  // Initialize SQFlite. We should share the Storage instance between providers.
  return JsonSqFliteStorage.open(
    join(await getDatabasesPath(), 'riverpod.db'),
  );
});
```

Then, create a `Notifier`, mix-in `Persistable` and then invoke `persist` inside `Notifier.build`:

```dart
class TodosNotifier extends AsyncNotifier<List<Todo>> {
  @override
  FutureOr<List<Todo>> build() async {
    // We call persist at the start of our `build` method.
    // This will:
    // - Read the DB and update the state with the persisted value the first
    //   time this method executes.
    // - Listen to changes on this provider and write those changes to the DB.
    // We "await" for persist to complete to make sure that the decoding is done
    // before we return the state.
    // If you do not care about the decoded value, don't await the future.
    await persist(
      // We pass our JsonSqFliteStorage instance. No need to "await" the Future.
      // Riverpod will take care of that.
      ref.watch(storageProvider.future),
      // A unique key for this state.
      // No other provider should use the same key.
      key: 'todos',
      // By default, state is cached offline only for 2 days.
      // In this example, we tell Riverpod to cache the state forever.
      options: const StorageOptions(cacheTime: StorageCacheTime.unsafe_forever),
      encode: jsonEncode,
      decode: (json) {
        final decoded = jsonDecode(json) as List;
        return decoded
            .map((e) => Todo.fromJson(e as Map<String, Object?>))
            .toList();
      },
    ).future;

    // If a state is persisted, we return it. Otherwise we return an empty list.
    return state.value ?? [];
  }

  Future<void> add(Todo todo) async {
    // When modifying the state, no need for any extra logic to persist the change.
    // Riverpod will automatically cache the new state and write it to the DB.
    state = AsyncData([...await future, todo]);
  }
}
```