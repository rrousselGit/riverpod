import 'package:riverpod/riverpod.dart';

final firstOperandProvider = Provider((ref) => 0);
final secondOperandProvider = FutureProvider((ref) => 1);

class Third {
  static final operandProvider = Provider((_) => 2);
}

class Fourth {
  static final operandProvider = FutureProvider((_) => 3);
}
