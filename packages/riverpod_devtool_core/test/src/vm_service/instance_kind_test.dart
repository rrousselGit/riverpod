import 'package:riverpod_devtool_core/src/vm_service.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart' as vm;

ResolvedVariable? _resolve(String kind, {String? name}) {
  return ResolvedVariable.fromInstance(
    RootCachedObject(CacheId(kind)),
    VmInstance(vm.Instance(id: kind, kind: kind, name: name, elements: [])),
  );
}

void main() {
  test('typed data is inspected as lists', () {
    for (final kind in [
      vm.InstanceKind.kUint8ClampedList,
      vm.InstanceKind.kUint8List,
      vm.InstanceKind.kUint16List,
      vm.InstanceKind.kUint32List,
      vm.InstanceKind.kUint64List,
      vm.InstanceKind.kInt8List,
      vm.InstanceKind.kInt16List,
      vm.InstanceKind.kInt32List,
      vm.InstanceKind.kInt64List,
      vm.InstanceKind.kFloat32List,
      vm.InstanceKind.kFloat64List,
      vm.InstanceKind.kInt32x4List,
      vm.InstanceKind.kFloat32x4List,
      vm.InstanceKind.kFloat64x2List,
    ]) {
      expect(_resolve(kind), isA<ListVariable>(), reason: kind);
    }
  });

  test('every kind of type is inspected as a type', () {
    for (final kind in [
      vm.InstanceKind.kType,
      vm.InstanceKind.kTypeParameter,
      vm.InstanceKind.kRecordType,
    ]) {
      expect(
        _resolve(kind, name: 'T'),
        isA<TypeVariable>().having((e) => e.name, 'name', 'T'),
        reason: kind,
      );
    }
  });

  test(
    'kinds without a dedicated rendering are left to be read as objects',
    () {
      for (final kind in [
        vm.InstanceKind.kPlainInstance,
        vm.InstanceKind.kStackTrace,
        vm.InstanceKind.kClosure,
        vm.InstanceKind.kMirrorReference,
        vm.InstanceKind.kRegExp,
        vm.InstanceKind.kWeakProperty,
        vm.InstanceKind.kWeakReference,
        vm.InstanceKind.kTypeRef,
        vm.InstanceKind.kFunctionType,
        vm.InstanceKind.kBoundedType,
        vm.InstanceKind.kReceivePort,
        vm.InstanceKind.kUserTag,
        vm.InstanceKind.kFinalizer,
        vm.InstanceKind.kNativeFinalizer,
        vm.InstanceKind.kFinalizerEntry,
      ]) {
        expect(_resolve(kind), isNull, reason: kind);
      }
    },
  );
}
