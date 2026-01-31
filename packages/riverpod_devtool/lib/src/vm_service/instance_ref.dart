part of '../vm_service.dart';

// TODO
// sealed class VariableRef {
//   VariableRef(this.object);

//   factory VariableRef.fromInstanceRef(
//     CachedObject object,
//     InstanceRef ref,
//     EvalFactory eval,
//   ) {
//     final kind = _SimplifiedInstanceKind.fromInstanceKind(
//       _SealedInstanceKind.fromString(ref.kind!),
//     );

//     switch (kind) {
//       // case .string:
//       // return _StringVariableRefImpl._(ref, eval);
//       // case .int:
//       //   return IntVariable._(ref);
//       // case .double:
//       //   return DoubleVariable._(ref);
//       // case .bool:
//       //   return _BoolVariableRefImpl(ref, eval);
//       case .nill:
//       // TODO
//       case _:
//         // return NullVariableRef._(object);
//       // case .type:
//       //   return _TypeVariableRefImpl(ref, eval);
//       // case .list:
//       //   return _ListVariableRefImpl(ref, eval);
//       // case .record:
//       //   return _RecordVariableRefImpl(ref, eval);
//       // case .set:
//       //   return _SetVariableRefImpl(ref, eval);

//       // case .map:
//       // // TODO

//       // case .object:
//       //   return _UnknownObjectVariableRefImpl(ref, eval);
//     }
//   }

//   final CachedObject object;

//   FutureOr<Byte<ResolvedVariable>> resolve(Disposable isAlive);
// }

// base class _EvaluatedVariableRef {
//   _EvaluatedVariableRef(this.ref, this.eval);
//   final InstanceRef ref;
//   final EvalFactory eval;

//   String get _evalUri => ref.classRef!.library!.uri!;

//   Future<Byte<T>> _eval<T extends ResolvedVariable>(
//     Disposable isAlive,
//     Future<T> Function(Eval) run,
//   ) async {
//     final evalInstance = eval.forLibrary(_evalUri);

//     try {
//       return ByteVariable(await run(evalInstance));
//     } on SentinelException catch (e) {
//       return ByteSentinel(e.sentinel);
//     }
//   }

//   Future<Byte<T>> _resolveInstance<T extends ResolvedVariable>(
//     Disposable isAlive,
//   ) {
//     return _eval(isAlive, (evalInstance) async {
//       final instance = await evalInstance.instance(ref, isAlive: isAlive);
//       final variable = ResolvedVariable.fromInstance(instance, eval);

//       if (variable is! T) {
//         throw StateError(
//           'Expected variable of type $T but got ${variable.runtimeType}',
//         );
//       }

//       return variable;
//     });
//   }
// }

// final class NullVariableRef extends VariableRef {
//   NullVariableRef._(super.object);

//   @override
//   Future<Byte<NullVariable>> resolve(Disposable isAlive) async {
//     return ByteVariable(NullVariable._(object));
//   }
// }

// abstract class BoolVariableRef implements VariableRef {
//   bool get value;

//   @override
//   Future<Byte<BoolVariable>> resolve(Disposable isAlive);
// }

// final class _BoolVariableRefImpl extends VariableRef {
//   _BoolVariableRefImpl(super.object);

//   @override
//   Byte<BoolVariable> resolve(Disposable isAlive) {
//     return ByteVariable(
//       BoolVariable._(object, value: ref.valueAsString == 'true'),
//     );
//   }
// }

// abstract class StringVariableRef implements VariableRef {
//   String get truncatedValue;
//   bool get isTruncated;
//   String? get value;

//   @override
//   Future<Byte<StringVariable>> resolve(Disposable isAlive);
// }

// final class _StringVariableRefImpl extends _EvaluatedVariableRef
//     implements VariableRef {
//   _StringVariableRefImpl._(super.ref, super.eval)
//     : truncatedValue = ref.valueAsString!,
//       isTruncated = ref.valueAsString!.length < ref.length!;

//   final String truncatedValue;
//   final bool isTruncated;
//   String? get value => isTruncated ? null : truncatedValue;

//   @override
//   Future<Byte<StringVariable>> resolve(Disposable isAlive) async {
//     if (!isTruncated) {
//       return ByteVariable(StringVariable._2(ref, value: truncatedValue));
//     }

//     return _resolveInstance(isAlive);
//   }
// }

// abstract class IntVariableRef implements VariableRef {
//   int get value;

//   @override
//   Future<Byte<IntVariable>> resolve(Disposable isAlive);
// }

// abstract class DoubleVariableRef implements VariableRef {
//   double get value;

//   @override
//   Future<Byte<DoubleVariable>> resolve(Disposable isAlive);
// }

// abstract class TypeVariableRef implements VariableRef {
//   @override
//   Future<Byte<TypeVariable>> resolve(Disposable isAlive);
// }

// final class _TypeVariableRefImpl extends _EvaluatedVariableRef
//     implements VariableRef {
//   _TypeVariableRefImpl(super.ref, super.eval);

//   @override
//   Future<Byte<TypeVariable>> resolve(Disposable isAlive) {
//     return _resolveInstance(isAlive);
//   }
// }

// abstract class ListVariableRef implements VariableRef {
//   @override
//   Future<Byte<ListVariable>> resolve(Disposable isAlive);
// }

// final class _ListVariableRefImpl extends _EvaluatedVariableRef
//     implements VariableRef {
//   _ListVariableRefImpl(super.ref, super.eval);

//   @override
//   Future<Byte<ListVariable>> resolve(Disposable isAlive) {
//     return _resolveInstance(isAlive);
//   }
// }

// abstract class RecordVariableRef implements VariableRef {
//   @override
//   Future<Byte<RecordVariable>> resolve(Disposable isAlive);
// }

// final class _RecordVariableRefImpl extends _EvaluatedVariableRef
//     implements VariableRef {
//   _RecordVariableRefImpl(super.ref, super.eval);

//   @override
//   Future<Byte<RecordVariable>> resolve(Disposable isAlive) {
//     return _resolveInstance(isAlive);
//   }
// }

// abstract class SetVariableRef implements VariableRef {
//   @override
//   Future<Byte<SetVariable>> resolve(Disposable isAlive);
// }

// final class _SetVariableRefImpl extends _EvaluatedVariableRef
//     implements VariableRef {
//   _SetVariableRefImpl(super.ref, super.eval);

//   @override
//   Future<Byte<SetVariable>> resolve(Disposable isAlive) {
//     return _resolveInstance(isAlive);
//   }
// }

// abstract class UnknownObjectVariableRef implements VariableRef {
//   @override
//   Future<Byte<UnknownObjectVariable>> resolve(Disposable isAlive);
// }

// final class _UnknownObjectVariableRefImpl extends _EvaluatedVariableRef
//     implements VariableRef {
//   _UnknownObjectVariableRefImpl(super.ref, super.eval);

//   @override
//   Future<Byte<UnknownObjectVariable>> resolve(Disposable isAlive) {
//     return _resolveInstance(isAlive);
//   }
// }

// abstract class FieldVariableRef implements VariableRef {
//   @override
//   Future<Byte<FieldVariable>> resolve(Disposable isAlive);
// }

// final class _FieldVariableRefImpl extends _EvaluatedVariableRef
//     implements FieldVariableRef {
//   _FieldVariableRefImpl(
//     this._field,
//     EvalFactory eval, {
//     required InstanceRef object,
//   }) : super(object, eval);

//   final BoundField _field;

//   @override
//   Future<Byte<FieldVariable>> resolve(Disposable isAlive) {
//     return _eval(isAlive, (eval) async {
//       final value = Byte.instanceRef(_field.value);

//       return FieldVariable(
//         key: FieldKey.from(_field.name),
//         value: switch (value) {
//           ByteVariable<InstanceRef>() => await eval.instance2(
//             value.instance,
//             isAlive: isAlive,
//           ),
//           ByteSentinel<InstanceRef>() => ByteSentinel(value.sentinel),
//         },
//       );
//     });
//   }
// }
