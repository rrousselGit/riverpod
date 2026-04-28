import 'package:devtools_app_shared/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart' as vm;

class _MockEval extends Mock implements Eval {
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
  _FakeEvalFactory({required this.dartCore, required Eval riverpodFramework})
    : _riverpodFramework = riverpodFramework;

  @override
  final Eval dartCore;

  final Eval _riverpodFramework;

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
        vm.BoundField(name: 0),
      );
      final namedField = DerivedCachedObject.objectField(
        root,
        vm.BoundField(name: 'label'),
      );

      expect(positional.from, same(root));
      expect(positional.label, isNull);
      expect(namedField.from, same(root));
      expect(namedField.label, 'label');
    });

    test('collectionElement keeps the parent object and no explicit label', () {
      final root = RootCachedObject(CacheId('root'));
      final child = DerivedCachedObject.collectionElement(root, 1);

      expect(child.from, same(root));
      expect(child.label, isNull);
    });

    test('mapAssociationKey and mapAssociationValue expose fixed labels', () {
      final root = RootCachedObject(CacheId('root'));
      final key = DerivedCachedObject.mapAssociationKey(root, 0);
      final value = DerivedCachedObject.mapAssociationValue(root, 0);

      expect(key.from, same(root));
      expect(key.label, 'key');
      expect(value.from, same(root));
      expect(value.label, 'value');
    });

    test('objectField rejects unsupported field-name types eagerly', () {
      expect(
        () => DerivedCachedObject.objectField(
          RootCachedObject(CacheId('root')),
          vm.BoundField(name: 3.14),
        ),
        throwsStateError,
      );
    });
  });

  group('RootCachedObject', () {
    test('toString includes the cache id', () {
      expect(
        RootCachedObject(CacheId('cache-1')).toString(),
        'CachedObject(id: cache-1)',
      );
    });
  });
}
