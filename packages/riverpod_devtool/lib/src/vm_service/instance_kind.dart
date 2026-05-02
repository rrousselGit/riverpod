part of '../vm_service.dart';

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
