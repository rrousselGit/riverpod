import 'package:riverpod/riverpod.dart';

import 'base_providers.dart';

final additionProvider = FutureProvider<int>(
  (ref) async =>
      ref.watch(firstOperandProvider) +
      await ref.watch(secondOperandProvider.future) +
      ref.watch(Third.operandProvider) +
      await ref.watch(Fourth.operandProvider.future),
  dependencies: [
    firstOperandProvider,
    secondOperandProvider,
    Third.operandProvider,
    fourthOperandProvider.future,
  ],
);
