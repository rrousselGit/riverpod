import 'package:riverpod/riverpod.dart';

class Counter {
  Counter({this.value = 0});

  late final int value;

  Counter increment() {
    return Counter(value: value + 1);
  }
}

class MarvelRepository {
  MarvelRepository(
    this.ref, {
    int Function()? getCurrentTimestamp,
  }) : _getCurrentTimestamp = getCurrentTimestamp ??
            (() => DateTime.now().millisecondsSinceEpoch);

  final Ref<MarvelRepository> ref;

  final int Function() _getCurrentTimestamp;
}

/// taken from the marvel example
/// referenced in marvelTearOffConsumer
final marvelRefProvider = Provider(MarvelRepository.new);

/// not ref'd anywhere
final marvelLostProvider = Provider(MarvelRepository.new);

/// This provider will **not** be picked up by the analyzer.
///
/// analyze.dart docs say: Providers must be either top level element or static element of classes.
class MarvelLostProviderContainer {
  static final marvelLostProviderInContainer = Provider(MarvelRepository.new);
}

/// read/watch/listen seem to be required to bring this in scope for analysis
/// just references are not enough
final marvelTearOffConsumer = Provider((ref) {
  // ignore: unused_element
  void doSomething() {
    // ignore: unused_local_variable
    final theTime = ref.read(marvelRefProvider)._getCurrentTimestamp;
  }
});
