// GENERATED from packages/riverpod_devtool_core/README.md by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';
import 'package:riverpod/riverpod.dart';
import 'package:vm_service/vm_service_io.dart';

dynamic snippet() async {
  final service = await vmServiceConnectUri('ws://127.0.0.1:8181/ws');
  final connection = await VmServiceConnection.start(service);

  final container = ProviderContainer(
    overrides: [appConnectionProvider.overrideWith((ref) => connection)],
  );

  final frames = await container.read(framesProvider.future);
}
