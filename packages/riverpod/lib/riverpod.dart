// ignore: invalid_export_of_internal_element, For the sake of backward compatibility. Remove in 3.0
export 'src/framework.dart' show ProviderElementBase;
// ignore: invalid_export_of_internal_element, For the sake of backward compatibility. Remove in 3.0
export 'src/providers/async_notifier.dart'
    show
        AsyncNotifierProviderElement,
        AsyncNotifierProviderElementBase,
        StreamNotifierProviderElement,
        AutoDisposeAsyncNotifierProviderElement,
        AutoDisposeStreamNotifierProviderElement;
// ignore: invalid_export_of_internal_element, For the sake of backward compatibility. Remove in 3.0
export 'src/providers/future_provider.dart'
    show FutureProviderElement, AutoDisposeFutureProviderElement;
// ignore: invalid_export_of_internal_element, For the sake of backward compatibility. Remove in 3.0
export 'src/providers/legacy/state_notifier_provider.dart'
    show StateNotifierProviderElement, AutoDisposeStateNotifierProviderElement;
// ignore: invalid_export_of_internal_element, For the sake of backward compatibility. Remove in 3.0
export 'src/providers/legacy/state_provider.dart'
    show StateProviderElement, AutoDisposeStateProviderElement;
// ignore: invalid_export_of_internal_element, For the sake of backward compatibility. Remove in 3.0
export 'src/providers/notifier.dart'
    show NotifierProviderElement, AutoDisposeNotifierProviderElement;
// ignore: invalid_export_of_internal_element, For the sake of backward compatibility. Remove in 3.0
export 'src/providers/provider.dart'
    show ProviderElement, AutoDisposeProviderElement;
// ignore: invalid_export_of_internal_element, For the sake of backward compatibility. Remove in 3.0
export 'src/providers/stream_provider.dart'
    show StreamProviderElement, AutoDisposeStreamProviderElement;

@Deprecated(
  'This is old API. Use `package:riverpod/legacy.dart` if you want to keep using it.',
)
export 'src/riverpod_legacy.dart';
export 'src/riverpod_without_legacy.dart';
