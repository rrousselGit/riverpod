import 'package:riverpod/src/internals.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mutation.g.dart';

@riverpod
class Simple extends _$Simple {
  @override
  int build() => 0;

  @mutation
  Future<int> increment([int inc = 1]) async => state + inc;

  @mutation
  FutureOr<int> incrementOr() => state + 1;

  @mutation
  Future<int> delegated(Future<int> Function() fn) => fn();
}

@riverpod
class SimpleFamily extends _$SimpleFamily {
  @override
  int build(String arg) => 0;

  @mutation
  Future<int> increment([int inc = 1]) async => state + inc;

  @mutation
  FutureOr<int> incrementOr() => state + 1;
}

@riverpod
class SimpleAsync extends _$SimpleAsync {
  @override
  Future<int> build() async => 0;

  @mutation
  Future<int> increment([int inc = 1]) async => (await future) + inc;

  @mutation
  Future<int> delegated(Future<int> Function() fn) async {
    await future;
    return fn();
  }
}

@riverpod
class SimpleAsync2 extends _$SimpleAsync2 {
  @override
  Stream<int> build(String arg) => Stream.value(0);

  @mutation
  Future<int> increment() async => (await future) + 1;
}

@riverpod
class Generic<T extends num> extends _$Generic<T> {
  @override
  Future<int> build() async => 0;

  @mutation
  Future<int> increment() async => (await future) + 1;
}

@riverpod
class GenericMut extends _$GenericMut {
  @override
  Future<int> build() async => 0;

  @mutation
  Future<int> increment<T extends num>(T value) async =>
      (await future) + value.ceil();
}

@riverpod
class FailingCtor extends _$FailingCtor {
  FailingCtor() {
    throw StateError('err');
  }

  @override
  int build() => 0;

  @mutation
  Future<int> increment([int inc = 1]) async => state + inc;
}

@riverpod
class Typed extends _$Typed {
  @override
  String build() => 'typed';

  @mutation
  Future<String> mutate(String one,
          {required String two, required String three}) async =>
      '$one $two $three';
}

// final mut = ref.watch(aProvider(arg).increment);
// mut(2);

// class User {
//   final String id;
// }

// class UserSub extends User {}

// class IList<T> extends List<T> {}

// @Repository(retry: retry)
// class Users extends _$Users {
//   @riverpod
//   FutureOr<User> byId(String id) => User();

//   @riverpod
//   Future<List<User>> home() async => [];

//   @riverpod
//   Future<List<User>> search(String search) async => [];

//   @riverpod
//   Future<IList<User>> search(String search) async => [];

//   @riverpod
//   Future<List<UserSub>> search(String search) async => [];

//   @riverpod
//   Stream<List<User>> socketSearch(String search) async => [];

//   @mutation
//   Future<User> addUser(User user) async {
//     return user;
//   }
// }

// abstract class Repository<KeyT, StateT> {
//   Map<KeyT, AsyncValue<StateT>> _all;

//   KeyT key(StateT state);

//   void build(Ref ref);
// }

// abstract class _$Users extends Repository<String, User> {
//   // User has a .id, so we automatically pick it up as the key
//   @override
//   String key(User user) => user.id;

//   @override
//   void build(ref) {
//     observe(providerOrFamily, onAdd: (provider, key, value) {
//       ref.mutate((state) => state.add(value));
//     }, onUpdate);
//   }
// }

// // ref.watch(usersProvider.byId('123'));
// // ref.watch(usersProvider.home);
// // ref.watch(usersProvider.search('john'));
