import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'protected_notifier_properties.g.dart';

@riverpod
class A extends _$A {
  @override
  int build() => 0;
}

@Riverpod(keepAlive: true)
class A2 extends _$A2 {
  @override
  int build() => 0;
}

@riverpod
class A3 extends _$A3 {
  @override
  int build(int param) => 0;
}

@Riverpod(keepAlive: true)
class A4 extends _$A4 {
  @override
  int build(int param) => 0;
}

@riverpod
class A5 extends _$A5 {
  @override
  Future<int> build(int param) async => 0;
}

@Riverpod(keepAlive: true)
class A6 extends _$A6 {
  @override
  Future<int> build(int param) async => 0;
}

@riverpod
class A7 extends _$A7 {
  @override
  Stream<int> build(int param) => Stream.empty();
}

@Riverpod(keepAlive: true)
class A8 extends _$A8 {
  @override
  Stream<int> build(int param) => Stream.empty();
}

@Riverpod(keepAlive: true)
class B extends _$B {
  @override
  int build() => 0;

  void increment() {
    final obj = Obj();
    obj.state++;

    this.state = 42;

    // expect_lint: protected_notifier_properties
    ref.read(aProvider.notifier).state = 42;

    // expect_lint: protected_notifier_properties
    ref.read(aProvider.notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a2Provider.notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a3Provider(42).notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a4Provider(42).notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a5Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a6Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a7Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).state;

    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).future;
    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).ref;
  }
}

@riverpod
class B2 extends _$B2 {
  @override
  int build() => 0;

  void increment() {
    final obj = Obj();
    obj.state++;

    this.state = 42;

    // expect_lint: protected_notifier_properties
    ref.read(aProvider.notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a2Provider.notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a3Provider(42).notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a4Provider(42).notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a5Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a6Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a7Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).state = AsyncData(42);
  }
}

class Obj {
  int state = 0;
}
