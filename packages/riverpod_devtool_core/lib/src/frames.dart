import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' as internals;

import 'connection.dart';
import 'elements.dart';
import 'riverpod.dart';
import 'vm_service.dart';

enum ProviderStatusInFrame { added, modified, disposed }

extension type FrameId(int value) {}

/// Provider that filters frames to only include those with state changes
/// (creation, update, or deletion).
final filteredFramesProvider = Provider<AsyncValue<List<FoldedFrame>>>(
  name: 'filteredFramesProvider',
  (ref) {
    final frames = ref.watch(framesProvider);
    return frames.whenData(
      (frames) => frames.where((f) => f.hasStateChanges).toList(),
    );
  },
);

final selectedFrameIdProvider =
    NotifierProvider<StateNotifier<FrameId?>, FrameId?>(
      name: 'selectedFrameIdProvider',
      () => StateNotifier<FrameId?>((ref, self) {
        // Clear selected frame on hot-restart, due to frames being cleared too
        ref.watch(hotRestartEventProvider);

        ref.listen(filteredFramesProvider, fireImmediately: true, (
          previous,
          next,
        ) {
          late final wasLastSelectedFrame =
              previous?.value?.lastOrNull?.id == self.state;
          late final newFramesContainsId =
              next.value?.map((frame) => frame.id).contains(self.state) ??
              false;

          if (self.stateOrNull == null ||
              wasLastSelectedFrame ||
              !newFramesContainsId) {
            self.state = next.value?.lastOrNull?.id;
          }
        });

        return self.stateOrNull;
      }),
    );

final selectedFrameProvider = Provider<FoldedFrame?>(
  name: 'selectedFrameProvider',
  (ref) {
    final frames = ref.watch(filteredFramesProvider);
    final selectedFrameId = ref.watch(selectedFrameIdProvider);

    if (selectedFrameId == null) return null;

    final frame = frames.value
        ?.where((frame) => frame.id == selectedFrameId)
        .firstOrNull;
    if (frame == null) {
      throw StateError(
        'Selected frame with id ${selectedFrameId.value} not found among '
        '${frames.value?.length ?? 0} available frames',
      );
    }

    return frame;
  },
);

final framesProvider =
    AsyncNotifierProvider.autoDispose<FramesNotifier, List<FoldedFrame>>(
      FramesNotifier.new,
      name: 'framesProvider',
    );

@immutable
final class FoldedFrame {
  FoldedFrame({
    required this.frame,
    required this.previous,
    List<Frame> newFrames = const [],
  }) {
    final previous = this.previous;
    if (previous != null) {
      if (frame.timestamp.isBefore(previous.frame.timestamp)) {
        throw StateError(
          'Frames must be in chronological order. Current: '
          '${frame.timestamp} at ${frame.index}, previous: ${previous.frame.timestamp} at ${previous.frame.index}',
        );
      }

      if (frame.index != previous.frame.index + 1) {
        throw StateError(
          'Frame index must be strictly increasing. '
          '${_debugGetAllFrameIndexes().join(' -> ')} // new frames indexes: ${newFrames.map((f) => f.index).join(', ')}',
        );
      }
    } else {
      if (frame.index != 0) {
        throw StateError('The first frame must have index 0');
      }
    }
  }

  List<int> _debugGetAllFrameIndexes() {
    final indexes = <int>[];
    for (
      FoldedFrame? current = this;
      current != null;
      current = current.previous
    ) {
      indexes.add(current.frame.index);
    }
    return indexes.toList();
  }

  FrameId get id => FrameId(frame.index);

  final Frame frame;
  final FoldedFrame? previous;

  late final elements = computeElementsForFrame(this);

  ProviderStatusInFrame? statusOf(internals.ElementId id) {
    for (final event in frame.events) {
      switch (event) {
        case ProviderElementAddEvent(:final provider)
            when provider.elementId == id:
          return ProviderStatusInFrame.added;
        case ProviderElementUpdateEvent(:final provider)
            when provider.elementId == id:
          return ProviderStatusInFrame.modified;
        case ProviderElementDisposeEvent(:final provider)
            when provider.elementId == id:
          return ProviderStatusInFrame.disposed;
        case _:
          continue;
      }
    }

    return null;
  }

  /// Returns true if this frame contains at least one state update/creation/deletion.
  bool get hasStateChanges {
    for (final event in frame.events) {
      switch (event) {
        case ProviderElementAddEvent() ||
            ProviderElementUpdateEvent() ||
            ProviderElementDisposeEvent():
          return true;
        case _:
          continue;
      }
    }
    return false;
  }
}

class FramesNotifier extends AsyncNotifier<List<FoldedFrame>> {
  List<FoldedFrame>? _lastFrames;
  @override
  Future<List<FoldedFrame>> build() async {
    // On hot-restart, clear the frames list.
    ref.watch(hotRestartEventProvider);
    _lastFrames = null;
    final isAlive = ref.disposable();
    final sessionFuture = ref.watch(devtoolSessionProvider.future);
    final connectionFuture = ref.watch(appConnectionProvider.future);
    final evalFuture = ref.watch(riverpodEvalProvider.future);
    final sessionId = await sessionFuture;
    final connection = await connectionFuture;
    final riverpodEval = await evalFuture;
    if (isAlive.disposed) throw CancelledException();

    final sub = connection.onNotification
        // Using asyncMap to ensure that notifications are processed in order
        // and one at a time.
        .asyncMap((event) async {
          switch (event) {
            case internals.NewEventNotification():
              await _oneAtATime(
                () => _fetchNewNotifications(
                  event,
                  sessionId: sessionId,
                  riverpodEval: riverpodEval,
                  isAlive: isAlive,
                ),
              );
          }
        })
        .listen(
          (_) {},
          onError: (Object error, StackTrace stackTrace) {
            if (isAlive.disposed || error is CancelledException) return;
            state = AsyncError(error, stackTrace);
          },
        );
    ref.onDispose(sub.cancel);

    _fetchAll = () async {
      // Changes are published asynchronously, once providers are done
      // rebuilding.
      await riverpodEval.waitUntil(
        'RiverpodDevtool.instance._pendingFrame == null',
        isAlive: isAlive,
      );

      return foldFrames(
        const [],
        await _evalFrames(riverpodEval, isAlive, sessionId: sessionId),
      );
    };

    final rawFrames = await _evalFrames(
      riverpodEval,
      isAlive,
      sessionId: sessionId,
    );
    return _lastFrames = foldFrames(const [], rawFrames);
  }

  late Future<List<FoldedFrame>> Function() _fetchAll;

  /// Waits for [state] to include every change that the application made so
  /// far, instead of waiting for the application to notify of them.
  Future<void> sync() async {
    await future;
    await _oneAtATime(() async {
      state = AsyncData(_lastFrames = await _fetchAll());
    });
  }

  /// The fetch of frames that runs, or the last one that did.
  Future<void> _lastFetch = Future.value();

  /// Fetches frames one at a time.
  ///
  /// The application cannot export frames twice at once, and a fetch that
  /// started earlier would otherwise replace the frames of a later one.
  Future<void> _oneAtATime(Future<void> Function() fetch) {
    final result = _lastFetch.then((_) => fetch());
    _lastFetch = result.then((_) {}, onError: (Object _) {});
    return result;
  }

  Future<List<Frame>> _evalFrames(
    Eval eval,
    Disposable isAlive, {
    required String sessionId,
    int startIndex = 0,
  }) async {
    final code = encodeList(
      'RiverpodDevtool.instance.frames.skip('
      'RiverpodDevtool.instance.frames.length == 1 ? 0 : $startIndex)',
      (e, path) => "$e.toBytes(path: '$path')",
      path: 'root',
    );

    final instanceByte = await eval.evalInstance(
      'RiverpodDevtool.instance.withFrameCache("$sessionId", () => $code)',
      isAlive: isAlive,
    );
    if (isAlive.disposed) throw CancelledException();
    if (instanceByte case ByteError(error: ExpiredDevtoolSessionType())) {
      // A throttled/suspended tab can miss heartbeats. Opening a new session
      // rebuilds this provider and fetches the full current snapshot.
      ref.invalidate(devtoolSessionProvider);
      throw CancelledException();
    }
    // TODO remove require
    final instance = instanceByte.require.instance;
    final map = Map.fromEntries(
      instance.associations!.map((e) {
        final key = VmInstanceRef.fromObject(e.key);
        final value = VmInstanceRef.fromObject(e.value);

        return MapEntry(key.valueAsString!, value);
      }),
    );

    return decodeAll<Frame>(map, Frame.from, path: 'root').toList();
  }

  Future<void> _fetchNewNotifications(
    internals.NewEventNotification notification, {
    required String sessionId,
    required Eval riverpodEval,
    required Disposable isAlive,
  }) async {
    final frames = state.value ?? _lastFrames ?? await future;
    final replacesHistory = notification.offset == 0;
    final alreadyHasNewFrame =
        !state.hasError &&
        !replacesHistory &&
        notification.offset <= frames.length - 1;
    if (alreadyHasNewFrame) return;

    final newFrames = await _evalFrames(
      riverpodEval,
      isAlive,
      sessionId: sessionId,
      startIndex: replacesHistory ? 0 : frames.length,
    );

    state = AsyncData(_lastFrames = foldFrames(frames, newFrames));
  }
}

/// A frame at index zero replaces the baseline when history is not retained.
List<FoldedFrame> foldFrames(
  List<FoldedFrame> previousFrames,
  List<Frame> newFrames,
) {
  final result = newFrames.firstOrNull?.index == 0
      ? <FoldedFrame>[]
      : [...previousFrames];
  for (final frame in newFrames) {
    result.add(
      FoldedFrame(
        frame: frame,
        previous: result.lastOrNull,
        newFrames: newFrames,
      ),
    );
  }
  return result;
}

final timeTravelProvider =
    AsyncNotifierProvider.autoDispose<TimeTravelNotifier, bool>(
      TimeTravelNotifier.new,
    );

class TimeTravelNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // Re-read the application's flag after frames change, including changes
    // made directly through debugTrackProviderHistory and hot restarts.
    ref.watch(framesProvider);
    final isAlive = ref.disposable();
    final eval = await ref.watch(riverpodEvalProvider.future);
    final result = await eval.eval(
      'debugTrackProviderHistory',
      isAlive: isAlive,
    );
    return result.require.instance.valueAsString == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    // Changing the flag emits a frame notification, which can rebuild this
    // provider before the assignment's VM response arrives.
    final isAlive = Disposable();
    try {
      final eval = await ref.read(riverpodEvalProvider.future);
      final result = await eval.eval(
        'debugTrackProviderHistory = $enabled',
        isAlive: isAlive,
      );
      result.require;
      if (ref.mounted) ref.invalidateSelf();
    } finally {
      isAlive.dispose();
    }
  }
}
