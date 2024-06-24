import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unknown_scoped_usage.g.dart';

@Riverpod(dependencies: [])
int scoped(ScopedRef ref) => 0;

@riverpod
int root(RootRef ref) => 0;

@Dependencies([scoped])
void fn(WidgetRef widgetRef, Ref<int> ref) {
  // expect_lint: unknown_scoped_usage
  scopedProvider;
  rootProvider;

  // Known ref usage
  widgetRef.watch(scopedProvider);
  ref.watch(scopedProvider);

  // Unknown ref usage inside a ref expression
  // expect_lint: unknown_scoped_usage
  widgetRef.watch(identity(scopedProvider));
  // expect_lint: unknown_scoped_usage
  ref.watch(identity(scopedProvider));
  // expect_lint: unknown_scoped_usage
  ref.watch(identityMap[scopedProvider]);

  // Overrides are OK
  scopedProvider.overrideWith((ref) => 0);

  // If passed as widget constructor parameter, it's OK
  // expect_lint: unknown_scoped_usage
  RandomObject(scopedProvider);
  MyWidget(scopedProvider);
}

class RandomObject<T> {
  RandomObject(this.provider);
  final ProviderListenable<T> provider;
}

final identityMap = IdentityMap<ProviderListenable<int>>();

class IdentityMap<T> {
  T operator [](T key) => key;
}

T identity<T>(T value) => value;

class MyWidget<T> extends ConsumerWidget {
  const MyWidget(this.provider);

  final ProviderListenable<T> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provider);
    return Container();
  }
}
