import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: implementation_imports
import 'package:hooks_riverpod/src/internals.dart' as internals;

import '../collection.dart';
import '../elements.dart';
import '../frames.dart';
import '../riverpod.dart';
import '../search/fuzzy_match.dart';
import '../vm_service.dart';

final selectedProviderProvider = Provider.family
    .autoDispose<FilteredElement?, String>((ref, search) {
      final selectedId = ref.watch(selectedProviderIdProvider(search));
      if (selectedId == null) return null;
      final filteredProviders = ref.watch(
        filteredProvidersForCurrentFrameProvider(search),
      );

      final selected = filteredProviders.values
          .expand((e) => e.elements)
          .where((e) => e.isSelected(selectedId))
          .firstOrNull;
      if (selected == null) {
        throw StateError(
          'Selected provider id $selectedId not found in filtered providers for search "$search".',
        );
      }

      return selected;
    });

final selectedProviderIdProvider = NotifierProvider.autoDispose
    .family<StateNotifier<internals.ElementId?>, internals.ElementId?, String>(
      name: 'selectedProviderIdProvider',
      (search) => StateNotifier<internals.ElementId?>((ref, self) {
        // Clear selected provider on hot-restart, due to frames being cleared too
        ref.watch(hotRestartEventProvider);

        ref.listen(
          filteredProvidersForCurrentFrameProvider(search),
          fireImmediately: true,
          (previous, next) {
            late final newProvidersContainId =
                next.values
                    .expand((e) => e.elements)
                    .where((e) => e.isSelected(self.state))
                    .firstOrNull !=
                null;

            if (self.stateOrNull == null || !newProvidersContainId) {
              self.state = next.values
                  .expand((e) => e.elements)
                  .firstOrNull
                  ?.element
                  .provider
                  .elementId;
            }
          },
        );

        return self.stateOrNull;
      }),
    );

final allDiscoveredOriginsProvider =
    NotifierProvider<AllDiscoveredOriginsNotifier, Set<internals.OriginId>>(
      AllDiscoveredOriginsNotifier.new,
    );

class AllDiscoveredOriginsNotifier extends Notifier<Set<internals.OriginId>> {
  @override
  Set<internals.OriginId> build() {
    ref.watch(hotRestartEventProvider);

    state = {};

    ref.listen(framesProvider, fireImmediately: true, (previous, next) {
      if (next.isLoading) return;

      final setBuilder = SetBuilder<internals.OriginId>(state);

      final frames = next.value ?? const [];

      for (final frame in frames) {
        for (final event in frame.frame.events) {
          if (event case ProviderElementAddEvent(:final provider)) {
            setBuilder.add(provider.origin.id);
          }
        }
      }

      state = setBuilder.build();
    });

    return state;
  }
}

extension ProviderMetaX on ProviderMeta {}

class FilteredElement {
  FilteredElement({
    required this.element,
    required this.argMatch,
    required this.originMatch,
    required this.status,
  });

  OriginMeta get origin => element.provider.origin;
  final ElementMeta element;
  final FuzzyMatch originMatch;
  final FuzzyMatch argMatch;
  final ProviderStatusInFrame? status;

  bool isSelected(internals.ElementId? id) => id == element.provider.elementId;
}

typedef OriginStates = Map<internals.OriginId, AccumulatedFilter>;

class AccumulatedFilter {
  AccumulatedFilter._();

  var _foundCount = 0;
  int get foundCount => _foundCount;

  final List<FilteredElement> elements = [];

  AccumulatedFilter fork() => AccumulatedFilter._().._foundCount = _foundCount;
}

final filteredProvidersForCurrentFrameProvider = Provider.autoDispose
    .family<OriginStates, String>((ref, text) {
      final selectedFrame = ref.watch(selectedFrameProvider);

      if (selectedFrame == null) return {};

      return ref.watch(
        filteredProvidersProvider((search: text, frame: selectedFrame.id)),
      );
    });

final filteredProvidersProvider = Provider.autoDispose
    .family<OriginStates, ({String search, FrameId? frame})>((ref, args) {
      final (:search, :frame) = args;
      final selectedFrame = ref.watch(
        framesProvider.select(
          (frames) => frames.value?.where((f) => f.id == frame).firstOrNull,
        ),
      );

      if (selectedFrame == null) return {};

      final result = {
        for (final origin in ref.watch(allDiscoveredOriginsProvider))
          origin: AccumulatedFilter._(),
      };

      for (final element in selectedFrame.elements.values) {
        final acc = result[element.provider.origin.id];
        if (acc == null) {
          throw StateError(
            'Element ${element.provider.elementId} has origin '
            '${element.provider.origin.id}, which is not in the list of '
            'discovered origins.',
          );
        }
        acc._foundCount++;

        final originMatch = element.provider.origin.toStringValue.fuzzyMatch(
          search,
        );
        final argMatch = element.provider.argToStringValue.fuzzyMatch(search);

        if (!originMatch.didMatch && !argMatch.didMatch) continue;

        acc.elements.add(
          FilteredElement(
            element: element,
            originMatch: originMatch,
            argMatch: argMatch,
            status: selectedFrame.statusOf(element.provider.elementId),
          ),
        );
      }

      return result;
    });

sealed class ProviderPickerItem {}

final class ProviderHeading extends ProviderPickerItem {
  ProviderHeading({required this.originMeta, required this.match});

  final OriginMeta originMeta;
  final FuzzyMatch match;
}

final class ProviderEntry extends ProviderPickerItem {
  ProviderEntry(this.providerMeta, this.match);
  final ProviderMeta providerMeta;
  final FuzzyMatch match;
}
