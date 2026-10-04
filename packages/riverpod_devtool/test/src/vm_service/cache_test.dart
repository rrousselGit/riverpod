import 'package:devtools_app_shared/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart' as vm;

class _MockEval extends Mock implements Eval {
  @override
  late EvalFactory factory;

  @override
  Future<Byte<VmInstanceRef>> eval(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) {
    return super.noSuchMethod(
          Invocation.method(#eval, [code], {#isAlive: isAlive, #scope: scope}),
          returnValue: Future.value(
            ByteError<VmInstanceRef>(UnknownEvalErrorType('missing stub')),
          ),
        )
        as Future<Byte<VmInstanceRef>>;
  }

  @override
  Future<Byte<VmInstance>> instance(
    VmInstanceRef ref, {
    required Disposable isAlive,
  }) {
    return super.noSuchMethod(
          Invocation.method(#instance, [ref], {#isAlive: isAlive}),
          returnValue: Future.value(
            ByteError<VmInstance>(UnknownEvalErrorType('missing stub')),
          ),
        )
        as Future<Byte<VmInstance>>;
  }
}

class _FakeEvalFactory implements EvalFactory {
  _FakeEvalFactory({required this.dartCore, required this._riverpodFramework});

  @override
  final Eval dartCore;

  final Eval _riverpodFramework;

  @override
  String? sessionId;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isGetter && invocation.memberName == #riverpodFramework) {
      return _riverpodFramework;
    }
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('CachedObject', () {
    test(
      'session roots check the lease even when the VM ref remains valid',
      () async {
        final object = RootCachedObject(CacheId('session:result'));
        final framework = _MockEval();
        final core = _MockEval();
        final factory = _FakeEvalFactory(
          dartCore: core,
          riverpodFramework: framework,
        )..sessionId = 'session';
        final alive = Disposable();
        final instance = VmInstance.string('still alive in the VM');
        var fetches = 0;
        when(
          framework.eval(
            'RiverpodDevtool.instance.getCache("session:result")',
            isAlive: alive,
          ),
        ).thenAnswer(
          (_) async => ++fetches == 1
              ? ByteVariable(instance.ref)
              : ByteError(const ExpiredDevtoolSessionType()),
        );
        when(
          core.instance(instance.ref, isAlive: alive),
        ).thenAnswer((_) async => ByteVariable(instance));
        expect(
          await object.read(factory, isAlive: alive),
          isA<ByteVariable<VmInstance>>(),
        );
        final expired = await object.readRef(factory, alive);
        expect(expired, isA<ByteError<VmInstanceRef>>());
        expect((expired as ByteError).error, isA<ExpiredDevtoolSessionType>());
        expect(fetches, 2);
      },
    );

    test('old roots and their children expire after reconnect', () async {
      final object = RootCachedObject(CacheId('old:result'));
      final child = DerivedCachedObject.collectionElement(object, 0);
      final framework = _MockEval();
      final core = _MockEval();
      final factory = _FakeEvalFactory(
        dartCore: core,
        riverpodFramework: framework,
      )..sessionId = 'old';
      final alive = Disposable();
      final value = VmInstance.string('child');
      final list = VmInstance(
        vm.Instance(
          id: 'list',
          kind: vm.InstanceKind.kList,
          elements: [value.ref.raw],
        ),
      );
      when(
        framework.eval(
          'RiverpodDevtool.instance.getCache("old:result")',
          isAlive: alive,
        ),
      ).thenAnswer((_) async => ByteVariable(list.ref));
      when(
        core.instance(list.ref, isAlive: alive),
      ).thenAnswer((_) async => ByteVariable(list));
      when(
        core.instance(value.ref, isAlive: alive),
      ).thenAnswer((_) async => ByteVariable(value));
      expect(
        await child.read(factory, isAlive: alive),
        isA<ByteVariable<VmInstance>>(),
      );
      when(
        framework.eval(
          'RiverpodDevtool.instance.getCache("old:result")',
          isAlive: alive,
        ),
      ).thenAnswer((_) async => ByteError(const ExpiredDevtoolSessionType()));
      final remotelyExpired = await child.read(factory, isAlive: alive);
      expect(
        (remotelyExpired as ByteError).error,
        isA<ExpiredDevtoolSessionType>(),
      );
      factory.sessionId = 'new';
      for (final cached in [object, child]) {
        final result = await cached.read(factory, isAlive: alive);
        expect(result, isA<ByteError<VmInstance>>());
        expect((result as ByteError).error, isA<ExpiredDevtoolSessionType>());
        expect(
          await cached.readRef(factory, alive),
          isA<ByteError<VmInstanceRef>>(),
        );
      }
      verify(core.instance(value.ref, isAlive: alive)).called(1);
    });

    test('keeps the cached ref across non-expired errors', () async {
      final ref = VmInstanceRef.string('value', id: 'cached-ref');
      var fetchCount = 0;
      var instanceCount = 0;

      final object = RootCachedObject(CacheId('cached-object'));
      final riverpodFramework = _MockEval();
      final dartCore = _MockEval();
      final eval = _FakeEvalFactory(
        riverpodFramework: riverpodFramework,
        dartCore: dartCore,
      );
      final isAlive = Disposable();

      when(
        riverpodFramework.eval(
          'RiverpodDevtool.instance.getCache("cached-object")',
          isAlive: isAlive,
        ),
      ).thenAnswer((_) async {
        fetchCount++;
        return ByteVariable(ref);
      });

      when(dartCore.instance(ref, isAlive: isAlive)).thenAnswer((_) async {
        instanceCount++;
        return ByteError<VmInstance>(UnknownEvalErrorType('boom'));
      });

      final firstRead = await object.read(eval, isAlive: isAlive);
      final secondRead = await object.read(eval, isAlive: isAlive);

      expect(firstRead, isA<ByteError<VmInstance>>());
      expect(secondRead, isA<ByteError<VmInstance>>());
      expect(
        (firstRead as ByteError<VmInstance>).error.toString(),
        'UnknownEvalError: boom',
      );
      expect(
        (secondRead as ByteError<VmInstance>).error.toString(),
        'UnknownEvalError: boom',
      );
      expect(fetchCount, 1);
      expect(instanceCount, 2);
    });

    test('refetches and replaces the cached ref on expired errors', () async {
      final staleRef = VmInstanceRef.string('stale', id: 'stale-ref');
      final freshRef = VmInstanceRef.string('fresh', id: 'fresh-ref');
      final fetchedRefs = <VmInstanceRef>[staleRef, freshRef];
      final seenRefs = <VmInstanceRef>[];
      var fetchCount = 0;

      final object = RootCachedObject(CacheId('cached-object'));
      final riverpodFramework = _MockEval();
      final dartCore = _MockEval();
      final eval = _FakeEvalFactory(
        riverpodFramework: riverpodFramework,
        dartCore: dartCore,
      );
      final isAlive = Disposable();

      when(
        riverpodFramework.eval(
          'RiverpodDevtool.instance.getCache("cached-object")',
          isAlive: isAlive,
        ),
      ).thenAnswer((_) async {
        return ByteVariable(fetchedRefs[fetchCount++]);
      });

      when(dartCore.instance(staleRef, isAlive: isAlive)).thenAnswer((_) async {
        seenRefs.add(staleRef);
        return ByteError<VmInstance>(
          ExpiredSentinelExceptionType(
            vm.Sentinel(
              kind: vm.SentinelKind.kExpired,
              valueAsString: 'expired',
            ),
          ),
        );
      });

      when(dartCore.instance(freshRef, isAlive: isAlive)).thenAnswer((_) async {
        seenRefs.add(freshRef);
        return ByteVariable(VmInstance.string('ok'));
      });

      final firstRead = await object.read(eval, isAlive: isAlive);
      final cachedRef = await object.readRef(eval, isAlive);

      expect(firstRead, isA<ByteVariable<VmInstance>>());
      expect(
        (firstRead as ByteVariable<VmInstance>).instance.valueAsString,
        'ok',
      );
      expect(cachedRef, isA<ByteVariable<VmInstanceRef>>());
      expect(
        (cachedRef as ByteVariable<VmInstanceRef>).instance,
        isNot(staleRef),
      );
      expect(fetchCount, 2);
      expect(seenRefs, hasLength(2));
      expect(seenRefs.first, staleRef);
      expect(seenRefs[1], freshRef);
    });
  });

  group('DerivedCachedObject', () {
    test('objectField infers labels from named and positional fields', () {
      final root = RootCachedObject(CacheId('root'));

      final positional = DerivedCachedObject.objectField(
        root,
        FieldKey.from(0),
      );
      final namedField = DerivedCachedObject.objectField(
        root,
        FieldKey.from('label'),
      );

      expect(positional.label, isNull);
      expect(namedField.label, 'label');
    });

    test('collectionElement keeps the parent object and no explicit label', () {
      final root = RootCachedObject(CacheId('root'));
      final child = DerivedCachedObject.collectionElement(root, 1);

      expect(child.label, isNull);
    });

    test('mapAssociationKey and mapAssociationValue expose fixed labels', () {
      final root = RootCachedObject(CacheId('root'));
      final key = DerivedCachedObject.mapAssociationKey(root, 0);
      final value = DerivedCachedObject.mapAssociationValue(root, 0);

      expect(key.label, 'key');
      expect(value.label, 'value');
    });

    test('objectField rejects unsupported field-name types eagerly', () {
      expect(
        () => DerivedCachedObject.objectField(
          RootCachedObject(CacheId('root')),
          FieldKey.from(3.14),
        ),
        throwsStateError,
      );
    });
  });

  group('RootCachedObject', () {
    test(
      'creating a terminal result validates ownership and never retries',
      () async {
        final framework = _MockEval();
        final eval = _MockEval();
        final factory = _FakeEvalFactory(
          dartCore: eval,
          riverpodFramework: framework,
        )..sessionId = 'session';
        eval.factory = factory;
        final alive = Disposable();
        when(
          framework.eval('RiverpodDevtool.instance', isAlive: alive),
        ).thenAnswer(
          (_) async =>
              ByteVariable(VmInstanceRef.string('devtool', id: 'devtool-ref')),
        );
        const expression =
            '() { RiverpodDevtool.validateSession("session"); '
            'return RiverpodDevtool.cache((increment()) as Object?, sessionId: "session"); }()';
        when(
          eval.eval(
            expression,
            isAlive: alive,
            scope: {'RiverpodDevtool': 'devtool-ref'},
          ),
        ).thenAnswer((_) async => ByteError(const ExpiredDevtoolSessionType()));
        final result = await RootCachedObject.create(
          'increment()',
          eval,
          isAlive: alive,
        );
        expect(result, isA<ByteError<RootCachedObject>>());
        verify(
          eval.eval(
            expression,
            isAlive: alive,
            scope: {'RiverpodDevtool': 'devtool-ref'},
          ),
        ).called(1);
        factory.sessionId = null;
        expect(
          await RootCachedObject.create('increment()', eval, isAlive: alive),
          isA<ByteError<RootCachedObject>>(),
        );
        verifyNoMoreInteractions(eval);
      },
    );

    test('toString includes the cache id', () {
      expect(
        RootCachedObject(CacheId('cache-1')).toString(),
        'CachedObject(id: cache-1)',
      );
    });
  });
}
