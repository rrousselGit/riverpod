import 'package:riverpod/src/internals.dart';

typedef AsyncFactory = AsyncNotifierProvider<NotifierT, StateT>
    Function<NotifierT extends AsyncNotifier<StateT>, StateT>(
  NotifierT Function(), {
  Iterable<ProviderOrFamily>? dependencies,
  String? name,
});

typedef AsyncFamilyFactory = AsyncNotifierProvider<NotifierT, StateT>
    Function<NotifierT extends AsyncNotifier<StateT>, StateT>(
  NotifierT Function(), {
  Iterable<ProviderOrFamily>? dependencies,
  String? name,
});

final asyncOrphanFactory = <AsyncFactory>[
  AsyncNotifierProvider.new,
  AsyncNotifierProvider.autoDispose.call,
];

final asyncFamilyFactory = <AsyncFamilyFactory>[
  AsyncNotifierProvider.family.call,
  AsyncNotifierProvider.autoDispose.family.call,
];

final asyncFactory = [];
