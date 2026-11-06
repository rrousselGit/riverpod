import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'vm_service.dart';

/// A provider that returns the current package name as discovered from the
/// currently selected isolate in the connected VM service.
final currentPackageNameProvider = FutureProvider<String?>((ref) async {
  final vmService = await ref.watch(vmServiceProvider.future);
  final serviceManager = await ref.watch(serviceManagerProvider.future);

  final selectedIsolateRef =
      serviceManager.isolateManager.selectedIsolate.value;
  final isolateId = selectedIsolateRef?.id;
  if (isolateId == null) return null;

  final isolate = await vmService.getIsolate(isolateId);

  final rootUriStr = isolate.rootLib?.uri;
  if (rootUriStr == null) return null;

  return Uri.parse(rootUriStr).packageName;
});

extension UriPackageName on Uri {
  /// Returns the package name if this is a `package:` URI, or `null` otherwise.
  String? get packageName {
    if (scheme != 'package') return null;
    if (pathSegments.isEmpty) return null;
    return pathSegments.first;
  }
}
