part of 'framework.dart';

@internal
class SchedulerBinding {
  final _toBuild = <ProviderElement<Object?>>[];

  bool _closed = false;

  int scheduleBuildFor(ProviderElement<Object?> element) =>
      _depthBasedInsert(element);

  int _depthBasedInsert(ProviderElement<Object?> element, [int start = 0]) {
    final depth = element.depthApproximation;
    final index = _toBuild.indexWhere(
      (e) => e.depthApproximation > depth,
      start,
    );

    if (index == -1) {
      _toBuild.add(element);
      return _toBuild.length - 1;
    } else {
      _toBuild.insert(index, element);
      return index;
    }
  }

  int rescheduleBuildFor(ProviderElement<Object?> element, int previousIndex) {
    final index = _toBuild.indexOf(element, previousIndex);
    assert(index >= 0, 'The element was not found in the list of providers');

    _toBuild.removeAt(index);

    return _depthBasedInsert(element, index + 1);
  }

  void _task() {
    if (_closed) return;

    flushBuild();
  }

  void flushBuild() {
    var debugDepth = 0;

    for (var x = 0; x < _toBuild.length; x++) {
      // Assert that the elements are sorted by their depth
      if (kDebugMode) {
        assert(
          debugDepth <= _toBuild[x].depthApproximation,
          'Bad state, the internal list of providers is incorrectly sorted',
        );
        debugDepth = _toBuild[x].depthApproximation;
      }

      final element = _toBuild[x];

      if (!element.paused && !element.disposed) element._runProviderBuild();
    }
    _toBuild.clear();
  }

  void close() {
    _closed = true;
  }
}
