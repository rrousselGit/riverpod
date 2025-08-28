// ignore: implementation_imports
import 'dart:async';

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
  try {
    final length = int.parse(events['$path.length']!.ref.valueAsString!);

    for (var i = 0; i < length; i++) {
      final itemPath = '$path[$i]';
      yield fn(events, path: itemPath);
    }
  } catch (e, stack) {
  } finally {}
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
    AsyncNotifierProvider.autoDispose<FramesNotifier, Frames>(
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
        throw StateError('Frames must be in chronological order');
      }

      if (frame.index != previous.frame.index + 1) {
        throw StateError('Frame index must be strictly increasing');
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

    return AccumulatedState._();
  }
}

class Frames {
  const Frames.initial({required this.frames});

  final List<FoldedFrame> frames;
}

class FramesNotifier extends AsyncNotifier<Frames> {
  @override
  Future<Frames> build() async {
    final service = await ref.watch(vmServiceProvider.future);

    if (!state.hasValue) state = const AsyncData(Frames.initial(frames: []));

    final riverpodEval = await ref.watch(riverpodInternalsEvalProvider.future);
    final isAlive = ref.isAlive();

    final onNotification = ref.debounce<internals.Notification>((notifs) {});

    final sub = service.onNotification.listen(onNotification);
    ref.onDispose(sub.cancel);

    final rawFrames = await _evanFrames(riverpodEval, isAlive);
    final firstFrame = rawFrames.firstOrNull;
    if (firstFrame == null) return const Frames.initial(frames: []);

    final mappedFrames = List.filled(
      rawFrames.length,
      FoldedFrame(frame: firstFrame, previous: null),
    );
    for (var i = 1; i < rawFrames.length; i++) {
      final previous = mappedFrames[i - 1];
      final rawFrame = rawFrames[i];

      mappedFrames[i] = FoldedFrame(frame: rawFrame, previous: previous);
    }

    return Frames.initial(frames: mappedFrames);
  }

  Future<List<Frame>> _evanFrames(
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
}

extension NotificationService on VmService {
  Stream<internals.Notification> get onNotification =>
      onExtensionEvent.expand((event) {
        final notification = internals.Notification.fromJson(event.json!);
        if (notification != null) return [notification];
        return const [];
      });
}

extension on Ref {
  void Function(DebouncedT) debounce<DebouncedT>(
    void Function(List<DebouncedT> items) fn, {
    Duration delay = const Duration(milliseconds: 100),
  }) {
    final buffer = <DebouncedT>[];
    Timer? timer;
    onDispose(() {
      timer?.cancel();
      if (buffer.isNotEmpty) {
        fn(List.of(buffer));
        buffer.clear();
      }
    });

    return (item) {
      buffer.add(item);
      timer?.cancel();
      timer = Timer(delay, () {
        fn(List.of(buffer));
        buffer.clear();
      });
    };
  }
}
