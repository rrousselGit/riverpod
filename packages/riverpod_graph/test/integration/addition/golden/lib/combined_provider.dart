import 'package:riverpod/riverpod.dart';

import 'base_providers.dart';

/// A provider returning the sum of the other providers.
final additionProvider = FutureProvider(
  (ref) async =>
      ref.watch(normalProvider) +
      await ref.watch(futureProvider.future) +
      ref.watch(familyProviders(0)) +
      ref.watch(functionProvider)() +
      ref.watch(selectedProvider.select((value) => value)) +
      ref.watch(SampleClass.normalProvider) +
      await ref.watch(SampleClass.futureProvider.future) +
      await ref.watch(SampleClass.familyProviders(0)) +
      ref.watch(SampleClass.functionProvider)() +
      ref.watch(SampleClass.selectedProvider.select((value) => value)),
  dependencies: [
    normalProvider,
    futureProvider,
    familyProviders,
    functionProvider,
    selectedProvider,
    SampleClass.normalProvider,
    SampleClass.futureProvider,
    SampleClass.familyProviders,
    SampleClass.functionProvider,
    SampleClass.selectedProvider,
  ],
);
