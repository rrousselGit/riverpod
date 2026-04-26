import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart';

import '../../test_helpers.dart';

void main() {
  group('Byte', () {
    test('wraps instance refs and instances', () {
      final ref = stringRef('hello');
      final instance = stringInstance('world');

      expect(Byte.instanceRef(ref), ByteVariable(ref));
      expect(Byte.instance(instance), ByteVariable(instance));
    });

    test('turns sentinels into errors', () {
      final result = Byte.instanceRef(
        Sentinel(kind: SentinelKind.kExpired, valueAsString: 'expired'),
      );

      expect(result, isA<ByteError<InstanceRef>>());
      expect((result as ByteError<InstanceRef>).error.toString(), 'expired');
    });

    test('throws on unsupported input', () {
      expect(() => Byte.instanceRef(Object()), throwsArgumentError);
    });

    test('require and valueOrNull reflect success and failure', () {
      final ok = ByteVariable(stringRef('ok'));
      final error = ByteError<InstanceRef>(UnknownEvalErrorType('boom'));

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
