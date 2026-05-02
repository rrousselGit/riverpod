import 'package:devtools_app_shared/ui.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:hooks_riverpod/src/internals.dart' as internals;

import 'frames.dart';
import 'object.dart';
import 'providers/providers.dart';
import 'search/fuzzy_match.dart';
import 'vm_service.dart';

class ProviderList extends StatelessWidget {
  const ProviderList({
    super.key,
    required this.originStates,
    this.onSelected,
    this.selectedId,
    this.shrinkWrap = false,
    this.showOthers = true,
  });

  final OriginStates originStates;
  final void Function(ProviderMeta?)? onSelected;
  final internals.ElementId? selectedId;
  final bool shrinkWrap;
  final bool showOthers;

  @override
  Widget build(BuildContext context) {
    // Categorize providers by their status in the current frame
    final modifiedProviders = <internals.OriginId, AccumulatedFilter>{};
    final disposedProviders = <internals.OriginId, AccumulatedFilter>{};
    final otherProviders = <internals.OriginId, AccumulatedFilter>{};

    for (final entry in originStates.entries) {
      for (final element in entry.value.elements) {
        switch (element.status) {
          case ProviderStatusInFrame.added:
          case ProviderStatusInFrame.modified:
            final acc = modifiedProviders[entry.key] ??= entry.value.fork();
            acc.elements.add(element);

          case ProviderStatusInFrame.disposed:
            final acc = disposedProviders[entry.key] ??= entry.value.fork();
            acc.elements.add(element);

          case null when showOthers:
            final acc = otherProviders[entry.key] ??= entry.value.fork();
            acc.elements.add(element);
          case null:
            break;
        }
      }
    }

    return ListView(
      shrinkWrap: shrinkWrap,
      children: [
        if (modifiedProviders.isNotEmpty) ...[
          const _SectionDivider(label: 'Modified'),
          for (final provider in modifiedProviders.values)
            ..._buildProviderGroup(provider),
        ],
        if (disposedProviders.isNotEmpty) ...[
          const _SectionDivider(label: 'Disposed'),
          for (final provider in disposedProviders.values)
            ..._buildProviderGroup(provider),
        ],
        if (otherProviders.isNotEmpty) ...[
          const _SectionDivider(label: 'Unchanged'),
          for (final provider in otherProviders.values)
            ..._buildProviderGroup(provider),
        ],
      ],
    );
  }

  List<Widget> _buildProviderGroup(AccumulatedFilter associatedProviders) {
    return [
      if (associatedProviders.foundCount == 1)
        _Tile(
          indent: null,
          onTap: onSelected.bind((cb) {
            cb(associatedProviders.elements.single.element.provider);
          }),
          selected:
              associatedProviders.foundCount == 1 &&
              associatedProviders.elements.single.isSelected(selectedId),
          hash: associatedProviders.elements.single.origin.hashValue,
          creationStackTrace: associatedProviders
              .elements
              .single
              .element
              .provider
              .creationStackTrace,
          containerHash: associatedProviders
              .elements
              .single
              .element
              .provider
              .containerHashValue,
          associatedProviders.elements.single.originMatch,
        )
      else
        _Heading(associatedProviders.elements.first.originMatch),

      if (associatedProviders.foundCount > 1) ...[
        for (final (index, providerState)
            in associatedProviders.elements.indexed)
          _Tile(
            onTap: onSelected.bind((cb) {
              cb(providerState.element.provider);
            }),
            selected: providerState.isSelected(selectedId),
            hash: providerState.element.provider.hashValue,
            creationStackTrace:
                providerState.element.provider.creationStackTrace,
            containerHash: providerState.element.provider.containerHashValue,
            indent: index == associatedProviders.elements.length - 1
                ? '└─'
                : '├─',
            providerState.argMatch,
          ),
      ],
    ];
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, {super.key});

  final FuzzyMatch text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FuzzyText(match: text),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(
    this.text, {
    super.key,
    this.selected = false,
    required this.onTap,
    required this.indent,
    required this.hash,
    required this.containerHash,
    required this.creationStackTrace,
  });

  final FuzzyMatch text;
  final String? indent;
  final bool selected;
  final void Function()? onTap;
  final String hash;
  final String containerHash;
  final String? creationStackTrace;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Theme.of(context).colorScheme.selectedRowBackgroundColor
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            spacing: 10,
            children: [
              if (indent case final indent?)
                Text(
                  indent,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              Expanded(child: FuzzyText(match: text)),
            ],
          ),
        ),
      ),
    );
  }
}
