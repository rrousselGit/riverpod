import 'package:riverpod/riverpod.dart';

import 'base_providers.dart';

/// Provides the addition of [firstOperandProvider] and [secondOperandProvider].
final additionProvider = Provider<int>(
  (ref) => ref.watch(firstOperandProvider) + ref.watch(secondOperandProvider),
  dependencies: [
    firstOperandProvider,
    secondOperandProvider,
  ],
);
