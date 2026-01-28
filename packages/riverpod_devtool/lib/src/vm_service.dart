// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';

import 'package:devtools_app_shared/service.dart' hide SentinelException;
import 'package:devtools_app_shared/utils.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart' as internals;
import 'package:vm_service/vm_service.dart';

part 'vm_service.g.dart';

@immutable
sealed class Byte<T> {
  const Byte();
  factory Byte._of(Object? obj) {
    switch (obj) {
      case Sentinel():
        return ByteSentinel(obj);
      case T():
        return ByteVariable(obj);
      default:
        throw ArgumentError('Object $obj is neither a Sentinel nor a $T');
    }
  }

  static Byte<InstanceRef> instanceRef(Object? ref) => Byte._of(ref);
  static Byte<Instance> instance(Object? instance) => Byte._of(instance);

  ByteVariable<T> get require {
    switch (this) {
      case final ByteVariable<T> that:
        return that;
      case ByteSentinel<T>(:final sentinel):
        throw StateError('Expected VariableRef but got Sentinel: $sentinel');
    }
  }

  Byte<R> map<R>(R Function(T value) fn) {
    switch (this) {
      case final ByteVariable<T> that:
        return ByteVariable(fn(that.instance));
      case ByteSentinel<T>(:final sentinel):
        return ByteSentinel<R>(sentinel);
    }
  }
}

final class ByteVariable<T> extends Byte<T> {
  const ByteVariable(this.instance);
  final T instance;

  @override
  String toString() => 'ByteVariableRef($instance)';

  @override
  bool operator ==(Object other) {
    return other is ByteVariable<T> && other.instance == instance;
  }

  @override
  int get hashCode => instance.hashCode;
}

final class ByteSentinel<T> extends Byte<T> {
  const ByteSentinel(this.sentinel);
  final Sentinel sentinel;

  @override
  String toString() => 'ByteSentinel($sentinel)';

  @override
  bool operator ==(Object other) {
    return other is ByteSentinel<T> && other.sentinel == sentinel;
  }

  @override
  int get hashCode => sentinel.hashCode;
}

Iterable<ItemT> decodeAll<ItemT>(
  Map<String, InstanceRef> events,
  ItemT Function(Map<String, InstanceRef>, {required String path}) fn, {
  required String path,
}) sync* {
  final length = int.parse(events['$path.length']!.valueAsString!);

  for (var i = 0; i < length; i++) {
    final itemPath = '$path[$i]';
    yield fn(events, path: itemPath);
  }
}

String encodeList(
  String expr,
  String Function(String name, String path) mapCode, {
  required String path,
}) {
  return '''
() {
  final list = $expr;
  return {
    '$path.length': list.length,
    for (final (index, e) in list.indexed)
      ...${mapCode('e', '$path[\$index]')},
  };
}()
''';
}

void _validate(
  Map<String, InstanceRef> events, {
  required String name,
  required String path,
}) {
  final startEvent = events['$path._type']?.valueAsString;
  if (startEvent != name) {
    throw ArgumentError(
      'Invalid event type, expected "$name" but got $startEvent',
    );
  }
}

/// A provider that emits an update when a hot-restart is detected.
final hotRestartEventProvider = Provider<void>(
  name: 'hotRestartEventProvider',
  (ref) async {
    final service = await ref.watch(serviceManagerProvider.future);
    if (!ref.mounted) return;
    final selectedIsolateListenable = service.isolateManager.selectedIsolate;

    var isolateId = selectedIsolateListenable.value?.id;

    void listener() {
      final newId = selectedIsolateListenable.value?.id;
      final oldId = isolateId;
      isolateId = newId;

      if (oldId != null && oldId != newId) {
        ref.notifyListeners();
        return;
      }
    }

    selectedIsolateListenable.addListener(listener);
    ref.onDispose(() => selectedIsolateListenable.removeListener(listener));
  },
);

extension NotificationService on VmService {
  Stream<internals.Notification> get onNotification =>
      onExtensionEvent.expand((event) {
        final notification = internals.Notification.fromJson(
          event.extensionKind ?? '',
          event.extensionData?.data ?? {},
        );
        if (notification != null) {
          return [notification];
        }
        return const [];
      });
}

final serviceManagerProvider =
    AsyncNotifierProvider<ServiceManagerNotifier, ServiceManager>(
      name: 'serviceManagerProvider',
      ServiceManagerNotifier.new,
    );

class ServiceManagerNotifier extends AsyncNotifier<ServiceManager> {
  @override
  Future<ServiceManager<VmService>> build() async {
    final timer = Timer.periodic(const Duration(milliseconds: 18), (_) async {
      final newService = serviceManager;
      final currentService = await future;
      // New service detected
      if (state.value == currentService) return;

      state = const AsyncLoading();
      await newService.onServiceAvailable;
      // Changed service while in the async gap
      if (serviceManager != newService) return;

      print('new service ${serviceManager.hashCode}');
      state = AsyncData(newService);
    });
    ref.onDispose(timer.cancel);

    await serviceManager.onServiceAvailable;

    print('Initial service ${serviceManager.hashCode}');

    return serviceManager;
  }
}

final vmServiceProvider = AsyncNotifierProvider<VmServiceNotifier, VmService>(
  name: 'vmServiceProvider',
  VmServiceNotifier.new,
);

class VmServiceNotifier extends AsyncNotifier<VmService> {
  @override
  Future<VmService> build() async {
    final serviceManager = ref.watch(serviceManagerProvider);
    final timer = Timer.periodic(const Duration(milliseconds: 18), (_) {
      if (state.value == serviceManager.value?.service) return;

      switch (serviceManager.value?.service) {
        case final service?:
          state = AsyncValue.data(service);
        case null:
          state = const AsyncValue.loading();
      }
    });
    ref.onDispose(timer.cancel);

    if (serviceManager.value?.service case final service?) return service;

    return future;
  }
}

extension type CacheId(String value) {}

class Eval {
  Eval._(this._eval);
  final EvalOnDartLibrary _eval;

  String _formatCode(String code) => code.replaceAll('\n', ' ');

  Future<CacheId> cache(InstanceRef ref, {required Disposable isAlive}) async {
    final idRef = await _eval.safeEval(
      'RiverpodDevtool.instance.cache(that)',
      scope: {'that': ref.id!},
      isAlive: isAlive,
    );

    if (idRef.valueAsStringIsTruncated!) {
      throw StateError('CacheId value is truncated');
    }
    return CacheId(idRef.valueAsString!);
  }

  Future<void> deleteCache(CacheId id, {required Disposable isAlive}) async {
    await _eval.safeEval(
      'RiverpodDevtool.instance.deleteCache(that)',
      scope: {'that': id.value},
      isAlive: isAlive,
    );
  }

  Future<InstanceRef> getCache(CacheId id, {required Disposable isAlive}) {
    return _eval.safeEval(
      'RiverpodDevtool.instance.getCache(that)',
      scope: {'that': id.value},
      isAlive: isAlive,
    );
  }

  Future<InstanceRef> eval(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) {
    return _eval.safeEval(_formatCode(code), isAlive: isAlive, scope: scope);
  }

  Future<Instance> evalInstance(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) async {
    final ref = await eval(code, isAlive: isAlive, scope: scope);
    return instance(ref, isAlive: isAlive);
  }

  @Deprecated('use instance2')
  Future<Instance> instance(
    InstanceRef ref, {
    required Disposable isAlive,
  }) async {
    final res = await _eval.getInstance(ref, isAlive);
    return res!;
  }

  Future<Byte<ResolvedVariable>> instance2(
    InstanceRef ref, {
    required Disposable isAlive,
  }) async {
    try {
      print('Get instance for $ref');
      final res = await _eval.safeGetInstance(ref, isAlive);
      print(' For $ref got $res');

      return ByteVariable(ResolvedVariable.fromInstance(res));
    } on SentinelException catch (e) {
      print(' For $ref got sentinel ${e.sentinel}');
      return ByteSentinel(e.sentinel);
    }
  }

  Future<Class> getClass(ClassRef ref, {required Disposable isAlive}) async {
    final res = await _eval.getClass(ref, isAlive);
    return res!;
  }
}

final evalProvider = FutureProvider.autoDispose.family<Eval, String>(
  name: 'evalProvider',
  (ref, libraryName) async {
    final vmService = await ref.watch(vmServiceProvider.future);
    final serviceManager = await ref.watch(serviceManagerProvider.future);

    final eval = EvalOnDartLibrary(
      libraryName,
      vmService,
      serviceManager: serviceManager,
    );
    ref.onDispose(eval.dispose);

    return Eval._(eval);
  },
);

final dartCoreEvalProvider = evalProvider('dart:core');
final dartAsyncEvalProvider = evalProvider('dart:async');
final riverpodFrameworkEvalProvider = evalProvider(
  'package:riverpod/src/framework.dart',
);

extension IsAlive on Ref {
  Disposable disposable() {
    final disposable = Disposable();
    onDispose(disposable.dispose);
    return disposable;
  }
}

sealed class VariableRef {
  factory VariableRef.fromInstanceRef(InstanceRef ref) {
    final kind = _SimplifiedInstanceKind.fromInstanceKind(
      _SealedInstanceKind.fromString(ref.kind!),
    );

    switch (kind) {
      case .string:
        return _StringVariableRefImpl._(ref);
      case .int:
        return IntVariable._(ref);
      case .double:
        return DoubleVariable._(ref);
      case .bool:
        return BoolVariable._(ref);
      case .nill:
        return NullVariable._();
      case .type:
        return _TypeVariableRefImpl(ref);
      case .list:
        return _ListVariableRefImpl(ref);
      case .record:
        return _RecordVariableRefImpl(ref);
      case .set:
        return _SetVariableRefImpl(ref);

      case .map:
      // TODO

      case .object:
        return _UnknownObjectVariableRefImpl(ref);
    }
  }

  InstanceRef? get ref;

  Future<Byte<ResolvedVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

base class _EvaluatedVariableRef {
  _EvaluatedVariableRef(this.ref);
  final InstanceRef ref;

  String get _evalUri => ref.classRef!.library!.uri!;

  Future<Byte<T>> _eval<T extends ResolvedVariable>(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
    Future<T> Function(Eval) run,
  ) async {
    final evalInstance = await eval(_evalUri);

    try {
      return ByteVariable(await run(evalInstance));
    } on SentinelException catch (e) {
      return ByteSentinel(e.sentinel);
    }
  }

  Future<Byte<T>> _resolveInstance<T extends ResolvedVariable>(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _eval(eval, isAlive, (evalInstance) async {
      final instance = await evalInstance.instance(ref, isAlive: isAlive);
      final variable = ResolvedVariable.fromInstance(instance);

      if (variable is! T) {
        throw StateError(
          'Expected variable of type $T but got ${variable.runtimeType}',
        );
      }

      return variable;
    });
  }
}

abstract class NullVariableRef implements VariableRef {
  @override
  Future<Byte<NullVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

abstract class BoolVariableRef implements VariableRef {
  bool get value;

  @override
  Future<Byte<BoolVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

abstract class StringVariableRef implements VariableRef {
  String get truncatedValue;
  bool get isTruncated;
  String? get value;

  @override
  Future<Byte<StringVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _StringVariableRefImpl extends _EvaluatedVariableRef
    implements VariableRef {
  _StringVariableRefImpl._(super._ref)
    : truncatedValue = _ref.valueAsString!,
      isTruncated = _ref.valueAsStringIsTruncated!;

  final String truncatedValue;
  final bool isTruncated;
  String? get value => isTruncated ? null : truncatedValue;

  @override
  Future<Byte<StringVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) async {
    if (!isTruncated) {
      return ByteVariable(StringVariable._2(ref, value: truncatedValue));
    }

    return _resolveInstance(eval, isAlive);
  }
}

abstract class IntVariableRef implements VariableRef {
  int get value;

  @override
  Future<Byte<IntVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

abstract class DoubleVariableRef implements VariableRef {
  double get value;

  @override
  Future<Byte<DoubleVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

abstract class TypeVariableRef implements VariableRef {
  @override
  Future<Byte<TypeVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _TypeVariableRefImpl extends _EvaluatedVariableRef
    implements VariableRef {
  _TypeVariableRefImpl(super._ref);

  @override
  Future<Byte<TypeVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _resolveInstance(eval, isAlive);
  }
}

abstract class ListVariableRef implements VariableRef {
  @override
  Future<Byte<ListVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _ListVariableRefImpl extends _EvaluatedVariableRef
    implements VariableRef {
  _ListVariableRefImpl(super._ref);

  @override
  Future<Byte<ListVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _resolveInstance(eval, isAlive);
  }
}

abstract class RecordVariableRef implements VariableRef {
  @override
  Future<Byte<RecordVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _RecordVariableRefImpl extends _EvaluatedVariableRef
    implements VariableRef {
  _RecordVariableRefImpl(super._ref);

  @override
  Future<Byte<RecordVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _resolveInstance(eval, isAlive);
  }
}

abstract class SetVariableRef implements VariableRef {
  @override
  Future<Byte<SetVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _SetVariableRefImpl extends _EvaluatedVariableRef
    implements VariableRef {
  _SetVariableRefImpl(super._ref);

  @override
  Future<Byte<SetVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _resolveInstance(eval, isAlive);
  }
}

abstract class UnknownObjectVariableRef implements VariableRef {
  @override
  Future<Byte<UnknownObjectVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _UnknownObjectVariableRefImpl extends _EvaluatedVariableRef
    implements VariableRef {
  _UnknownObjectVariableRefImpl(super._ref);

  @override
  Future<Byte<UnknownObjectVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _resolveInstance(eval, isAlive);
  }
}

abstract class FieldVariableRef implements VariableRef {
  @override
  Future<Byte<FieldVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _FieldVariableRefImpl extends _EvaluatedVariableRef
    implements FieldVariableRef {
  _FieldVariableRefImpl(this._field, {required InstanceRef object})
    : super(object);

  final BoundField _field;

  @override
  Future<Byte<FieldVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _eval(eval, isAlive, (eval) async {
      final value = Byte.instanceRef(_field.value);

      return FieldVariable(
        key: FieldKey.from(_field.name),
        value: switch (value) {
          ByteVariable<InstanceRef>() => await eval.instance2(
            value.instance,
            isAlive: isAlive,
          ),
          ByteSentinel<InstanceRef>() => ByteSentinel(value.sentinel),
        },
      );
    });
  }
}

sealed class ResolvedVariable implements VariableRef {
  const ResolvedVariable();

  factory ResolvedVariable.fromInstance(Instance instance) {
    final kind = _SimplifiedInstanceKind.fromInstanceKind(
      _SealedInstanceKind.fromString(instance.kind!),
    );

    switch (kind) {
      case .string:
        return StringVariable._(instance);
      case .int:
        return IntVariable._(instance);
      case .double:
        return DoubleVariable._(instance);
      case .bool:
        return BoolVariable._(instance);
      case .nill:
        return NullVariable._();
      case .type:
        return TypeVariable._(instance);
      case .list:
        return ListVariable._(instance);
      case .record:
        return RecordVariable._(instance);
      case .set:
        return SetVariable._(instance);

      case .object:
      case .map:
        return UnknownObjectVariable._(instance);
    }
  }

  // TODO
  List<Byte<VariableRef>> get children => const [];
}

mixin _SelfResolvedVariable<T extends _SelfResolvedVariable<T>> {
  Future<Byte<T>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) async {
    if (this is! T) {
      throw StateError(
        '_SelfResolvedVariable can only be extended by its generic type T',
      );
    }

    return ByteVariable(this as T);
  }
}

final class NullVariable extends ResolvedVariable
    with _SelfResolvedVariable<NullVariable>
    implements NullVariableRef {
  NullVariable._();

  @override
  InstanceRef? get ref => null;
}

final class BoolVariable extends ResolvedVariable
    with _SelfResolvedVariable<BoolVariable>
    implements BoolVariableRef {
  BoolVariable._(this.ref) : value = ref.valueAsString! == 'true';
  @override
  final bool value;
  @override
  final InstanceRef ref;
}

final class StringVariable extends ResolvedVariable
    with _SelfResolvedVariable<StringVariable>
    implements StringVariableRef {
  StringVariable._2(this.ref, {required this.value});
  StringVariable._(this.ref) : value = ref.valueAsString! {
    if (ref.valueAsStringIsTruncated ?? false) {
      throw StateError('String value is truncated');
    }
  }

  @override
  final String value;
  @override
  bool get isTruncated => false;
  @override
  String get truncatedValue => value;
  @override
  final InstanceRef ref;
}

final class IntVariable extends ResolvedVariable
    with _SelfResolvedVariable<IntVariable>
    implements VariableRef, IntVariableRef {
  IntVariable._(this.ref) : value = int.parse(ref.valueAsString!);
  @override
  final int value;
  @override
  final InstanceRef ref;
}

final class DoubleVariable extends ResolvedVariable
    with _SelfResolvedVariable<DoubleVariable>
    implements DoubleVariableRef, VariableRef {
  DoubleVariable._(this.ref) : value = double.parse(ref.valueAsString!);

  @override
  final double value;
  @override
  final InstanceRef ref;
}

final class ListVariable extends ResolvedVariable
    with _SelfResolvedVariable<ListVariable>
    implements ListVariableRef, VariableRef {
  ListVariable._(this.ref)
    : children = [
        ...ref.elements!
            .map(Byte.instanceRef)
            .map((byte) => byte.map(VariableRef.fromInstanceRef)),
      ];

  @override
  final List<Byte<VariableRef>> children;
  @override
  final Instance ref;
}

final class RecordVariable extends ResolvedVariable
    with _SelfResolvedVariable<RecordVariable>
    implements RecordVariableRef {
  RecordVariable._(this.ref)
    : children = [
        ...ref.fields!
            .map((field) => _FieldVariableRefImpl(field, object: ref))
            .map(ByteVariable.new),
      ];

  @override
  final List<Byte<FieldVariableRef>> children;
  @override
  final Instance ref;
}

final class SetVariable extends ResolvedVariable
    with _SelfResolvedVariable<SetVariable>
    implements VariableRef {
  SetVariable._(this.ref)
    : children = [
        ...ref.elements!
            .map(Byte.instanceRef)
            .map((byte) => byte.map(VariableRef.fromInstanceRef)),
      ];

  @override
  final List<Byte<VariableRef>> children;
  @override
  final Instance ref;
}

final class TypeVariable extends ResolvedVariable
    with _SelfResolvedVariable<TypeVariable>
    implements TypeVariableRef {
  TypeVariable._(this.ref) : name = ref.name!;

  final String name;
  @override
  final InstanceRef ref;
}

final class UnknownObjectVariable extends ResolvedVariable
    with _SelfResolvedVariable<UnknownObjectVariable>
    implements UnknownObjectVariableRef {
  UnknownObjectVariable._(this.ref)
    : type = ref.classRef!.name!,
      identityHashCode = ref.identityHashCode,
      children = [
        for (final field in ref.fields ?? <BoundField>[])
          ByteVariable(_FieldVariableRefImpl(field, object: ref)),
      ];

  final String type;
  final int? identityHashCode;
  @override
  final List<ByteVariable<FieldVariableRef>> children;
  @override
  final Instance ref;
}

final class FieldVariable extends ResolvedVariable
    with _SelfResolvedVariable<FieldVariable>
    implements FieldVariableRef {
  FieldVariable({required this.key, required this.value});

  final FieldKey key;
  final Byte<ResolvedVariable> value;

  @override
  InstanceRef? get ref => switch (value) {
    ByteVariable<ResolvedVariable>(:final instance) => instance.ref,
    ByteSentinel<ResolvedVariable>() => null,
  };

  @override
  List<Byte<VariableRef>> get children => switch (value) {
    ByteVariable<ResolvedVariable>(:final instance) => instance.children,
    ByteSentinel<ResolvedVariable>() => const [],
  };
}

sealed class FieldKey {
  factory FieldKey.from(Object? key) {
    return switch (key) {
      final String value => NamedFieldKey(value),
      final int value => PositionalFieldKey(value),
      _ => throw StateError('Field name is neither String nor int: $key'),
    };
  }
}

final class PositionalFieldKey implements FieldKey {
  PositionalFieldKey(this.index);
  final int index;
}

final class NamedFieldKey implements FieldKey {
  NamedFieldKey(this.name);
  final String name;
}

// Allow an exhaustive switch over InstanceKind
enum _SealedInstanceKind {
  /// A general instance of the Dart class Object.
  kPlainInstance(InstanceKind.kPlainInstance),

  /// null instance.
  kNull(InstanceKind.kNull),

  /// true or false.
  kBool(InstanceKind.kBool),

  /// An instance of the Dart class double.
  kDouble(InstanceKind.kDouble),

  /// An instance of the Dart class int.
  kInt(InstanceKind.kInt),

  /// An instance of the Dart class String.
  kString(InstanceKind.kString),

  /// An instance of the built-in VM List implementation. User-defined Lists
  /// will be PlainInstance.
  kList(InstanceKind.kList),

  /// An instance of the built-in VM Map implementation. User-defined Maps will
  /// be PlainInstance.
  kMap(InstanceKind.kMap),

  /// An instance of the built-in VM Set implementation. User-defined Sets will
  /// be PlainInstance.
  kSet(InstanceKind.kSet),

  /// Vector instance kinds.
  kFloat32x4(InstanceKind.kFloat32x4),
  kFloat64x2(InstanceKind.kFloat64x2),
  kInt32x4(InstanceKind.kInt32x4),

  /// An instance of the built-in VM TypedData implementations. User-defined
  /// TypedDatas will be PlainInstance.
  kUint8ClampedList(InstanceKind.kUint8ClampedList),
  kUint8List(InstanceKind.kUint8List),
  kUint16List(InstanceKind.kUint16List),
  kUint32List(InstanceKind.kUint32List),
  kUint64List(InstanceKind.kUint64List),
  kInt8List(InstanceKind.kInt8List),
  kInt16List(InstanceKind.kInt16List),
  kInt32List(InstanceKind.kInt32List),
  kInt64List(InstanceKind.kInt64List),
  kFloat32List(InstanceKind.kFloat32List),
  kFloat64List(InstanceKind.kFloat64List),
  kInt32x4List(InstanceKind.kInt32x4List),
  kFloat32x4List(InstanceKind.kFloat32x4List),
  kFloat64x2List(InstanceKind.kFloat64x2List),

  /// An instance of the Dart class Record.
  kRecord(InstanceKind.kRecord),

  /// An instance of the Dart class StackTrace.
  kStackTrace(InstanceKind.kStackTrace),

  /// An instance of the built-in VM Closure implementation. User-defined
  /// Closures will be PlainInstance.
  kClosure(InstanceKind.kClosure),

  /// An instance of the Dart class MirrorReference.
  kMirrorReference(InstanceKind.kMirrorReference),

  /// An instance of the Dart class RegExp.
  kRegExp(InstanceKind.kRegExp),

  /// An instance of the Dart class WeakProperty.
  kWeakProperty(InstanceKind.kWeakProperty),

  /// An instance of the Dart class WeakReference.
  kWeakReference(InstanceKind.kWeakReference),

  /// An instance of the Dart class Type.
  kType(InstanceKind.kType),

  /// An instance of the Dart class TypeParameter.
  kTypeParameter(InstanceKind.kTypeParameter),

  /// An instance of the Dart class TypeRef. Note: this object kind is
  /// deprecated and will be removed.
  kTypeRef(InstanceKind.kTypeRef),

  /// An instance of the Dart class FunctionType.
  kFunctionType(InstanceKind.kFunctionType),

  /// An instance of the Dart class RecordType.
  kRecordType(InstanceKind.kRecordType),

  /// An instance of the Dart class BoundedType.
  kBoundedType(InstanceKind.kBoundedType),

  /// An instance of the Dart class ReceivePort.
  kReceivePort(InstanceKind.kReceivePort),

  /// An instance of the Dart class UserTag.
  kUserTag(InstanceKind.kUserTag),

  /// An instance of the Dart class Finalizer.
  kFinalizer(InstanceKind.kFinalizer),

  /// An instance of the Dart class NativeFinalizer.
  kNativeFinalizer(InstanceKind.kNativeFinalizer),

  /// An instance of the Dart class FinalizerEntry.
  kFinalizerEntry(InstanceKind.kFinalizerEntry);

  const _SealedInstanceKind(this.instanceKind);

  factory _SealedInstanceKind.fromString(String instanceKind) {
    return _SealedInstanceKind.values.firstWhere(
      (kind) => kind.instanceKind == instanceKind,
      orElse: () {
        throw ArgumentError('Unknown InstanceKind: $instanceKind');
      },
    );
  }

  final String instanceKind;
}

enum _SimplifiedInstanceKind {
  nill,
  bool,
  int,
  double,
  string,
  list,
  map,
  set,
  record,
  type,
  object;

  factory _SimplifiedInstanceKind.fromInstanceKind(_SealedInstanceKind kind) {
    switch (kind) {
      case _SealedInstanceKind.kNull:
        return _SimplifiedInstanceKind.nill;
      case _SealedInstanceKind.kBool:
        return _SimplifiedInstanceKind.bool;
      case _SealedInstanceKind.kInt:
      case _SealedInstanceKind.kInt32x4:
        return _SimplifiedInstanceKind.int;
      case _SealedInstanceKind.kDouble:
      case _SealedInstanceKind.kFloat32x4:
      case _SealedInstanceKind.kFloat64x2:
        return _SimplifiedInstanceKind.double;
      case _SealedInstanceKind.kString:
        return _SimplifiedInstanceKind.string;
      case _SealedInstanceKind.kList:
      case _SealedInstanceKind.kUint8ClampedList:
      case _SealedInstanceKind.kUint8List:
      case _SealedInstanceKind.kUint16List:
      case _SealedInstanceKind.kUint32List:
      case _SealedInstanceKind.kUint64List:
      case _SealedInstanceKind.kInt8List:
      case _SealedInstanceKind.kInt16List:
      case _SealedInstanceKind.kInt32List:
      case _SealedInstanceKind.kInt64List:
      case _SealedInstanceKind.kFloat32List:
      case _SealedInstanceKind.kFloat64List:
      case _SealedInstanceKind.kInt32x4List:
      case _SealedInstanceKind.kFloat32x4List:
      case _SealedInstanceKind.kFloat64x2List:
        return _SimplifiedInstanceKind.list;
      case _SealedInstanceKind.kMap:
        return _SimplifiedInstanceKind.map;
      case _SealedInstanceKind.kSet:
        return _SimplifiedInstanceKind.set;
      case _SealedInstanceKind.kRecord:
        return _SimplifiedInstanceKind.record;
      case _SealedInstanceKind.kType:
      case _SealedInstanceKind.kTypeParameter:
      case _SealedInstanceKind.kRecordType:
        return _SimplifiedInstanceKind.type;

      case _SealedInstanceKind.kPlainInstance:
      // Treat unsupported objects as generic objects
      case _SealedInstanceKind.kStackTrace:
      case _SealedInstanceKind.kClosure:
      case _SealedInstanceKind.kMirrorReference:
      case _SealedInstanceKind.kRegExp:
      case _SealedInstanceKind.kWeakProperty:
      case _SealedInstanceKind.kWeakReference:
      case _SealedInstanceKind.kTypeRef:
      case _SealedInstanceKind.kFunctionType:
      case _SealedInstanceKind.kBoundedType:
      case _SealedInstanceKind.kReceivePort:
      case _SealedInstanceKind.kUserTag:
      case _SealedInstanceKind.kFinalizer:
      case _SealedInstanceKind.kNativeFinalizer:
      case _SealedInstanceKind.kFinalizerEntry:
        return _SimplifiedInstanceKind.object;
    }
  }
}
