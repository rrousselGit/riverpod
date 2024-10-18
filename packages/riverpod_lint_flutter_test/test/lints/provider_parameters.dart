import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_parameters.freezed.dart';
part 'provider_parameters.g.dart';

final legacy = Provider.family<int, Object?>((ref, value) => 0);
final provider = Provider.family<int, Object?>((ref, value) => 0);

@Riverpod(keepAlive: true)
int generator(Ref ref, {Object? value}) => 0;

var list = [42];
final dep = Provider((ref) {
  ref.read(legacy(42));
  ref.read(legacy(list));
  // expect_lint: provider_parameters
  ref.read(legacy([42]));
  ref.listen(legacy(42), (prev, next) {});
  // expect_lint: provider_parameters
  ref.listen(legacy([42]), (prev, next) {});

  ref.watch(legacy(42));
  // expect_lint: provider_parameters
  ref.watch(legacy([42]));
  // expect_lint: provider_parameters
  ref.watch(legacy({'string': 42}));
  // expect_lint: provider_parameters
  ref.watch(legacy({42}));
  ref.watch(legacy(const [42]));
  ref.watch(legacy(const {'string': 42}));
  ref.watch(legacy(const {42}));
  ref.watch(legacy(null));
  // expect_lint: provider_parameters
  ref.watch(legacy(Object()));
  ref.watch(legacy(const Object()));
  ref.watch(legacy(FreezedExample()));

  void fn() {}

  // expect_lint: provider_parameters
  ref.watch(provider(() {}));
  ref.watch(provider(fn));

  ref.watch(legacy(ClassThatOverridesEqual()));
  ref.watch(legacy(const ClassThatOverridesEqual()));
  // expect_lint: provider_parameters
  ref.watch(legacy(Factory.bar()));
  ref.watch(legacy(const Factory.bar()));
  ref.watch(legacy(Factory.foo()));
  ref.watch(legacy(const Factory.foo()));

  ref.watch(generatorProvider(value: 42));
  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: [42]));
  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: {'string': 42}));
  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: {42}));
  ref.watch(generatorProvider(value: const [42]));
  ref.watch(generatorProvider(value: const {'string': 42}));
  ref.watch(generatorProvider(value: const {42}));
  ref.watch(generatorProvider(value: null));
  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: Object()));
  ref.watch(generatorProvider(value: const Object()));

  ref.watch(generatorProvider(value: ClassThatOverridesEqual()));
  ref.watch(generatorProvider(value: const ClassThatOverridesEqual()));

  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: Bar()));
  ref.watch(generatorProvider(value: const Bar()));

  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: Factory.bar()));
  ref.watch(generatorProvider(value: const Factory.bar()));
  ref.watch(generatorProvider(value: Factory.foo()));
  ref.watch(generatorProvider(value: const Factory.foo()));
});

@freezed
class FreezedExample with _$FreezedExample {
  factory FreezedExample() = _FreezedExample;
}

class Bar implements Factory {
  const Bar();
}

class Factory {
  const factory Factory.bar() = Bar;
  const factory Factory.foo() = ClassThatOverridesEqual;
}

class ClassThatOverridesEqual implements Factory {
  const ClassThatOverridesEqual();

  @override
  bool operator ==(Object other) => super == other;

  @override
  int get hashCode => super.hashCode;
}

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(legacy(42));
    // expect_lint: provider_parameters
    ref.read(legacy([42]));
    ref.listen(legacy(42), (prev, next) {});
    // expect_lint: provider_parameters
    ref.listen(legacy([42]), (prev, next) {});
    ref.listenManual(legacy(42), (prev, next) {});
    // expect_lint: provider_parameters
    ref.listenManual(legacy([42]), (prev, next) {});

    ref.watch(legacy(42));
    ref.read(legacy(list));
    // expect_lint: provider_parameters
    ref.watch(legacy([42]));
    // expect_lint: provider_parameters
    ref.watch(legacy({'string': 42}));
    // expect_lint: provider_parameters
    ref.watch(legacy({42}));
    ref.watch(legacy(const [42]));
    ref.watch(legacy(const {'string': 42}));
    ref.watch(legacy(const {42}));
    ref.watch(legacy(null));
    // expect_lint: provider_parameters
    ref.watch(legacy(Object()));
    ref.watch(legacy(const Object()));

    ref.watch(legacy(ClassThatOverridesEqual()));
    ref.watch(legacy(const ClassThatOverridesEqual()));
    // expect_lint: provider_parameters
    ref.watch(legacy(Bar()));
    ref.watch(legacy(const Bar()));
    // expect_lint: provider_parameters
    ref.watch(legacy(Factory.bar()));
    ref.watch(legacy(const Factory.bar()));
    ref.watch(legacy(Factory.foo()));
    ref.watch(legacy(const Factory.foo()));

    ref.watch(generatorProvider(value: 42));
    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: [42]));
    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: {'string': 42}));
    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: {42}));
    ref.watch(generatorProvider(value: const [42]));
    ref.watch(generatorProvider(value: const {'string': 42}));
    ref.watch(generatorProvider(value: const {42}));
    ref.watch(generatorProvider(value: null));
    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: Object()));
    ref.watch(generatorProvider(value: const Object()));

    ref.watch(generatorProvider(value: ClassThatOverridesEqual()));
    ref.watch(generatorProvider(value: const ClassThatOverridesEqual()));

    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: Bar()));
    ref.watch(generatorProvider(value: const Bar()));

    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: Factory.bar()));
    ref.watch(generatorProvider(value: const Factory.bar()));
    ref.watch(generatorProvider(value: Factory.foo()));
    ref.watch(generatorProvider(value: const Factory.foo()));

    return const Placeholder();
  }
}
