import 'vm_service.dart';

/// Evaluates [code] as typed in the terminal of a provider.
///
/// The code runs in the library of the provider's state, and can use
/// `$state`, `$notifier` and `$previous`, the result of the previous
/// evaluation.
///
/// The result stays in the application's memory until
/// [RootCachedObject.delete] is called or the session ends.
Future<Byte<RootCachedObject>> evalInTerminal(
  String code,
  EvalFactory evalFactory, {
  required CachedObject state,
  required CachedObject? notifier,
  required CachedObject? previous,
  required Disposable isAlive,
}) async {
  // One at a time: nothing would handle the failure of a read that started
  // before another one threw.
  final stateRef = await state.readRef(evalFactory, isAlive);
  final notifierRef = await notifier?.readRef(evalFactory, isAlive);
  final previousRef = await previous?.readRef(evalFactory, isAlive);

  switch ((stateRef, notifierRef, previousRef)) {
    case (ByteError(:final error), _, _):
    case (_, ByteError(:final error), _):
    case (_, _, ByteError(:final error)):
      return ByteError(error);
    case (
      ByteVariable(instance: final state),
      final ByteVariable<VmInstanceRef>? notifier,
      final ByteVariable<VmInstanceRef>? previous,
    ):
      final eval = evalFactory.forRef(state) ?? evalFactory.dartCore;

      return RootCachedObject.create(
        code,
        eval,
        isAlive: isAlive,
        scope: {
          r'$state': ?state.id,
          r'$notifier': ?notifier?.instance.id,
          r'$previous': ?previous?.instance.id,
        },
      );
  }
}
