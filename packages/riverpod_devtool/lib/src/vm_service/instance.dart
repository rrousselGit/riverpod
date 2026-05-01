part of '../vm_service.dart';

sealed class ResolvedVariable {
  const ResolvedVariable(this.object);

  static ResolvedVariable? fromInstance(
    CachedObject object,
    VmInstance instance,
  ) {
    final kind = _SimplifiedInstanceKind.fromInstanceKind(
      _SealedInstanceKind.fromString(instance.kind!),
    );

    switch (kind) {
      case .string:
        return StringVariable._fromInstance(object, instance);
      case .int:
        return IntVariable._fromInstance(object, instance);
      case .double:
        return DoubleVariable._fromInstance(object, instance);
      case .bool:
        return BoolVariable._fromInstance(object, instance);
      case .nill:
        return NullVariable._(object);
      case .type:
        return TypeVariable._fromInstance(object, instance);
      case .record:
        return RecordVariable._fromInstance(object, instance);
      case .list:
        return ListVariable._fromInstance(object, instance);
      case .set:
        return SetVariable._fromInstance(object, instance);
      case .map:
        return MapVariable._fromInstance(object, instance);
      case .object:
        return null;
    }
  }

  final CachedObject object;

  List<CachedObject> get children => const [];
}

final class NullVariable extends ResolvedVariable {
  NullVariable._(super.object);
}

final class BoolVariable extends ResolvedVariable {
  BoolVariable._fromInstance(super.object, VmInstance instance)
    : value = instance.valueAsString == 'true';

  final bool value;
}

final class IntVariable extends ResolvedVariable {
  IntVariable._fromInstance(super.object, VmInstance instance)
    : value = int.parse(instance.valueAsString!);

  final int value;
}

final class DoubleVariable extends ResolvedVariable {
  DoubleVariable._fromInstance(super.object, VmInstance instance)
    : value = double.parse(instance.valueAsString!);

  final double value;
}

final class StringVariable extends ResolvedVariable {
  StringVariable._fromInstance(super.object, VmInstance instance)
    : value = instance.valueAsString!;

  final String value;
}

final class TypeVariable extends ResolvedVariable {
  TypeVariable._fromInstance(super.object, VmInstance instance)
    : name = instance.name!;

  final String name;
}

final class RecordVariable extends ResolvedVariable {
  RecordVariable._fromInstance(super.object, VmInstance instance)
    : children = [
        for (final field in instance.fields ?? <BoundField>[])
          DerivedCachedObject.objectField(object, FieldKey.from(field.name)),
      ];

  @override
  final List<DerivedCachedObject> children;
}

final class ListVariable extends ResolvedVariable {
  ListVariable._fromInstance(super.object, VmInstance instance)
    : children = [
        for (final (index, _) in (instance.elements ?? <dynamic>[]).indexed)
          DerivedCachedObject.collectionElement(object, index),
      ];

  @override
  final List<DerivedCachedObject> children;
}

final class SetVariable extends ResolvedVariable {
  SetVariable._fromInstance(super.object, VmInstance instance)
    : children = [
        for (final (index, _) in (instance.elements ?? <dynamic>[]).indexed)
          DerivedCachedObject.collectionElement(object, index),
      ];

  @override
  final List<DerivedCachedObject> children;
}

final class MapVariable extends ResolvedVariable {
  MapVariable._fromInstance(super.object, VmInstance instance)
    : children = [
        for (final (index, _)
            in (instance.associations ?? <dynamic>[]).indexed) ...[
          DerivedCachedObject.mapAssociationKey(object, index),
          DerivedCachedObject.mapAssociationValue(object, index),
        ],
      ];

  @override
  final List<DerivedCachedObject> children;
}

final class UnknownObjectVariable extends ResolvedVariable {
  UnknownObjectVariable(
    super.object,
    VmInstance ref, {
    required List<({String name, Uri uri})> getters,
  }) : type = ref.classRef!.name!,
       identityHashCode = ref.identityHashCode,
       children = [
         for (final getter in getters)
           // Only include getters if they aren't already included as fields, to avoid duplicates.
           // ObjectField is more efficient
           if (ref.fields?.map((field) => field.name).contains(getter.name) !=
               true)
             DerivedCachedObject.getter(
               object,
               name: getter.name,
               uri: getter.uri,
             ),
         for (final field in ref.fields ?? <BoundField>[])
           DerivedCachedObject.objectField(object, FieldKey.from(field.name)),
       ];

  final String type;
  final int? identityHashCode;
  @override
  final List<DerivedCachedObject> children;
}

@immutable
sealed class FieldKey {
  factory FieldKey.from(Object? key) {
    return switch (key) {
      final String value => NamedFieldKey(value),
      final int value => PositionalFieldKey(value),
      _ => throw StateError('Field name is neither String nor int: $key'),
    };
  }

  @override
  @mustBeOverridden
  bool operator ==(Object other);

  @override
  int get hashCode;
}

// ignore: avoid_implementing_value_types, false positive
final class PositionalFieldKey implements FieldKey {
  PositionalFieldKey(this.index);
  final int index;

  @override
  bool operator ==(Object other) =>
      other is PositionalFieldKey && other.index == index;

  @override
  int get hashCode => index.hashCode;
}

// ignore: avoid_implementing_value_types, false positive
final class NamedFieldKey implements FieldKey {
  NamedFieldKey(this.name);
  final String name;

  @override
  bool operator ==(Object other) =>
      other is NamedFieldKey && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => '`$name`';
}

extension type ClassId(String value) {}

extension ClassIdOnRef on ClassRef {
  ClassId get classId => ClassId(id!);
}

/// Resolve a `Class` object for a given `ClassRef`.
///
/// Returns `null` if the class cannot be resolved or on error.
final classFromIdProvider = FutureProvider.autoDispose
    .family<Byte<Class>, ClassId>((ref, classId) async {
      ref.watch(hotRestartEventProvider);

      final evalFactory = await ref.watch(evalProvider.future);
      final isAlive = ref.disposable();

      return evalFactory.dartCore.getClass(
        ClassRef(id: classId.value),
        isAlive: isAlive,
      );
    });

/// A provider that lists the names of all getters declared on an object's class.
///
/// Returns an empty list if the object's class cannot be resolved or on error.
final FutureProviderFamily<List<({String name, Uri uri})>, ClassId>
gettersForClassProvider = FutureProvider.autoDispose
    .family<List<({String name, Uri uri})>, ClassId>((ref, classId) async {
      // Skip Object properties manually, as they may be overridden and thus
      // listed on classes other than Object.
      const excludedNames = {'hashCode', 'runtimeType'};

      final klass = await ref.watch(classFromIdProvider(classId).future);
      switch (klass) {
        case ByteError<Class>():
          return const [];
        case ByteVariable<Class>(instance: final klass):
          final functions = klass.functions ?? <FuncRef>[];

          // Skip hashCode & co from Object.
          if (klass.isDartCodeObject) return const [];

          return [
            for (final function in functions)
              if ((function.isGetter ?? true) &&
                  !excludedNames.contains(function.name))
                (
                  name: function.name!,
                  uri: switch (function.owner) {
                    final ClassRef ref => Uri.parse(ref.library!.uri!),
                    LibraryRef() || FuncRef() || _ => throw UnsupportedError(
                      'Unsupported function owner: ${function.owner.runtimeType}',
                    ),
                  },
                ),
            if (klass.superClass case final superClass?)
              ...await ref.watch(
                gettersForClassProvider(superClass.classId).future,
              ),
          ];
      }
    });

extension IsDartCoreObject on Class {
  bool get isDartCodeObject => library?.uri == 'dart:core' && name == 'Object';
}

final gettersForObjectProvider = FutureProvider.autoDispose
    .family<List<({String name, Uri uri})>, CachedObject>((ref, object) async {
      final eval = await ref.watch(evalProvider.future);
      final isAlive = ref.disposable();

      final byte = await object.readRef(eval, isAlive);

      switch (byte) {
        case ByteError():
        case ByteVariable(instance: VmInstanceRef(classRef: null)):
          return const [];
        case ByteVariable(instance: VmInstanceRef(classRef: final classRef?)):
          return await ref.watch(
            gettersForClassProvider(classRef.classId).future,
          );
      }
    });
