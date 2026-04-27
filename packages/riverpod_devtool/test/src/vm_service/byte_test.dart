import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart';

void main() {
  group('Byte', () {
    test('wraps instance refs and instances', () {
      final ref = VmInstanceRef.string('hello', id: 'ref-hello').raw;
      final instance = VmInstance.string('world');

      expect(Byte.instanceRef(ref), ByteVariable(VmInstanceRef(ref)));
      expect(Byte.instanceRef(instance), ByteVariable(VmInstanceRef(instance)));
    });

    test('turns sentinels into errors', () {
      final result = Byte.instanceRef(
        Sentinel(kind: SentinelKind.kExpired, valueAsString: 'expired'),
      );

      expect(result, isA<ByteError<VmInstanceRef>>());
      expect(
        (result as ByteError<VmInstanceRef>).error,
        isA<ExpiredSentinelExceptionType>(),
      );
      expect(result.error.toString(), 'expired');
    });

    test('uses a non-expired subtype for other sentinels', () {
      final result = Byte.instanceRef(
        Sentinel(
          kind: SentinelKind.kNotInitialized,
          valueAsString: 'not initialized',
        ),
      );

      expect(result, isA<ByteError<VmInstanceRef>>());
      expect(
        (result as ByteError<VmInstanceRef>).error,
        isA<GenericSentinelExceptionType>(),
      );
    });

    test('throws on unsupported input', () {
      expect(() => Byte.instanceRef(Object()), throwsArgumentError);
    });

    test('require and valueOrNull reflect success and failure', () {
      final ok = ByteVariable(VmInstanceRef.string('ok', id: 'ref-ok'));
      final error = ByteError<VmInstanceRef>(UnknownEvalErrorType('boom'));

      expect(ok.require.instance.valueAsString, 'ok');
      expect(ok.valueOrNull?.valueAsString, 'ok');
      expect(error.valueOrNull, isNull);
      expect(() => error.require, throwsStateError);
    });

    test('map transforms values and preserves errors', () {
      final ok = const ByteVariable(21).map((value) => value * 2);
      final error = ByteError<int>(
        UnknownEvalErrorType('boom'),
      ).map((value) => value * 2);

      expect(ok, const ByteVariable(42));
      expect(error, isA<ByteError<int>>());
      expect(
        (error as ByteError<int>).error.toString(),
        'UnknownEvalError: boom',
      );
    });

    test('error wrappers format their messages', () {
      expect(UnknownEvalErrorType('oops').toString(), 'UnknownEvalError: oops');
      expect(
        RPCErrorType(RPCError('eval', 500, 'Boom')).toString(),
        contains('RPCError: eval: (500) Boom'),
      );
    });

  });
}
