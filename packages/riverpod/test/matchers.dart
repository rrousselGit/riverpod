import 'package:riverpod/src/framework.dart';
import 'package:riverpod/src/synchronous_future.dart';
import 'package:test/test.dart';

Matcher isPostEventCall(Object kind, [Object? event]) {
  var matcher =
      isA<PostEventCall>().having((e) => e.eventKind, 'eventKind', kind);

  if (event != null) {
    matcher = matcher.having((e) => e.event, 'event', event);
  }

  return matcher;
}

class _Sentinel {
  const _Sentinel();
}

Matcher isSynchronousFuture<T>([Object? value = const _Sentinel()]) {
  var matcher = isA<SynchronousFuture>();

  if (value != const _Sentinel()) {
    matcher = matcher.having((e) => e.value, 'value', value);
  }

  return matcher;
}
