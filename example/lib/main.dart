import 'package:provider_hooks/provider_hooks.dart';

final useFutureProvider = FutureProvider((state) async {
  return 42;
});

final useRepository = Provider((_) => Repository());

final useSomethingElse = ProviderBuilder<SomethingElse>()
    .add(useFutureProvider)
    .build((state, first) {
  first.value;
  return SomethingElse();
});

class Repository {}

class SomethingElse {}
