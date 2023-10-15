import 'dart:async';

import 'package:collection/collection.dart';
import 'package:devtools_app_shared/ui.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'instance_viewer/instance_details.dart';
import 'instance_viewer/instance_providers.dart';
import 'instance_viewer/instance_viewer.dart';
import 'provider_list.dart';
import 'provider_nodes.dart';

final _hasErrorProvider = Provider.autoDispose<bool>((ref) {
  if (ref.watch(sortedProviderNodesProvider) is AsyncError) return true;

  final selectedProviderId = ref.watch(selectedProviderIdProvider);

  if (selectedProviderId == null) return false;

  final instance = ref.watch(
    instanceProvider(InstancePath.fromProviderId(selectedProviderId)),
  );

  return instance is AsyncError;
});

final _selectedProviderNode = AutoDisposeProvider<ProviderNode?>((ref) {
  final selectedId = ref.watch(selectedProviderIdProvider);

  return ref.watch(sortedProviderNodesProvider).asData?.value.firstWhereOrNull(
        (node) => node.id == selectedId,
      );
});

final _showInternals = StateProvider<bool>((ref) => false);

class ProviderScreenBody extends ConsumerWidget {
  const ProviderScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splitAxis = Split.axisFor(context, 0.85);

    // A provider will automatically be selected as soon as one is detected
    final selectedProviderId = ref.watch(selectedProviderIdProvider);
    final detailsTitleText = selectedProviderId != null
        ? ref.watch(_selectedProviderNode)?.type ?? ''
        : '[No provider selected]';

    ref.listen<bool>(_hasErrorProvider, (_, hasError) {
      if (hasError) showProviderErrorBanner();
    });

    return Split(
      axis: splitAxis,
      initialFractions: const [0.33, 0.67],
      children: [
        const RoundedOutlinedBorder(
          clip: true,
          child: Column(
            children: [
              AreaPaneHeader(
                roundedTopBorder: false,
                includeTopBorder: false,
                title: Text('Providers'),
              ),
              Expanded(
                child: ProviderList(),
              ),
            ],
          ),
        ),
        RoundedOutlinedBorder(
          clip: true,
          child: Column(
            children: [
              AreaPaneHeader(
                roundedTopBorder: false,
                includeTopBorder: false,
                title: Text(detailsTitleText),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      unawaited(
                        showDialog(
                          context: context,
                          builder: (_) => _StateInspectorSettingsDialog(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              if (selectedProviderId != null)
                Expanded(
                  child: InstanceViewer(
                    rootPath: InstancePath.fromProviderId(selectedProviderId),
                    showInternalProperties: ref.watch(_showInternals),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

void showProviderErrorBanner() {
  extensionManager.showBannerMessage(
    key: 'provider_unknown_error',
    type: 'error',
    message: '''
DevTools failed to connect with package:provider.

This could be caused by an older version of package:provider; please make sure that you are using version >=5.0.0.''',
    extensionName: 'provider',
  );
}

class _StateInspectorSettingsDialog extends ConsumerWidget {
  static const title = 'State inspector configurations';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DevToolsDialog(
      title: const DialogTitleText(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () =>
                ref.read(_showInternals.notifier).update((state) => !state),
            child: Row(
              children: [
                Checkbox(
                  value: ref.watch(_showInternals),
                  onChanged: (_) => ref
                      .read(_showInternals.notifier)
                      .update((state) => !state),
                ),
                const Text(
                  'Show private properties inherited from SDKs/packages',
                ),
              ],
            ),
          ),
        ],
      ),
      actions: const [
        DialogCloseButton(),
      ],
    );
  }
}
