import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'old_lifecycles_final.g.dart';

@riverpod
Duration duration(DurationRef ref) => const Duration(seconds: 1);

@riverpod
// ignore: library_private_types_in_public_api
_MyRepo repository(RepositoryRef ref) => _MyRepo();

class _MyRepo {
  Future<void> update(int i, {CancelToken? token}) async {}
}

/* SNIPPET START */
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  int build() {
    // {@template period}
    // Just read/write the code here, in one place
    // {@endtemplate}
    final period = ref.watch(durationProvider);
    final timer = Timer.periodic(period, (t) => update());
    ref.onDispose(timer.cancel);

    return 0;
  }

  Future<void> update() async {
    final cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    await ref.read(repositoryProvider).update(state + 1, token: cancelToken);
    // {@template codegen_cancel}
    // When `cancelToken.cancel` is invoked, a custom Exception is thrown
    // {@endtemplate}
    state++;
  }
}
