import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/internals.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stack_trace/stack_trace.dart';

void main() {
  testWidgets('Flutter does not ask to demangle stacktraces', (tester) async {
    final previousErrorHandler = FlutterError.onError;
    final stacks = <StackTrace?>[];

    FlutterError.onError = (details) => stacks.add(details.stack);
    await tester.pumpWidget(
      MaterialApp(
        home: Consumer(
          // ignore: invalid_use_of_internal_member
          builder: (context, ref, child) => throwErrorWithCombinedStackTrace(
            StateError('Hello world'),
            StackTrace.current,
          ),
        ),
      ),
    );
    FlutterError.onError = previousErrorHandler;

    expect(
      stacks,
      everyElement(isNot(anyOf(isA<Chain>(), isA<Trace>()))),
    );
  });
}
