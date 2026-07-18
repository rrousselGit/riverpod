@TestFor.provider_parameters
library;

import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_annotation.dart';

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
  // ignore: riverpod_lint/provider_parameters
  ref.read(legacy([42]));
  ref.listen(legacy(42), (prev, next) {});
  // ignore: riverpod_lint/provider_parameters
  ref.listen(legacy([42]), (prev, next) {});

  ref.watch(legacy(42));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy([42]));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy({'string': 42}));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy({42}));
  ref.watch(legacy(const [42]));
  ref.watch(legacy(const {'string': 42}));
  ref.watch(legacy(const {42}));
  ref.watch(legacy(null));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy(Object()));
  ref.watch(legacy(const Object()));
  ref.watch(legacy(FreezedExample()));
  ref.watch(legacy(ClassicFreezed(42)));
  ref.watch(legacy(TypeId(1)));

  // Extension types are unwrapped to check the underlying representation type.
  ref.watch(legacy(GoodTypeId(ClassThatOverridesEqual())));
  ref.watch(legacy(GoodTypeId(const ClassThatOverridesEqual())));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy(BadTypeId(NoEqualsClass())));
  // Nested extension types are unwrapped recursively.
  ref.watch(legacy(NestedGoodTypeId(GoodTypeId(ClassThatOverridesEqual()))));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy(NestedBadTypeId(BadTypeId(NoEqualsClass()))));

  // Generic extension types are unwrapped using the substituted type argument.
  ref.watch(legacy(Box<ClassThatOverridesEqual>(ClassThatOverridesEqual())));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy(Box<NoEqualsClass>(NoEqualsClass())));

  // Triple-nested extension types are unwrapped recursively.
  ref.watch(
    legacy(
      TripleGoodTypeId(NestedGoodTypeId(GoodTypeId(ClassThatOverridesEqual()))),
    ),
  );
  // ignore: riverpod_lint/provider_parameters
  ref.watch(
    legacy(TripleBadTypeId(NestedBadTypeId(BadTypeId(NoEqualsClass())))),
  );

  // A generic extension type wrapping another generic extension type is
  // unwrapped recursively too.
  ref.watch(
    legacy(Box<Box<ClassThatOverridesEqual>>(Box(ClassThatOverridesEqual()))),
  );
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy(Box<Box<NoEqualsClass>>(Box(NoEqualsClass()))));

  void fn() {}

  // ignore: riverpod_lint/provider_parameters
  ref.watch(provider(() {}));
  ref.watch(provider(fn));

  ref.watch(legacy(ClassThatOverridesEqual()));
  ref.watch(legacy(const ClassThatOverridesEqual()));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy(Factory.bar()));
  ref.watch(legacy(const Factory.bar()));
  ref.watch(legacy(Factory.foo()));
  ref.watch(legacy(const Factory.foo()));

  ref.watch(generatorProvider(value: 42));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: [42]));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: {'string': 42}));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: {42}));
  ref.watch(generatorProvider(value: const [42]));
  ref.watch(generatorProvider(value: const {'string': 42}));
  ref.watch(generatorProvider(value: const {42}));
  ref.watch(generatorProvider(value: null));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: Object()));
  ref.watch(generatorProvider(value: const Object()));
  ref.watch(generatorProvider(value: TypeId(1)));

  ref.watch(generatorProvider(value: ClassThatOverridesEqual()));
  ref.watch(generatorProvider(value: const ClassThatOverridesEqual()));

  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: Bar()));
  ref.watch(generatorProvider(value: const Bar()));

  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: Factory.bar()));
  ref.watch(generatorProvider(value: const Factory.bar()));
  ref.watch(generatorProvider(value: Factory.foo()));
  ref.watch(generatorProvider(value: const Factory.foo()));
});

@freezed
sealed class FreezedExample with _$FreezedExample {
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
  // ignore: unnecessary_overrides, used for analyzer test
  bool operator ==(Object other) => super == other;

  @override
  // ignore: unnecessary_overrides, used for analyzer test
  int get hashCode => super.hashCode;
}

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(legacy(42));
    // ignore: riverpod_lint/provider_parameters
    ref.read(legacy([42]));
    ref.listen(legacy(42), (prev, next) {});
    // ignore: riverpod_lint/provider_parameters
    ref.listen(legacy([42]), (prev, next) {});
    ref.listenManual(legacy(42), (prev, next) {});
    // ignore: riverpod_lint/provider_parameters
    ref.listenManual(legacy([42]), (prev, next) {});

    ref.watch(legacy(42));
    ref.read(legacy(list));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy([42]));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy({'string': 42}));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy({42}));
    ref.watch(legacy(const [42]));
    ref.watch(legacy(const {'string': 42}));
    ref.watch(legacy(const {42}));
    ref.watch(legacy(null));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy(Object()));
    ref.watch(legacy(const Object()));
    ref.watch(legacy(TypeId(1)));

    ref.watch(legacy(ClassThatOverridesEqual()));
    ref.watch(legacy(const ClassThatOverridesEqual()));
    ref.watch(legacy(IndirectEqual()));
    ref.watch(legacy(const IndirectEqual()));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy(Bar()));
    ref.watch(legacy(const Bar()));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy(Factory.bar()));
    ref.watch(legacy(const Factory.bar()));
    ref.watch(legacy(Factory.foo()));
    ref.watch(legacy(const Factory.foo()));

    ref.watch(generatorProvider(value: 42));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: [42]));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: {'string': 42}));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: {42}));
    ref.watch(generatorProvider(value: const [42]));
    ref.watch(generatorProvider(value: const {'string': 42}));
    ref.watch(generatorProvider(value: const {42}));
    ref.watch(generatorProvider(value: null));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: Object()));
    ref.watch(generatorProvider(value: const Object()));
    ref.watch(generatorProvider(value: TypeId(1)));

    ref.watch(generatorProvider(value: ClassThatOverridesEqual()));
    ref.watch(generatorProvider(value: const ClassThatOverridesEqual()));
    ref.watch(generatorProvider(value: IndirectEqual()));
    ref.watch(generatorProvider(value: const IndirectEqual()));

    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: Bar()));
    ref.watch(generatorProvider(value: const Bar()));

    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: Factory.bar()));
    ref.watch(generatorProvider(value: const Factory.bar()));
    ref.watch(generatorProvider(value: Factory.foo()));
    ref.watch(generatorProvider(value: const Factory.foo()));

    return const Placeholder();
  }
}

extension type TypeId(int id) {}

class NoEqualsClass {
  NoEqualsClass();
}

extension type GoodTypeId(ClassThatOverridesEqual value) {}
extension type BadTypeId(NoEqualsClass value) {}
extension type NestedGoodTypeId(GoodTypeId value) {}
extension type NestedBadTypeId(BadTypeId value) {}
extension type TripleGoodTypeId(NestedGoodTypeId value) {}
extension type TripleBadTypeId(NestedBadTypeId value) {}
extension type Box<T>(T value) {}

// Regression test for https://github.com/rrousselGit/riverpod/issues/3302
mixin Equatable {
  List<Object?> get props;
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            props == other.props;
  }

  @override
  int get hashCode => runtimeType.hashCode ^ Object.hashAll(props);
}

class IndirectEqual with Equatable {
  const IndirectEqual();
  @override
  List<Object?> get props => const [];
}

@freezed
class ClassicFreezed with _$ClassicFreezed {
  const ClassicFreezed(this.value);

  @override
  final int value;
}
