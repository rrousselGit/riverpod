import 'package:riverpod/riverpod.dart';

import 'base_providers.dart';
import 'class_contained_providers.dart';
import 'future_providers.dart';

final additionProvider = FutureProvider<int>(
  (ref) async =>
      ref.watch(firstOperandProvider) +
      ref.watch(secondOperandProvider) +
      ref.watch(Third.operandProvider) +
      await ref.watch(fourthOperandProvider.future),
  dependencies: [
    firstOperandProvider,
    secondOperandProvider,
    Third.operandProvider,
    fourthOperandProvider.future,
  ],
);
