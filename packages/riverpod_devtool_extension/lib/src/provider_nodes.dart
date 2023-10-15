// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vm_service/vm_service.dart';

import 'instance_viewer/eval.dart';

@immutable
class ProviderNode {
  const ProviderNode({
    required this.id,
    required this.type,
  });

  final String id;
  final String type;
}

final _providerListChanged = AutoDisposeStreamProvider<void>((ref) async* {
  final service = await ref.watch(serviceProvider.future);

  yield* service.onExtensionEvent.where((event) {
    return event.extensionKind == 'provider:provider_list_changed';
  });
});

final _rawProviderIdsProvider = AutoDisposeFutureProvider<List<String>>(
  (ref) async {
    // recompute the list of providers on hot-restart
    ref.watch(hotRestartEventProvider);
    // cause the list of providers to be re-evaluated when notified of a change
    ref.watch(_providerListChanged);

    final isAlive = Disposable();
    ref.onDispose(isAlive.dispose);

    final eval = await ref.watch(providerEvalProvider.future);

    final providerIdRefs = await eval.evalInstance(
      'ProviderBinding.debugInstance.providerDetails.keys.toList()',
      isAlive: isAlive,
    );

    final providerIdInstances = await Future.wait([
      for (final idRef in providerIdRefs.elements!.cast<InstanceRef>())
        eval.safeGetInstance(idRef, isAlive),
    ]);

    return [
      for (final idInstance in providerIdInstances) idInstance.valueAsString!,
    ];
  },
  name: '_rawProviderIdsProvider',
);

final _rawProviderNodeProvider =
    AutoDisposeFutureProviderFamily<ProviderNode, String>(
  (ref, id) async {
    // recompute the providers informations on hot-restart
    ref.watch(hotRestartEventProvider);

    final isAlive = Disposable();
    ref.onDispose(isAlive.dispose);

    final eval = await ref.watch(providerEvalProvider.future);

    final providerNodeInstance = await eval.evalInstance(
      "ProviderBinding.debugInstance.providerDetails['$id']",
      isAlive: isAlive,
    );

    Future<Instance> getFieldWithName(String name) {
      return eval.safeGetInstance(
        providerNodeInstance.fields!
            .firstWhere((e) => e.decl?.name == name)
            .value as InstanceRef,
        isAlive,
      );
    }

    final type = await getFieldWithName('type');

    return ProviderNode(
      id: id,
      type: type.valueAsString!,
    );
  },
  name: '_rawProviderNodeProvider',
);

/// Combines [providerIdsProvider] with [providerNodeProvider] to obtain all
/// the [ProviderNode]s at once, sorted alphabetically.
final sortedProviderNodesProvider =
    AutoDisposeFutureProvider<List<ProviderNode>>((ref) async {
  final ids = await ref.watch(_rawProviderIdsProvider.future);

  final nodes = await Future.wait<ProviderNode>(
    ids.map((id) => ref.watch(_rawProviderNodeProvider(id).future)),
  );

  return nodes.toList()..sort((a, b) => a.type.compareTo(b.type));
});
