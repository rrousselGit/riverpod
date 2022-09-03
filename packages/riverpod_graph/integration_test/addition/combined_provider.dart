import 'package:riverpod/riverpod.dart';

import 'base_providers.dart';

final additionProvider = FutureProvider<int>(
  (ref) async =>
      ref.watch(normalProvider) +
      await ref.watch(futureProvider.future) +
      ref.watch(familyProviders(0)) +
      ref.watch(functionProvider)() +
      ref.watch(SampleClass.normalProvider) +
      await ref.watch(SampleClass.futureProvider.future) +
      await ref.watch(SampleClass.familyProviders(0)) +
      ref.watch(SampleClass.functionProvider)(),
  dependencies: [
    normalProvider,
    futureProvider.future,
    familyProviders,
    functionProvider,
    SampleClass.normalProvider,
    SampleClass.futureProvider.future,
    SampleClass.familyProviders,
    SampleClass.functionProvider,
  ],
);
