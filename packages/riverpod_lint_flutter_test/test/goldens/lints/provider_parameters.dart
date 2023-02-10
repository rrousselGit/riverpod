import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_parameters.g.dart';

final legacy = Provider.family<int, Object?>((ref, value) => 0);

@Riverpod(keepAlive: true)
int generator(GeneratorRef ref, {Object? value}) => 0;

final provider = Provider((ref) {
  ref.read(legacy(42));
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
  ref.watch(legacy(Object()));
  ref.watch(legacy(const Object()));

  ref.watch(legacy(Foo()));
  ref.watch(legacy(const Foo()));
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
  ref.watch(generatorProvider(value: Object()));
  ref.watch(generatorProvider(value: const Object()));

  ref.watch(generatorProvider(value: Foo()));
  ref.watch(generatorProvider(value: const Foo()));

  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: Bar()));
  ref.watch(generatorProvider(value: const Bar()));

  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: Factory.bar()));
  ref.watch(generatorProvider(value: const Factory.bar()));
  ref.watch(generatorProvider(value: Factory.foo()));
  ref.watch(generatorProvider(value: const Factory.foo()));
});

class Bar implements Factory {
  const Bar();
}

class Factory {
  const factory Factory.bar() = Bar;
  const factory Factory.foo() = Foo;
}

class Foo implements Factory {
  const Foo();

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
    ref.watch(legacy(Object()));
    ref.watch(legacy(const Object()));

    ref.watch(legacy(Foo()));
    ref.watch(legacy(const Foo()));
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
    ref.watch(generatorProvider(value: Object()));
    ref.watch(generatorProvider(value: const Object()));

    ref.watch(generatorProvider(value: Foo()));
    ref.watch(generatorProvider(value: const Foo()));

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
