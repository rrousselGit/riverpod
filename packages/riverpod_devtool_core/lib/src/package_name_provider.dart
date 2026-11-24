import 'package:riverpod/riverpod.dart';

import 'connection.dart';
import 'vm_service.dart';

/// A provider that returns the current package name as discovered from the
/// currently selected isolate in the connected VM service.
final currentPackageNameProvider = FutureProvider<String?>((ref) async {
  // The connection stays the same when its isolate changes.
  ref.watch(hotRestartEventProvider);
  final connection = await ref.watch(appConnectionProvider.future);

  final isolateId = connection.isolate?.id;
  if (isolateId == null) return null;

  final isolate = await connection.service.getIsolate(isolateId);

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
