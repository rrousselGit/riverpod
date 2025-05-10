import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

Object? errorOf(void Function() cb) {
  try {
    cb();
    return null;
  } catch (e) {
    return e;
  }
}

void main() {
  group('ProviderException.toString', () {
    test('simple', () {
      final container = ProviderContainer.test();
      final stack = StackTrace.current;
      final provider = Provider<int>((ref) {
        Error.throwWithStackTrace('message', stack);
      });

      final exception = errorOf(() => container.read(provider));

      expect(exception.toString(), '''
ProviderException: Tried to use a provider that is in error state.

A provider threw the following exception:
message

The stack trace of the exception:
$stack''');
    });

    test('nested', () {
      final container = ProviderContainer.test();
      final stack = StackTrace.current;
      final dep = Provider<int>((ref) {
        Error.throwWithStackTrace('message', stack);
      });
      late StackTrace stack2;
      final dep2 = Provider<int>((ref) {
        try {
          return ref.watch(dep);
        } catch (e, s) {
          stack2 = s;
          Error.throwWithStackTrace(e, s);
        }
      });
      late StackTrace stack3;
      final provider = Provider<int>((ref) {
        try {
          return ref.watch(dep2);
        } catch (e, s) {
          stack3 = s;
          Error.throwWithStackTrace(e, s);
        }
      });

      final exception = errorOf(() => container.read(provider));

      expect(exception.toString(), '''
ProviderException: Tried to use a provider that is in error state.

A provider threw the following exception:
message

The stack trace of the exception:
$stack

And rethrown at:
$stack2

And rethrown at:
$stack3''');
    });
  });
}
