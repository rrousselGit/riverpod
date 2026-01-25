import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/src/internals.dart' as internals;

import 'collection.dart';
import 'elements.dart';
import 'frames.dart';
import 'search.dart';
import 'vm_service.dart';

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

      final frames = next.value ?? const [];

      frames.forEach(_handleFrame);
    });

    return state;
  }

  void _handleFrame(FoldedFrame frame) {
    print('Handle frame ${frame.frame.events}');
    final setBuilder = SetBuilder<internals.OriginId>(state);

    for (final event in frame.frame.events) {
      if (event case ProviderElementAddEvent(:final provider)) {
        state.add(provider.origin.id);
      }
    }

    state = setBuilder.build();
  }
}

// TODO
// abstract class OriginState implements Built<OriginState, OriginStateBuilder> {
//   factory OriginState({
//     required OriginMeta2 value,
//     required Map<internals.ElementId, ProviderState> associatedProviders,
//   }) => _$OriginState((b) {
//     b.value = value;
//     b.associatedProviders = associatedProviders;
//   });

//   OriginState._();

//   OriginMeta2 get value;
//   Map<internals.ElementId, ProviderState> get associatedProviders;
// }

// extension type OriginMeta2(OriginMeta value) implements OriginMeta {}
// extension type ProviderMeta2(ProviderMeta value) implements ProviderMeta {}

extension ProviderMetaX on ProviderMeta {}

class FilteredElement {
  FilteredElement({
    required this.element,
    required this.argMatch,
    required this.originMatch,
  });

  OriginMeta get origin => element.provider.origin;
  final ElementMeta element;
  final FuzzyMatch originMatch;
  final FuzzyMatch argMatch;

  bool isSelected(internals.ElementId? id) => id == element.provider.elementId;
}

typedef OriginStates = Map<internals.OriginId, AccumulatedFilter>;

class AccumulatedFilter {
  var _foundCount = 0;
  int get foundCount => _foundCount;

  final List<FilteredElement> elements = [];
}

final filteredProvidersProvider = Provider.autoDispose
    .family<
      OriginStates,
      ({
        String text,
        // Frames are fully immutable, so it's safe to use them as keys.
        FoldedFrame frame,
      })
    >((ref, args) {
      final (:text, :frame) = args;
      final result = {
        for (final origin in ref.watch(allDiscoveredOriginsProvider))
          origin: AccumulatedFilter(),
      };

      for (final element in frame.elements.values) {
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
          text,
        );
        final argMatch = element.provider.argToStringValue.fuzzyMatch(text);

        if (!originMatch.didMatch && !argMatch.didMatch) continue;

        acc.elements.add(
          FilteredElement(
            element: element,
            originMatch: originMatch,
            argMatch: argMatch,
          ),
        );
      }

      // Remove origins with no matching providers.
      result.removeWhere((key, value) => value.elements.isEmpty);

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
