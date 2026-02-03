import 'dart:async';

import 'package:devtools_app_shared/ui.dart';
import 'package:devtools_app_shared/ui.dart' as devtools_shared_ui;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: implementation_imports
import 'package:hooks_riverpod/src/internals.dart' as internals;

import 'elements.dart';
import 'frames.dart';
import 'ide.dart';
import 'object.dart';
import 'provider_list.dart';
import 'providers/providers.dart';
import 'state_inspector/inspector.dart';
import 'terminal.dart';
import 'ui_primitives/panel.dart';
import 'ui_primitives/search_bar.dart';
import 'vm_service.dart';

class FrameView extends HookConsumerWidget {
  const FrameView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFrameNotifier = ref.watch(selectedFrameIdProvider.notifier);
    final searchController = useTextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _FramePanel(searchController: searchController)),
        Center(
          child: ValueListenableBuilder(
            valueListenable: searchController,
            builder: (context, search, child) {
              return FrameStepper(
                onSelect: (frame) => selectedFrameNotifier.state = frame,
                selectedFrame: ref.watch(selectedFrameProvider),
                selectedElement: ref.watch(
                  selectedProviderProvider(search.text),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FramePanel extends ConsumerWidget {
  const _FramePanel({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFrame = ref.watch(selectedFrameProvider);

    if (selectedFrame != null) {
      return _FrameViewer(searchController: searchController);
    }

    return const Panel(child: Center(child: Text('No frame selected')));
  }
}

class _FrameViewer extends HookConsumerWidget {
  const _FrameViewer({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = useValueListenable(searchController);
    final originStates = ref.watch(
      filteredProvidersForCurrentFrameProvider(search.text),
    );
    final selected = ref.watch(selectedProviderProvider(search.text));
    final selectedNotifier = ref.watch(
      selectedProviderIdProvider(search.text).notifier,
    );

    useEffect(() {
      if (selected?.origin.creationStackTrace case final trace?) {
        Future(() => openTraceInIDE(ref, trace));
      }

      return null;
    }, [selected?.origin.creationStackTrace]);

    return SplitPane(
      axis: Axis.horizontal,
      initialFractions: const [0.3, 0.7],
      minSizes: const [100, 150],
      children: [
        _ProviderPickerPanel(
          searchController: searchController,
          originStates: originStates,
          selectedId: selected?.element.provider.elementId,
          onSelected: (value) {
            selectedNotifier.state = value?.elementId ?? selectedNotifier.state;
          },
        ),

        if (selected case final selected?)
          ProviderViewer(element: selected.element)
        else
          const Panel(child: Text('No provider selected')),
      ],
    );
  }
}

extension DevtoolTheme on ThemeData {
  Color get panelBorderColor => focusColor;
}

const dividerHeight = 16.0;

class ProviderViewer extends StatelessWidget {
  const ProviderViewer({super.key, required this.element});

  final ElementMeta element;

  @override
  Widget build(BuildContext context) {
    const terminalMinSize = 60.0;
    const stateMinSize = 50.0;

    final state = (
      minSize: stateMinSize,
      fraction: element.notifier == null ? .8 : .6,
      content: Material(
        child: Column(
          spacing: denseRowSpacing,
          children: [
            const devtools_shared_ui.AreaPaneHeader(
              roundedTopBorder: false,
              includeTopBorder: false,
              title: Text('State'),
            ),
            Expanded(child: Inspector(object: element.state.state)),
          ],
        ),
      ),
    );

    final notifier = element.notifier.let((notifier) {
      return (
        minSize: stateMinSize,
        fraction: .2,
        heading: const PreferredSize(
          preferredSize: Size(0, 28),
          child: devtools_shared_ui.AreaPaneHeader(
            roundedTopBorder: false,
            title: Text('Notifier'),
          ),
        ),
        content: Material(
          child: Padding(
            padding: const .symmetric(vertical: 8),
            child: Inspector(object: notifier.state),
          ),
        ),
      );
    });

    final terminal = (
      minSize: terminalMinSize,
      fraction: .2,
      heading: const PreferredSize(
        preferredSize: Size(0, 28),
        child: devtools_shared_ui.AreaPaneHeader(
          roundedTopBorder: false,
          title: Text('Terminal'),
        ),
      ),
      content: Material(
        child: Terminal(
          state: element.state.state,
          notifier: element.notifier?.state,
        ),
      ),
    );

    return Panel(
      child: SplitPane(
        // TODO remove key, Blocked by: https://github.com/flutter/devtools/issues/9648
        key: ValueKey(notifier != null),
        axis: .vertical,
        initialFractions: [
          state.fraction,
          ?notifier?.fraction,
          terminal.fraction,
        ],
        minSizes: [state.minSize, ?notifier?.minSize, terminal.minSize],
        splitters: [if (notifier != null) notifier.heading, terminal.heading],
        // Force Material, to avoid issues with overflowing InkWells
        children: <Material>[state.content, ?notifier?.content, terminal.content],
      ),
    );
  }
}

class _ProviderPickerPanel extends HookConsumerWidget {
  const _ProviderPickerPanel({
    super.key,
    required this.selectedId,
    required this.onSelected,
    required this.originStates,
    required this.searchController,
  });

  final OriginStates originStates;
  final internals.ElementId? selectedId;
  final void Function(ProviderMeta?) onSelected;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Panel(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DevtoolSearchBar(
                hintText: 'Search Providers',
                controller: searchController,
              ),
            ),
            const Divider(),
            Expanded(
              child: ProviderList(
                originStates: originStates,
                onSelected: onSelected,
                selectedId: selectedId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
