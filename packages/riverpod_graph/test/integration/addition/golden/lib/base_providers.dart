import 'package:riverpod/riverpod.dart';

/// A provider returning a number.
final normalProvider = Provider((ref) => 0);

/// A future provider returning a number.
final futureProvider = FutureProvider((ref) => 1);

/// A family provider returning a number.
final familyProviders = Provider.family((ref, anyNumber) => 2);

/// A provider returning a function that returns a number.
final functionProvider = Provider((ref) => () => 3);

/// A provider returning a number that will be selected.
final selectedProvider = Provider((ref) => 4);

/// A sample class containing different providers.
class SampleClass {
  /// A provider returning a number.
  static final normalProvider = Provider((ref) => 0);

  /// A future provider returning a number.
  static final futureProvider = FutureProvider((ref) => 1);

  /// A family provider returning a number.
  static final familyProviders = Provider.family((ref, anyNumber) => 2);

  /// A provider returning a function that returns a number.
  static final functionProvider = Provider((ref) => () => 3);

  /// A provider returning a number that will be selected.
  static final selectedProvider = Provider((ref) => 4);
}
