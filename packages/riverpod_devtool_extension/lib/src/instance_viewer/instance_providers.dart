// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:devtools_app_shared/service.dart';
import 'package:devtools_app_shared/utils.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vm_service/vm_service.dart' hide SentinelException;

import 'eval.dart';
import 'instance_details.dart';
import 'result.dart';

Future<InstanceRef> _resolveInstanceRefForPath(
  InstancePath path, {
  required AutoDisposeRef ref,
  required Disposable isAlive,
  required InstanceDetails? parent,
}) async {
  if (parent == null) {
    // root of the provider tree

    return path.map(
      fromProviderId: (path) async {
        final eval = await ref.watch(providerEvalProvider.future);
        // cause the instances to be re-evaluated when the devtool is notified
        // that a provider changed
        ref.watch(_providerChanged(path.providerId));

        return eval.safeEval(
          'ProviderBinding.debugInstance.providerDetails["${path.providerId}"]?.value',
          isAlive: isAlive,
        );
      },
      fromInstanceId: (path) async {
        final eval = await ref.watch(evalProvider.future);
        return eval.safeEval(
          'value',
          isAlive: isAlive,
          scope: {'value': path.instanceId},
        );
      },
    );
  }

  final eval = await ref.watch(evalProvider.future);

  return parent.maybeMap(
    // TODO: support sets
    // TODO: iterables should use iterators / next() for iterable to navigate, to avoid recomputing the content

    map: (parent) {
      final keyPath = path.pathToProperty.last as MapKeyPath;
      final key = keyPath.ref == null ? 'null' : 'key';
      final keyPathRef = keyPath.ref;

      return eval.safeEval(
        'parent[$key]',
        isAlive: isAlive,
        scope: {
          'parent': parent.instanceRefId,
          if (keyPathRef != null) 'key': keyPathRef,
        },
      );
    },
    list: (parent) {
      final indexPath = path.pathToProperty.last as ListIndexPath;

      return eval.safeEval(
        'parent[${indexPath.index}]',
        isAlive: isAlive,
        scope: {'parent': parent.instanceRefId},
      );
    },
    object: (parent) {
      final propertyPath = path.pathToProperty.last as PropertyPath;

      // compare by both name and ref ID because an object may have multiple
      // fields with the same name
      final field = parent.fields.firstWhere(
        (element) =>
            element.name == propertyPath.name &&
            element.ownerName == propertyPath.ownerName &&
            element.ownerUri == propertyPath.ownerUri,
      );

      final ref = field.ref.dataOrThrow;

      // we cannot do `eval('parent.propertyName')` because it is possible for
      // objects to have multiple properties with the same name
      return eval.safeGetInstance(ref, isAlive);
    },
    orElse: () => throw Exception('Unexpected instance type.'),
  );
}

/// Update a variable using the `=` operator.
///
/// In rare cases, it is possible for this function to mutate the wrong property.
/// This can happen when an object contains multiple fields with the same name
/// (such as private properties or overridden properties), where the conflicting
/// fields are both defined in the same library.
Future<void> _mutate(
  String newValueExpression, {
  required InstancePath path,
  required AutoDisposeRef ref,
  required Disposable isAlive,
  required InstanceDetails parent,
}) async {
  await parent.maybeMap(
    list: (parent) async {
      final eval = await ref.watch(evalProvider.future);
      final indexPath = path.pathToProperty.last as ListIndexPath;

      return eval.safeEval(
        'parent[${indexPath.index}] = $newValueExpression',
        isAlive: isAlive,
        scope: {
          'parent': parent.instanceRefId,
        },
      );
    },
    map: (parent) async {
      final eval = await ref.watch(evalProvider.future);
      final keyPath = path.pathToProperty.last as MapKeyPath;
      final keyRefVar = keyPath.ref == null ? 'null' : 'key';
      final keyPathRef = keyPath.ref;

      return eval.safeEval(
        'parent[$keyRefVar] = $newValueExpression',
        isAlive: isAlive,
        scope: {
          'parent': parent.instanceRefId,
          if (keyPathRef != null) 'key': keyPathRef,
        },
      );
    },
    // TODO test can mutate properties of a mixin placed in a different library that the class that uses it
    object: (parent) {
      final propertyPath = path.pathToProperty.last as PropertyPath;

      final field = parent.fields.firstWhere(
        (f) =>
            f.name == propertyPath.name &&
            f.ownerName == propertyPath.ownerName,
      );

      return field.eval.safeEval(
        '(parent as ${propertyPath.ownerName}).${propertyPath.name} = $newValueExpression',
        isAlive: isAlive,
        scope: {
          'parent': parent.instanceRefId,
        },
      );
    },
    orElse: () => throw StateError('Can only mutate lists/maps/objects'),
  );

  // TODO(rrousselGit): call notifyListeners/setState/notifyClients based on the modified object

  // Since the same object can be used in multiple locations at once, we need
  // to refresh the entire tree instead of just the node that was modified.
  ref.refresh(instanceProvider(path.root));

  // Forces the UI to rebuild after the state change
  await serviceManager.performHotReload();
}

Future<InstanceDetails?> _resolveParent(
  AutoDisposeRef ref,
  InstancePath path,
) async {
  return path.pathToProperty.isNotEmpty
      ? await ref.watch(instanceProvider(path.parent!).future)
      : null;
}

Future<EnumInstance?> _tryParseEnum(
  Instance instance, {
  required EvalOnDartLibrary eval,
  required Disposable isAlive,
  required String instanceRefId,
  required Setter? setter,
}) async {
  if (instance.kind != InstanceKind.kPlainInstance ||
      instance.fields?.length != 2) return null;

  InstanceRef? findPropertyWithName(String name) {
    return instance.fields
        ?.firstWhereOrNull((element) => element.decl?.name == name)
        ?.value;
  }

  final nameRef = findPropertyWithName('_name');
  final indexRef = findPropertyWithName('index');
  if (nameRef == null || indexRef == null) return null;

  final nameInstanceFuture = eval.safeGetInstance(nameRef, isAlive);
  final indexInstanceFuture = eval.safeGetInstance(indexRef, isAlive);

  final index = await indexInstanceFuture;
  if (index.kind != InstanceKind.kInt) return null;

  final name = await nameInstanceFuture;
  if (name.kind != InstanceKind.kString) return null;

  // Some Dart versions have for name "EnumType.valueName", others only have "valueName".
  // So we have to strip the type manually
  final nameSplit = name.valueAsString!.split('.');

  return EnumInstance(
    type: instance.classRef!.name!,
    value: nameSplit.last,
    instanceRefId: instanceRefId,
    setter: setter,
  );
}

Setter? _parseSetter({
  required InstancePath path,
  required AutoDisposeRef ref,
  required Disposable isAlive,
  required InstanceDetails? parent,
}) {
  if (parent == null) return null;

  Future<void> mutate(String expression) {
    return _mutate(
      expression,
      path: path,
      ref: ref,
      isAlive: isAlive,
      parent: parent,
    );
  }

  return parent.maybeMap(
    // TODO const collections should have no setter
    map: (parent) => mutate,
    list: (parent) => mutate,
    object: (parent) {
      final keyPath = path.pathToProperty.last as PropertyPath;

      // Mutate properties by name as we can't mutate them from a reference.
      // This may edit the wrong property when an object has two properties with
      // with the same name.
      // TODO use ownerUri
      final field = parent.fields.firstWhere(
        (field) =>
            field.name == keyPath.name && field.ownerName == keyPath.ownerName,
      );

      if (field.isFinal) return null;
      return mutate;
    },
    orElse: () => throw Exception('Unexpected instance type.'),
  );
}

/// Fetches informations related to an instance/provider at a given path
///
/// The UI should not be used directly. Instead, use [instanceProvider].
final AutoDisposeFutureProviderFamily<InstanceDetails, InstancePath>
    instanceProvider =
    AutoDisposeFutureProviderFamily<InstanceDetails, InstancePath>(
  (ref, path) async {
    ref.watch(hotRestartEventProvider);

    final eval = await ref.watch(evalProvider.future);

    final isAlive = Disposable();
    ref.onDispose(isAlive.dispose);

    final parent = await _resolveParent(ref, path);

    final instanceRef = await _resolveInstanceRefForPath(
      path,
      ref: ref,
      parent: parent,
      isAlive: isAlive,
    );

    final setter = _parseSetter(
      path: path,
      isAlive: isAlive,
      ref: ref,
      parent: parent,
    );

    final instance = await eval.safeGetInstance(instanceRef, isAlive);

    switch (instance.kind) {
      case InstanceKind.kNull:
        return InstanceDetails.nill(setter: setter);
      case InstanceKind.kBool:
        return InstanceDetails.boolean(
          instance.valueAsString!,
          instanceRefId: instanceRef.id!,
          setter: setter,
        );
      case InstanceKind.kInt:
      case InstanceKind.kDouble:
        return InstanceDetails.number(
          instance.valueAsString!,
          instanceRefId: instanceRef.id!,
          setter: setter,
        );
      case InstanceKind.kString:
        return InstanceDetails.string(
          instance.valueAsString!,
          instanceRefId: instanceRef.id!,
          setter: setter,
        );

      case InstanceKind.kMap:

        // voluntarily throw if a key failed to load
        final keysRef = instance.associations!.map((e) => e.key as InstanceRef);

        final keysFuture = Future.wait<InstanceDetails>([
          for (final keyRef in keysRef)
            ref.watch(
              instanceProvider(InstancePath.fromInstanceId(keyRef.id!)).future,
            ),
        ]);

        return InstanceDetails.map(
          await keysFuture,
          hash: await eval.getHashCode(instance, isAlive: isAlive),
          instanceRefId: instanceRef.id!,
          setter: setter,
        );

      // TODO(rrousselGit): support sets
      // TODO(rrousselGit): support custom lists
      // TODO(rrousselGit): support Type
      case InstanceKind.kList:
        return InstanceDetails.list(
          length: instance.length!,
          hash: await eval.getHashCode(instance, isAlive: isAlive),
          instanceRefId: instanceRef.id!,
          setter: setter,
        );

      case InstanceKind.kPlainInstance:
      default:
        final enumDetails = await _tryParseEnum(
          instance,
          eval: eval,
          isAlive: isAlive,
          instanceRefId: instanceRef.id!,
          setter: setter,
        );

        if (enumDetails != null) return enumDetails;

        final classInstance =
            await eval.safeGetClass(instance.classRef!, isAlive);
        final evalForInstance =
            // TODO(rrousselGit) when can `library` be null?
            ref.watch(libraryEvalProvider(classInstance.library!.uri!).future);

        final appName = tryParsePackageName(eval.isolate!.rootLib!.uri!);

        final fields = await _parseFields(
          ref,
          eval,
          instance,
          isAlive: isAlive,
          appName: appName,
        );

        return InstanceDetails.object(
          fields.sorted((a, b) => sortFieldsByName(a.name, b.name)),
          hash: await eval.getHashCode(instance, isAlive: isAlive),
          type: classInstance.name!,
          instanceRefId: instanceRef.id!,
          evalForInstance: await evalForInstance,
          setter: setter,
        );
    }
  },
);

final _packageNameExp = RegExp(
  r'package:(.+?)/',
);

String? tryParsePackageName(String uri) {
  return _packageNameExp.firstMatch(uri)?.group(1);
}

Future<List<ObjectField>> _parseFields(
  AutoDisposeRef ref,
  EvalOnDartLibrary eval,
  Instance instance, {
  required Disposable isAlive,
  required String? appName,
}) {
  final fields = instance.fields!.map((field) async {
    final fieldDeclaration = field.decl!;
    final owner =
        await eval.safeGetClass(fieldDeclaration.owner! as ClassRef, isAlive);

    final ownerUri = fieldDeclaration.location!.script!.uri!;
    final ownerName = owner.mixin?.name ?? owner.name!;
    final ownerPackageName = tryParsePackageName(ownerUri);

    return ObjectField(
      name: fieldDeclaration.name!,
      isFinal: fieldDeclaration.isFinal!,
      ref: parseSentinel<InstanceRef>(field.value),
      ownerName: ownerName,
      ownerUri: ownerUri,
      eval: await ref.watch(libraryEvalProvider(ownerUri).future),
      isDefinedByDependency: ownerPackageName != appName,
    );
  }).toList();

  return Future.wait(fields);
}

final _providerChanged =
    AutoDisposeStreamProviderFamily<void, String>((ref, id) async* {
  final service = await ref.watch(serviceProvider.future);

  yield* service.onExtensionEvent.where((event) {
    return event.extensionKind == 'provider:provider_changed' &&
        event.extensionData?.data['id'] == id;
  });
});
