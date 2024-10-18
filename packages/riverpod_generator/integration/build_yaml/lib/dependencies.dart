import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'main.dart';

part 'dependencies.g.dart';

@Riverpod(
  dependencies: [
    count,
    countFuture,
    countStream,
    CountNotifier,
    CountAsyncNotifier,
    CountStreamNotifier,
    count2,
    countFuture2,
    countStream2,
    CountNotifier2,
    CountAsyncNotifier2,
    CountStreamNotifier2,
  ],
)
int calc2(Ref ref, String id) {
  ref.watch(myCountPod);
  ref.watch(myCountFuturePod);
  ref.watch(myCountStreamPod);
  ref.watch(myCountNotifierPod);
  ref.watch(myCountAsyncNotifierPod);
  ref.watch(myCountStreamNotifierPod);
  ref.watch(myFamilyCount2ProviderFamily(1));
  ref.watch(myFamilyCountFuture2ProviderFamily(1));
  ref.watch(myFamilyCountStream2ProviderFamily(1));
  ref.watch(myFamilyCountNotifier2ProviderFamily(1));
  ref.watch(myFamilyCountAsyncNotifier2ProviderFamily(1));
  ref.watch(myFamilyCountStreamNotifier2ProviderFamily(1));

  return 1;
}
