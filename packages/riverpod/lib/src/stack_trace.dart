import 'package:stack_trace/stack_trace.dart';

/// Rethrows [error] with a stacktrace that is the comination of [stackTrace]
/// and [StackTrace.current].
Never throwErrorWithCombinedStackTrace(Object error, StackTrace stackTrace) {
  final chain = Chain([
    Trace.current(),
    ...Chain.forTrace(stackTrace).traces,
  ]).foldFrames((frame) => frame.package == 'riverpod');

  Error.throwWithStackTrace(error, chain);
}
