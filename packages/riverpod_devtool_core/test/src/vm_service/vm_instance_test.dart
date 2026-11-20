import 'package:riverpod_devtool_core/src/vm_service.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart' as vm;

void main() {
  final loaded = vm.Instance(id: 'objects/1', kind: vm.InstanceKind.kNull);
  final reference = vm.InstanceRef(
    id: 'objects/2',
    kind: vm.InstanceKind.kNull,
  );

  group('VmInstanceRef.fromObject', () {
    test('wraps the references that the VM service returns', () {
      expect(VmInstanceRef.fromObject(reference).raw, same(reference));
      expect(VmInstanceRef.fromObject(loaded).raw, same(loaded));
    });

    test('rejects responses that are not instances', () {
      expect(
        () => VmInstanceRef.fromObject(vm.Sentinel(kind: 'Expired')),
        throwsStateError,
      );
      expect(() => VmInstanceRef.fromObject(null), throwsStateError);
    });
  });

  test('VmInstance is its own reference', () {
    expect(VmInstance(loaded).ref.raw, same(loaded));
  });
}
