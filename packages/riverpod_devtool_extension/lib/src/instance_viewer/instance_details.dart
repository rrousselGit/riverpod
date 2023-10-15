// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:devtools_app_shared/service.dart';
import 'package:flutter/foundation.dart';
import 'package:vm_service/vm_service.dart';

import 'fake_freezed_annotation.dart';
import 'result.dart';

// This part is generated using `package:freezed`, but without the devtool depending
// on the package.
// To update the generated files, temporarily add freezed/freezed_annotation/build_runner
// as dependencies; replace the `fake_freezed_annotation.dart` import with the
// real annotation package, then execute `pub run build_runner build`.
part 'instance_details.freezed.dart';

typedef Setter = Future<void> Function(String newValue);

@freezed
class PathToProperty with _$PathToProperty {
  const factory PathToProperty.listIndex(int index) = ListIndexPath;

  // TODO test that mutating a Map does not collapse previously expanded keys
  const factory PathToProperty.mapKey({
    required String? ref,
  }) = MapKeyPath;

  /// Must not depend on [InstanceRef] and its ID, as they may change across
  /// re-evaluations of the object.
  /// Depending on those would lead to the UI collapsing previously expanded objects
  /// because the new path to a property would be different.
  ///
  /// We can't just rely on the property name either, because in some cases
  /// an object can have multiple properties with the same name (private properties
  /// defined in different libraries)
  const factory PathToProperty.objectProperty({
    required String name,

    /// Path to the class/mixin that defined this property
    required String ownerUri,

    /// Name of the class/mixin that defined this property
    required String ownerName,
  }) = PropertyPath;

  factory PathToProperty.fromObjectField(ObjectField field) {
    return PathToProperty.objectProperty(
      name: field.name,
      ownerUri: field.ownerUri,
      ownerName: field.ownerName,
    );
  }
}

@freezed
class ObjectField with _$ObjectField {
  factory ObjectField({
    required String name,
    required bool isFinal,
    required String ownerName,
    required String ownerUri,
    required Result<InstanceRef> ref,

    /// An [EvalOnDartLibrary] that can access this field from the owner object
    required EvalOnDartLibrary eval,

    /// Whether this field was defined by the inspected app or by one of its dependencies
    ///
    /// This is used by the UI to hide variables that are not useful for the user.
    required bool isDefinedByDependency,
  }) = _ObjectField;

  ObjectField._();

  bool get isPrivate => name.startsWith('_');
}

@freezed
class InstanceDetails with _$InstanceDetails {
  InstanceDetails._();

  factory InstanceDetails.nill({
    required Setter? setter,
  }) = NullInstance;

  factory InstanceDetails.boolean(
    String displayString, {
    required String instanceRefId,
    required Setter? setter,
  }) = BoolInstance;

  factory InstanceDetails.number(
    String displayString, {
    required String instanceRefId,
    required Setter? setter,
  }) = NumInstance;

  factory InstanceDetails.string(
    String displayString, {
    required String instanceRefId,
    required Setter? setter,
  }) = StringInstance;

  factory InstanceDetails.map(
    List<InstanceDetails> keys, {
    required int hash,
    required String instanceRefId,
    required Setter? setter,
  }) = MapInstance;

  factory InstanceDetails.list({
    required int length,
    required int hash,
    required String instanceRefId,
    required Setter? setter,
  }) = ListInstance;

  factory InstanceDetails.object(
    List<ObjectField> fields, {
    required String type,
    required int hash,
    required String instanceRefId,
    required Setter? setter,

    /// An [EvalOnDartLibrary] associated with the library of this object
    ///
    /// This allows to edit private properties.
    required EvalOnDartLibrary evalForInstance,
  }) = ObjectInstance;

  factory InstanceDetails.enumeration({
    required String type,
    required String value,
    required Setter? setter,
    required String instanceRefId,
  }) = EnumInstance;

  bool get isExpandable {
    bool falsy(Object _) => false;

    return map(
      nill: falsy,
      boolean: falsy,
      number: falsy,
      string: falsy,
      enumeration: falsy,
      map: (instance) => instance.keys.isNotEmpty,
      list: (instance) => instance.length > 0,
      object: (instance) => instance.fields.isNotEmpty,
    );
  }

  // Since `nil` doesn't have those properties, we are manually exposing them
  String? get instanceRefId {
    return map(
      nill: (_) => null,
      boolean: (a) => a.instanceRefId,
      number: (a) => a.instanceRefId,
      string: (a) => a.instanceRefId,
      map: (a) => a.instanceRefId,
      list: (a) => a.instanceRefId,
      object: (a) => a.instanceRefId,
      enumeration: (a) => a.instanceRefId,
    );
  }
}

/// The path to visit child elements of an [Instance] or providers from `provider`/`riverpod`.
@freezed
class InstancePath with _$InstancePath {
  const InstancePath._();

  const factory InstancePath.fromInstanceId(
    String instanceId, {
    @Default([]) List<PathToProperty> pathToProperty,
  }) = _InstancePathFromInstanceId;

  const factory InstancePath.fromProviderId(
    String providerId, {
    @Default([]) List<PathToProperty> pathToProperty,
  }) = _InstancePathFromProviderId;

  InstancePath get root => copyWith(pathToProperty: []);

  InstancePath? get parent {
    if (pathToProperty.isEmpty) return null;

    return copyWith(
      pathToProperty: [
        for (var i = 0; i + 1 < pathToProperty.length; i++) pathToProperty[i],
      ],
    );
  }

  InstancePath pathForChild(PathToProperty property) {
    return copyWith(
      pathToProperty: [...pathToProperty, property],
    );
  }
}
