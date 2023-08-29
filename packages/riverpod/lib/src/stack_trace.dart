import 'package:meta/meta.dart';
import 'package:stack_trace/stack_trace.dart';

/// Rethrows [error] with a stacktrace that is the combination of [stackTrace]
/// and [StackTrace.current].
@internal
Never throwErrorWithCombinedStackTrace(Object error, StackTrace stackTrace) {
  final chain = Chain([
    Trace.current(),
    ...Chain.forTrace(stackTrace).traces,
  ]).foldFrames((frame) => frame.package == 'riverpod');

  Error.throwWithStackTrace(error, chain.toTrace().vmTrace);
}
