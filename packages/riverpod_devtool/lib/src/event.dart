// ignore: implementation_imports
// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';
import 'dart:math' as math;

import 'package:devtools_app_shared/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: implementation_imports
import 'package:hooks_riverpod/src/internals.dart' as internals;
import 'package:vm_service/vm_service.dart';

import 'core.dart';

part 'event.g.dart';

final class Byte {
  Byte.of(Object? ref) : ref = ref! as InstanceRef;

  final InstanceRef ref;

  @override
  String toString() {
    switch (ref.kind) {
      case InstanceKind.kString:
        return "'${ref.valueAsString}'";
      case InstanceKind.kInt:
      case InstanceKind.kDouble:
      case InstanceKind.kBool:
        return ref.valueAsString!;
      case InstanceKind.kNull:
        return 'null';
      default:
        return 'Byte(...)';
    }
  }
}

Iterable<ItemT> decodeAll<ItemT>(
  Map<String, Byte> events,
  ItemT Function(Map<String, Byte>, {required String path}) fn, {
  required String path,
}) sync* {
  final length = int.parse(events['$path.length']!.ref.valueAsString!);

  for (var i = 0; i < length; i++) {
    final itemPath = '$path[$i]';
    yield fn(events, path: itemPath);
  }
}

String encodeList(
  String expr,
  String Function(String name, String path) mapCode, {
  required String path,
}) {
  return '''
() {
  final list = $expr;
  return {
    '$path.length': list.length,
    for (final (index, e) in list.indexed)
      ...${mapCode('e', '$path[\$index]')},
  };
}()
''';
}

void _validate(
  Map<String, Byte> events, {
  required String name,
  required String path,
}) {
  final startEvent = events['$path._type'];
  switch (startEvent) {
    case Byte(ref: InstanceRef(valueAsString: final actualName)):
      if (actualName != name) {
        throw ArgumentError(
          'Invalid event type, expected "$name" but got $actualName',
        );
      }
    case _:
      throw ArgumentError('Invalid event data for $name: $events');
  }
}

extension type ProviderElementId(String id) {}

final framesProvider =
    AsyncNotifierProvider.autoDispose<FramesNotifier, List<FoldedFrame>>(
      FramesNotifier.new,
      name: 'providerElementsProvider',
    );

class AccumulatedState {
  AccumulatedState._();
}

final class FoldedFrame {
  FoldedFrame({required this.frame, required this.previous}) {
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
          'Got ${previous.frame.index} followed by ${frame.index}',
        );
      }
    } else {
      if (frame.index != 0) {
        throw StateError('The first frame must have index 0');
      }
    }
  }

  final Frame frame;
  final FoldedFrame? previous;
  late final state = _computeAccumulatedState();

  AccumulatedState _computeAccumulatedState() {
    final currentState = previous?.state ?? AccumulatedState._();

    for (final event in frame.events) {
      switch (event) {
        case ProviderContainerAddEvent():
        case ProviderContainerDisposeEvent():
        case ProviderElementAddEvent():
        case ProviderElementDisposeEvent():
        case ProviderElementUpdateEvent():
      }
    }

    return AccumulatedState._();
  }
}

class FramesNotifier extends AsyncNotifier<List<FoldedFrame>> {
  @override
  Future<List<FoldedFrame>> build() async {
    ref.listen(hotRestartEventProvider, (a, b) {
      print('Hot restart detected, clearing frames');
    });
    ref.listen(vmServiceProvider.future, (a, b) {
      print('VM service changed, clearing frames');
    });
    ref.listen(riverpodInternalsEvalProvider.future, (a, b) {
      print('Riverpod eval changed, clearing frames');
    });

    // On hot-restart, clear the frames list.
    ref.watch(hotRestartEventProvider);

    final service = await ref.watch(vmServiceProvider.future);

    final riverpodEval = await ref.watch(riverpodInternalsEvalProvider.future);
    final isAlive = ref.isAlive();

    final sub = service.onNotification
        // Using asyncMap to ensure that notifications are processed in order
        // and one at a time.
        .asyncMap((event) async {
          switch (event) {
            case internals.NewEventNotification():
              print('Handle event $event // ${event.offset}');
              await _fetchNewNotifications(
                event,
                riverpodEval: riverpodEval,
                isAlive: isAlive,
              );
          }
        })
        .listen((_) {});
    ref.onDispose(sub.cancel);

    final rawFrames = await _evalFrames(riverpodEval, isAlive);
    print(
      'Build frames from scratch // ${rawFrames.map((e) => '${e.index} // ${e.timestamp}').join(', ')}',
    );
    final firstFrame = rawFrames.firstOrNull;
    if (firstFrame == null) return const [];

    final mappedFrames = List.filled(
      rawFrames.length,
      FoldedFrame(frame: firstFrame, previous: null),
    );
    for (var i = 1; i < rawFrames.length; i++) {
      final previous = mappedFrames[i - 1];
      final rawFrame = rawFrames[i];

      mappedFrames[i] = FoldedFrame(frame: rawFrame, previous: previous);
    }

    return mappedFrames;
  }

  Future<List<Frame>> _evalFrames(
    Eval eval,
    Disposable isAlive, {
    int startIndex = 0,
  }) async {
    final code = encodeList(
      'RiverpodDevtool.instance.frames.sublist($startIndex)',
      (e, path) => "$e.toBytes(path: '$path')",
      path: 'root',
    );

    final instance = await eval.evalInstance(code, isAlive: isAlive);
    final map = Map.fromEntries(
      instance.associations!.map(
        (e) => MapEntry(Byte.of(e.key).ref.valueAsString!, Byte.of(e.value)),
      ),
    );

    return decodeAll(map, Frame.from, path: 'root').toList();
  }

  Future<void> _fetchNewNotifications(
    internals.NewEventNotification notification, {
    required Eval riverpodEval,
    required Disposable isAlive,
  }) async {
    final frames = await future;
    final alreadyHasNewFrame = notification.offset <= frames.length - 1;
    if (alreadyHasNewFrame) return;

    final newFrames = await _evalFrames(
      riverpodEval,
      isAlive,
      startIndex: math.max(frames.length, 0),
    );

    state = AsyncData([
      ...?state.value,
      for (final frame in newFrames)
        FoldedFrame(frame: frame, previous: state.value?.lastOrNull),
    ]);
  }
}

/// A provider that emits an update when a hot-restart is detected.
final hotRestartEventProvider = Provider<void>(
  name: 'hotRestartEventProvider',
  (ref) async {
    final service = await ref.watch(serviceManagerProvider.future);
    if (!ref.mounted) return;
    final selectedIsolateListenable = service.isolateManager.selectedIsolate;

    var isolateId = selectedIsolateListenable.value?.id;

    void listener() {
      final newId = selectedIsolateListenable.value?.id;
      final oldId = isolateId;
      isolateId = newId;

      if (oldId != null && oldId != newId) {
        ref.notifyListeners();
        return;
      }
    }

    selectedIsolateListenable.addListener(listener);
    ref.onDispose(() => selectedIsolateListenable.removeListener(listener));
  },
);

extension NotificationService on VmService {
  Stream<internals.Notification> get onNotification =>
      onExtensionEvent.expand((event) {
        final notification = internals.Notification.fromJson(
          event.extensionKind ?? '',
          event.extensionData?.data ?? {},
        );
        if (notification != null) {
          return [notification];
        }
        return const [];
      });
}
