import 'package:riverpod/riverpod.dart';

import 'base_providers.dart';

final additionProvider = Provider<int>(
  (ref) => ref.watch(firstOperandProvider) + ref.watch(secondOperandProvider),
  dependencies: [
    firstOperandProvider,
    secondOperandProvider,
  ],
);
