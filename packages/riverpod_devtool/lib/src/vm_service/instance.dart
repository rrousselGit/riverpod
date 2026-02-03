part of '../vm_service.dart';

sealed class ResolvedVariable {
  const ResolvedVariable(this.object);

  factory ResolvedVariable.fromInstance(
    CachedObject object,
    Instance instance,
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
        return UnknownObjectVariable._(object, instance);
    }
  }

  final CachedObject object;

  List<DerivedCachedObject> get children => const [];
}

final class NullVariable extends ResolvedVariable {
  NullVariable._(super.object);
}

final class BoolVariable extends ResolvedVariable {
  BoolVariable._fromInstance(super.object, Instance instance)
    : value = instance.valueAsString == 'true';

  final bool value;
}

final class IntVariable extends ResolvedVariable {
  IntVariable._fromInstance(super.object, Instance instance)
    : value = int.parse(instance.valueAsString!);

  final int value;
}

final class DoubleVariable extends ResolvedVariable {
  DoubleVariable._fromInstance(super.object, Instance instance)
    : value = double.parse(instance.valueAsString!);

  final double value;
}

final class StringVariable extends ResolvedVariable {
  StringVariable._fromInstance(super.object, Instance instance)
    : value = instance.valueAsString!;

  final String value;
}

final class TypeVariable extends ResolvedVariable {
  TypeVariable._fromInstance(super.object, Instance instance)
    : name = instance.name!;

  final String name;
}

final class RecordVariable extends ResolvedVariable {
  RecordVariable._fromInstance(super.object, Instance instance)
    : children = [
        for (final field in instance.fields ?? <BoundField>[])
          DerivedCachedObject.objectField(object, field),
      ];

  @override
  final List<DerivedCachedObject> children;
}

final class ListVariable extends ResolvedVariable {
  ListVariable._fromInstance(super.object, Instance instance)
    : children = [
        for (final (index, _) in (instance.elements ?? <dynamic>[]).indexed)
          DerivedCachedObject.collectionElement(object, index),
      ];

  @override
  final List<DerivedCachedObject> children;
}

final class SetVariable extends ResolvedVariable {
  SetVariable._fromInstance(super.object, Instance instance)
    : children = [
        for (final (index, _) in (instance.elements ?? <dynamic>[]).indexed)
          DerivedCachedObject.collectionElement(object, index),
      ];

  @override
  final List<DerivedCachedObject> children;
}

final class MapVariable extends ResolvedVariable {
  MapVariable._fromInstance(super.object, Instance instance)
    : children = [
        for (final (index, _) in (instance.associations ?? <dynamic>[]).indexed) ...[
          DerivedCachedObject.mapAssociationKey(object, index),
          DerivedCachedObject.mapAssociationValue(object, index),
        ],
      ];

  @override
  final List<DerivedCachedObject> children;
}

final class UnknownObjectVariable extends ResolvedVariable {
  UnknownObjectVariable._(super.object, Instance ref)
    : type = ref.classRef!.name!,
      identityHashCode = ref.identityHashCode,
      children = [
        for (final field in ref.fields ?? <BoundField>[])
          DerivedCachedObject.objectField(object, field),
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
}
