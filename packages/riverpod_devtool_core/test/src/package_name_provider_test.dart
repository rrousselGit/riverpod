import 'package:riverpod/riverpod.dart';
import 'package:riverpod_devtool_core/src/connection.dart';
import 'package:riverpod_devtool_core/src/package_name_provider.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart';

import '../utils.dart';

class _Service implements VmService {
  _Service(this.rootLibrary);

  final String? rootLibrary;

  @override
  Future<Isolate> getIsolate(String isolateId) async {
    return Isolate(
      id: isolateId,
      rootLib: switch (rootLibrary) {
        null => null,
        final uri => LibraryRef(id: 'libraries/1', uri: uri),
      },
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<String?> _packageName(FakeConnection connection) {
  final container = ProviderContainer.test(
    overrides: [appConnectionProvider.overrideWith((ref) => connection)],
  );
  return container.read(currentPackageNameProvider.future);
}

void main() {
  group('UriPackageName', () {
    test('is the first segment of package URIs', () {
      expect(Uri.parse('package:foo/src/bar.dart').packageName, 'foo');
    });

    test('is null for other URIs', () {
      expect(Uri.parse('dart:core').packageName, isNull);
      expect(Uri.parse('file:///foo/bar.dart').packageName, isNull);
      expect(Uri.parse('package:').packageName, isNull);
    });
  });

  group('currentPackageNameProvider', () {
    test('is the package of the root library', () async {
      final connection = FakeConnection(_Service('package:my_app/main.dart'));

      expect(await _packageName(connection), 'my_app');
    });

    test('is null when the application has no root library', () async {
      expect(await _packageName(FakeConnection(_Service(null))), isNull);
    });

    test('is null while no isolate is selected', () async {
      final connection = FakeConnection(_Service('package:my_app/main.dart'))
        ..isolate = null;

      expect(await _packageName(connection), isNull);
    });

    test('follows the isolate that is selected', () async {
      final connection = FakeConnection(_Service('package:my_app/main.dart'))
        ..isolate = null;
      final container = ProviderContainer.test(
        overrides: [appConnectionProvider.overrideWith((ref) => connection)],
      );
      container.listen(currentPackageNameProvider, (_, _) {});
      expect(await container.read(currentPackageNameProvider.future), isNull);

      connection.isolate = IsolateRef(id: 'isolates/2', name: 'main');

      expect(await container.read(currentPackageNameProvider.future), 'my_app');
    });

    test('is null for applications started from a file', () async {
      final app = await startApp();

      expect(
        await app.container().read(currentPackageNameProvider.future),
        isNull,
      );
    });
  });
}
