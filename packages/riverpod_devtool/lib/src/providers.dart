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
  FilteredElement({required this.element, required this.match});


  OriginMeta get origin => element.provider.origin;
  final ElementMeta element;
  final FuzzyMatch match;

  bool isSelected(internals.ElementId? id) => id == element.provider.elementId;
}

typedef OriginStates = Map<internals.OriginId, List<FilteredElement>>;

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
          origin: <FilteredElement>[],
      };

      for (final element in frame.elements.values) {
        result[element.provider.origin.id]!.add(
          FilteredElement(
            element: element,
            match: element.provider.toStringValue.fuzzyMatch(text),
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
