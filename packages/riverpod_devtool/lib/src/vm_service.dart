// ignore: implementation_imports
// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:devtools_app_shared/utils.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart' as internals;
import 'package:vm_service/vm_service.dart';

part 'vm_service.g.dart';

final class Byte {
  Byte.of(Object? ref) : ref = ref! as InstanceRef;

  final InstanceRef ref;

  @override
  String toString() {
    switch (ref.kind) {
      case InstanceKind.kString:
        return "'${ref.valueAsString}'";
      case InstanceKind.kInt:
      case InstanceKind.kDouble:
      case InstanceKind.kBool:
        return ref.valueAsString!;
      case InstanceKind.kNull:
        return 'null';
      default:
        return 'Byte(...)';
    }
  }
}

Iterable<ItemT> decodeAll<ItemT>(
  Map<String, Byte> events,
  ItemT Function(Map<String, Byte>, {required String path}) fn, {
  required String path,
}) sync* {
  final length = int.parse(events['$path.length']!.ref.valueAsString!);

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
  Map<String, Byte> events, {
  required String name,
  required String path,
}) {
  final startEvent = events['$path._type'];
  switch (startEvent) {
    case Byte(ref: InstanceRef(valueAsString: final actualName)):
      if (actualName != name) {
        throw ArgumentError(
          'Invalid event type, expected "$name" but got $actualName',
        );
      }
    case _:
      throw ArgumentError('Invalid event data for $name: $events');
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

class Eval {
  Eval._(this._eval);
  final EvalOnDartLibrary _eval;

  String _formatCode(String code) => code.replaceAll('\n', ' ');

  Future<InstanceRef> eval(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) async {
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

  Future<Instance> instance(
    InstanceRef ref, {
    required Disposable isAlive,
  }) async {
    final res = await _eval.getInstance(ref, isAlive);
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
  Disposable isAlive() {
    final disposable = Disposable();
    onDispose(disposable.dispose);
    return disposable;
  }
}

sealed class VariableRef {
  factory VariableRef.fromInstanceRef(InstanceRef ref) {
    switch (_InstanceKind.fromString(ref.kind!)) {
      case _InstanceKind.kString:
        return StringVariableRef(
          truncatedValue: ref.valueAsString!,
          isTruncated: ref.valueAsStringIsTruncated!,
        );
      case _InstanceKind.kInt:
      case _InstanceKind.kInt32x4:
        return IntVariableRef(value: int.parse(ref.valueAsString!));
      case _InstanceKind.kDouble:
      case _InstanceKind.kFloat32x4:
      case _InstanceKind.kFloat64x2:
        return DoubleVariableRef(value: double.parse(ref.valueAsString!));
      case _InstanceKind.kBool:
        return BoolVariableRef(value: ref.valueAsString == 'true');
      case _InstanceKind.kNull:
        return NullVariableRef();
      case _InstanceKind.kList:
      case _InstanceKind.kUint8ClampedList:
      case _InstanceKind.kUint8List:
      case _InstanceKind.kUint16List:
      case _InstanceKind.kUint32List:
      case _InstanceKind.kUint64List:
      case _InstanceKind.kInt8List:
      case _InstanceKind.kInt16List:
      case _InstanceKind.kInt32List:
      case _InstanceKind.kInt64List:
      case _InstanceKind.kFloat32List:
      case _InstanceKind.kFloat64List:
      case _InstanceKind.kInt32x4List:
      case _InstanceKind.kFloat32x4List:
      case _InstanceKind.kFloat64x2List:
        return ListVariableRef(length: 0, items: []);
      case _InstanceKind.kMap:
        return MapVariableRef(entries: {});
      case _InstanceKind.kSet:
        return SetVariableRef(length: 0, items: []);

      case _InstanceKind.kType:
      case _InstanceKind.kTypeParameter:
        return TypeVariableRef(name: ref.name!);

      case _InstanceKind.kRecord:
      case _InstanceKind.kStackTrace:
      case _InstanceKind.kRecordType:

      // TODO:

      case _InstanceKind.kPlainInstance:

      // Unsupported objects. We treat them as unknown.
      case _InstanceKind.kClosure:
      case _InstanceKind.kRegExp:
      case _InstanceKind.kMirrorReference:
      case _InstanceKind.kWeakProperty:
      case _InstanceKind.kWeakReference:
      case _InstanceKind.kTypeRef:
      case _InstanceKind.kFunctionType:
      case _InstanceKind.kBoundedType:
      case _InstanceKind.kReceivePort:
      case _InstanceKind.kUserTag:
      case _InstanceKind.kFinalizer:
      case _InstanceKind.kNativeFinalizer:
      case _InstanceKind.kFinalizerEntry:
        return UnknownObjectVariableRef();
    }
  }
}

final class NullVariableRef implements VariableRef {}

final class BoolVariableRef implements VariableRef {
  BoolVariableRef({required this.value});
  final bool value;
}

final class StringVariableRef implements VariableRef {
  StringVariableRef({required this.truncatedValue, required this.isTruncated});

  final String truncatedValue;
  final bool isTruncated;
  String? get value => isTruncated ? null : truncatedValue;
}

final class IntVariableRef implements VariableRef {
  IntVariableRef({required this.value});
  final int value;
}

final class DoubleVariableRef implements VariableRef {
  DoubleVariableRef({required this.value});
  final double value;
}

final class RecordVariableRef implements VariableRef {
  RecordVariableRef({required this.fields});

  final Map<String, VariableRef> fields;
}

final class ListVariableRef implements VariableRef {
  ListVariableRef({required this.length, required this.items});

  final int length;
  final List<VariableRef> items;
}

final class MapVariableRef implements VariableRef {
  MapVariableRef({required this.entries});

  final Map<VariableRef, VariableRef> entries;
}

final class SetVariableRef implements VariableRef {
  SetVariableRef({required this.length, required this.items});

  final int length;
  final List<VariableRef> items;
}

final class TypeVariableRef implements VariableRef {
  TypeVariableRef({required this.name});

  final String name;
}

final class UnknownObjectVariableRef implements VariableRef {}

sealed class ResolvedVariable {}

final class NullVariable extends ResolvedVariable {}

enum _InstanceKind {
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

  const _InstanceKind(this.instanceKind);

  factory _InstanceKind.fromString(String instanceKind) {
    return _InstanceKind.values.firstWhere(
      (kind) => kind.instanceKind == instanceKind,
      orElse: () {
        throw ArgumentError('Unknown InstanceKind: $instanceKind');
      },
    );
  }

  final String instanceKind;
}
