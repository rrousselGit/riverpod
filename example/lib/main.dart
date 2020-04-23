import 'package:flutter/widgets.dart';
import 'package:provider_hooks/provider_hooks.dart';

final useFutureProvider = FutureProvider((state) async {
  return 42;
});

final useRepository = Provider((_) => Repository());

final useSomethingElse = ProviderBuilder<SomethingElse>()
    .add(useFutureProvider)
    .build((state, first) {
  first.future;
  return SomethingElse();
});

class Repository {}

class SomethingElse {}

// final controller = Provider((state) {
//   final result = ValueNotifier(0);

//   state.onDispose(result.dispose);

//   return result;
// });

// final listener = ProviderBuilder<int>() //
//     .add(controller)
//     .build((state, notifier) {

//   something.onChange((value) {

//   });
//   void listener() {
//     state.setState(notifier.value.value);
//   }

//   notifier.value.addListener(listener);
//   state.onDispose(() => notifier.value.removeListener(listener));

//   // return notifier.value.value;

//   return state.doOnChange(notifier, (value) {
//     return value * 2;
//   });
// });
