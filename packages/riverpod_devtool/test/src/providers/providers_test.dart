import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/src/internals.dart' as internals;
import 'package:riverpod_devtool/src/frames.dart';
import 'package:riverpod_devtool/src/providers/providers.dart';
import 'package:riverpod_devtool/src/vm_service.dart';

ProviderElementAddEvent _addEvent({
  required String elementId,
  required String originId,
  required String originLabel,
  String arg = '',
  String? stateId,
}) {
  return ProviderElementAddEvent(
    provider: ProviderMeta.test(
      elementId: elementId,
      originId: originId,
      label: originLabel,
      argToStringValue: arg,
    ),
    state: ProviderStateRef.test(cacheId: stateId ?? 'state-$elementId'),
    notifier: null,
  );
}

ProviderElementUpdateEvent _updateEvent({
  required String elementId,
  required String originId,
  required String originLabel,
  String arg = '',
  String? stateId,
}) {
  return ProviderElementUpdateEvent(
    provider: ProviderMeta.test(
      elementId: elementId,
      originId: originId,
      label: originLabel,
      argToStringValue: arg,
    ),
    next: ProviderStateRef.test(cacheId: stateId ?? 'state-$elementId'),
    notifier: null,
  );
}

List<FoldedFrame> _foldedFrames(List<Frame> frames) {
  FoldedFrame? previous;
  return [
    for (final frame in frames)
      (() {
        final folded = FoldedFrame(frame: frame, previous: previous);
        previous = folded;
        return folded;
      })(),
  ];
}

Future<void> _settleProviders(ProviderContainer container) async {
  final subscription = container.listen<AsyncValue<List<FoldedFrame>>>(
    framesProvider,
    (_, _) {},
    fireImmediately: true,
  );
  addTearDown(subscription.close);
  await container.read(framesProvider.future);
  await pumpEventQueue();
}

ProviderContainer _createContainer([
  List<internals.Override> overrides = const [],
]) {
  return ProviderContainer.test(
    overrides: [hotRestartEventProvider.overrideWith((ref) {}), ...overrides],
  );
}

void main() {
  group('provider state', () {
    test(
      'allDiscoveredOriginsProvider tracks unique origins from add events',
      () async {
        final frames = _foldedFrames([
          Frame.test(
            index: 0,
            events: [
              _addEvent(
                elementId: 'alpha-1',
                originId: 'origin-alpha',
                originLabel: 'Alpha',
              ),
              _addEvent(
                elementId: 'beta-1',
                originId: 'origin-beta',
                originLabel: 'Beta',
              ),
            ],
          ),
          Frame.test(
            index: 1,
            events: [
              _addEvent(
                elementId: 'alpha-2',
                originId: 'origin-alpha',
                originLabel: 'Alpha',
              ),
              _updateEvent(
                elementId: 'beta-1',
                originId: 'origin-beta',
                originLabel: 'Beta',
              ),
            ],
          ),
        ]);
        final container = _createContainer([
          framesProvider.overrideWithBuild((ref, self) => frames),
        ]);

        await _settleProviders(container);

        expect(container.read(allDiscoveredOriginsProvider), {
          internals.OriginId('origin-alpha'),
          internals.OriginId('origin-beta'),
        });
      },
    );

    test(
      'filteredProvidersProvider groups matches and preserves per-origin counts',
      () async {
        final frames = _foldedFrames([
          Frame.test(
            index: 0,
            events: [
              _addEvent(
                elementId: 'alpha-1',
                originId: 'origin-alpha',
                originLabel: 'Alpha',
                arg: 'first value',
              ),
              _addEvent(
                elementId: 'beta-1',
                originId: 'origin-beta',
                originLabel: 'Beta',
                arg: 'other value',
              ),
            ],
          ),
          Frame.test(
            index: 1,
            events: [
              _updateEvent(
                elementId: 'alpha-1',
                originId: 'origin-alpha',
                originLabel: 'Alpha',
                arg: 'still not matching',
              ),
              _addEvent(
                elementId: 'alpha-2',
                originId: 'origin-alpha',
                originLabel: 'Alpha',
                arg: 'needle value',
              ),
            ],
          ),
        ]);
        final container = _createContainer([
          framesProvider.overrideWithBuild((ref, self) => frames),
        ]);

        await _settleProviders(container);

        final result = container.read(
          filteredProvidersProvider((search: 'needle', frame: FrameId(1))),
        );
        final alpha = result[internals.OriginId('origin-alpha')];
        final beta = result[internals.OriginId('origin-beta')];

        expect(alpha, isNotNull);
        expect(alpha!.foundCount, 2);
        expect(alpha.elements, hasLength(1));
        expect(
          alpha.elements.single.element.provider.elementId,
          internals.ElementId('alpha-2'),
        );
        expect(alpha.elements.single.argMatch.didMatch, isTrue);
        expect(alpha.elements.single.status, ProviderStatusInFrame.added);

        expect(beta, isNotNull);
        expect(beta!.foundCount, 1);
        expect(beta.elements, isEmpty);
      },
    );

    test(
      'selectedProviderIdProvider picks the first match again when selection becomes invalid',
      () async {
        final container = _createContainer([
          framesProvider.overrideWithBuild(
            (ref, self) => _foldedFrames([
              Frame.test(
                index: 0,
                events: [
                  _addEvent(
                    elementId: 'alpha-1',
                    originId: 'origin-alpha',
                    originLabel: 'Alpha',
                  ),
                  _addEvent(
                    elementId: 'beta-1',
                    originId: 'origin-beta',
                    originLabel: 'Beta',
                  ),
                ],
              ),
            ]),
          ),
        ]);

        await _settleProviders(container);
        final selectedIdSubscription = container.listen(
          selectedProviderIdProvider('Alpha'),
          (_, _) {},
          fireImmediately: true,
        );
        addTearDown(selectedIdSubscription.close);

        final selectedNotifier = container.read(
          selectedProviderIdProvider('Alpha').notifier,
        );

        expect(selectedNotifier.stateOrNull, internals.ElementId('alpha-1'));

        selectedNotifier.state = internals.ElementId('beta-1');

        container.read(framesProvider.notifier).state = AsyncData(
          _foldedFrames([
            Frame.test(
              index: 0,
              events: [
                _addEvent(
                  elementId: 'alpha-1',
                  originId: 'origin-alpha',
                  originLabel: 'Alpha',
                ),
                _addEvent(
                  elementId: 'beta-1',
                  originId: 'origin-beta',
                  originLabel: 'Beta',
                ),
              ],
            ),
            Frame.test(
              index: 1,
              events: [
                _updateEvent(
                  elementId: 'alpha-1',
                  originId: 'origin-alpha',
                  originLabel: 'Alpha',
                ),
                _addEvent(
                  elementId: 'alpha-2',
                  originId: 'origin-alpha',
                  originLabel: 'Alpha',
                ),
              ],
            ),
          ]),
        );
        await pumpEventQueue();

        expect(selectedNotifier.stateOrNull, internals.ElementId('alpha-1'));
      },
    );

    test(
      'selectedProviderProvider returns the currently selected filtered element',
      () async {
        final container = _createContainer([
          framesProvider.overrideWithBuild(
            (ref, self) => _foldedFrames([
              Frame.test(
                index: 0,
                events: [
                  _addEvent(
                    elementId: 'alpha-1',
                    originId: 'origin-alpha',
                    originLabel: 'Alpha',
                    arg: 'first value',
                  ),
                ],
              ),
              Frame.test(
                index: 1,
                events: [
                  _addEvent(
                    elementId: 'alpha-2',
                    originId: 'origin-alpha',
                    originLabel: 'Alpha',
                    arg: 'needle value',
                  ),
                ],
              ),
            ]),
          ),
        ]);

        await _settleProviders(container);
        final selectedIdSubscription = container.listen(
          selectedProviderIdProvider('needle'),
          (_, _) {},
          fireImmediately: true,
        );
        addTearDown(selectedIdSubscription.close);
        await pumpEventQueue();

        final selected = container.read(selectedProviderProvider('needle'));

        expect(selected, isNotNull);
        expect(
          selected!.element.provider.elementId,
          internals.ElementId('alpha-2'),
        );
        expect(selected.isSelected(internals.ElementId('alpha-2')), isTrue);
      },
    );

    test(
      'filteredProvidersProvider throws when an element origin was never discovered',
      () async {
        final container = _createContainer([
          framesProvider.overrideWithBuild(
            (ref, self) => _foldedFrames([
              Frame.test(
                index: 0,
                events: [
                  _updateEvent(
                    elementId: 'ghost-1',
                    originId: 'origin-ghost',
                    originLabel: 'Ghost',
                  ),
                ],
              ),
            ]),
          ),
        ]);

        await _settleProviders(container);

        expect(
          () => container.read(
            filteredProvidersProvider((search: '', frame: FrameId(0))),
          ),
          throwsA(
            predicate(
              (error) => '$error'.contains('discovered origins'),
              'an error mentioning discovered origins',
            ),
          ),
        );
      },
    );
  });
}
