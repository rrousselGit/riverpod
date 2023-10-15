// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:devtools_app_shared/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider_nodes.dart';

const _tilePadding = EdgeInsets.only(
  left: defaultSpacing,
  right: densePadding,
  top: densePadding,
  bottom: densePadding,
);

final AutoDisposeStateNotifierProvider<StateController<String?>, String?>
    selectedProviderIdProvider =
    AutoDisposeStateNotifierProvider<StateController<String?>, String?>(
  (ref) {
    final controller = StateController<String?>(null);

    ref.listen<AsyncValue<List<ProviderNode>>>(
      sortedProviderNodesProvider,
      (prev, value) {
        final nodes = value.asData?.value;
        if (nodes == null) return;

        if (controller.state == null) {
          if (nodes.isNotEmpty) controller.state = nodes.first.id;
          return;
        }

        if (nodes.isEmpty) {
          controller.state = null;
        }

        /// The previously selected provider was unmounted
        else if (!nodes.any((node) => node.id == controller.state)) {
          controller.state = nodes.first.id;
        }
      },
      fireImmediately: true,
    );

    return controller;
  },
  name: 'selectedProviderIdProvider',
);

class ProviderList extends ConsumerStatefulWidget {
  const ProviderList({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProviderListState();
}

class _ProviderListState extends ConsumerState<ProviderList> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodes = ref.watch(sortedProviderNodesProvider);

    return nodes.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Padding(
        padding: _tilePadding,
        child: Text('<unknown error>\n$stack'),
      ),
      data: (nodes) {
        return Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: ListView.builder(
            primary: false,
            controller: scrollController,
            itemCount: nodes.length,
            itemBuilder: (context, index) {
              final node = nodes[index];
              return ProviderNodeItem(
                key: Key('provider-${node.id}'),
                node: node,
              );
            },
          ),
        );
      },
    );
  }
}

class ProviderNodeItem extends ConsumerWidget {
  const ProviderNodeItem({
    Key? key,
    required this.node,
  }) : super(key: key);

  final ProviderNode node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(selectedProviderIdProvider) == node.id;

    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor =
        isSelected ? colorScheme.selectedRowBackgroundColor : null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.read(selectedProviderIdProvider.notifier).state = node.id;
      },
      child: Container(
        color: backgroundColor,
        padding: _tilePadding,
        child: Text('${node.type}()'),
      ),
    );
  }
}
