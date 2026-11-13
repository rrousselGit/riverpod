import 'dart:math';
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:web/web.dart' as web;

// The exact code shown in the "Implementing pull-to-refresh" article.
import '../docs/how_to/pull_to_refresh/full_app/raw.dart';
import 'bridge.dart';

const _breweries = [
  ('Hoppy Trails Brewing', 'micro', 'Portland', 'United States'),
  ('Barrel & Bramble', 'brewpub', 'Bristol', 'England'),
  ('Golden Hour Ales', 'micro', 'Austin', 'United States'),
  ('Brasserie du Canal', 'regional', 'Lyon', 'France'),
  ('Northern Lights Brewery', 'micro', 'Tromsø', 'Norway'),
  ('Riverside Taproom', 'taproom', 'Melbourne', 'Australia'),
  ('Old Mill Brewhouse', 'brewpub', 'Galway', 'Ireland'),
  ('Cedar Ridge Craft', 'nano', 'Asheville', 'United States'),
];

/// Runs the article's [BreweryView] with a fake network layer that the page
/// controls through [DemoBridge].
///
/// Commands:
/// - `setLatency` (int, milliseconds): how long fake requests take.
/// - `setShouldFail` (bool): whether fake requests throw.
/// - `refresh`: calls `ref.refresh(breweryProvider)` from outside the UI.
///
/// Reports:
/// - `state`: the current `AsyncValue` of `breweryProvider`.
/// - `request`: request lifecycle (`started`, `succeeded`, `failed`).
class PullToRefreshDemo extends StatefulWidget {
  const PullToRefreshDemo({super.key, required this.bridge});

  final DemoBridge bridge;

  @override
  State<PullToRefreshDemo> createState() => _PullToRefreshDemoState();
}

class _PullToRefreshDemoState extends State<PullToRefreshDemo> {
  final _random = Random();
  var _latency = const Duration(seconds: 1);
  var _shouldFail = false;
  var _requestCount = 0;

  late final container = ProviderContainer(
    overrides: [
      // Replaces the HTTP call to Open Brewery DB, so that the demo works
      // offline and the page can tweak latency and failures.
      breweryProvider.overrideWith((ref) async {
        final id = ++_requestCount;
        widget.bridge.emit('request', {'id': id, 'status': 'started'});

        await Future<void>.delayed(_latency);

        if (_shouldFail) {
          widget.bridge.emit('request', {'id': id, 'status': 'failed'});
          throw Exception('Simulated network failure');
        }

        widget.bridge.emit('request', {'id': id, 'status': 'succeeded'});
        final (name, breweryType, city, country) =
            _breweries[_random.nextInt(_breweries.length)];
        return Brewery(
          name: name,
          breweryType: breweryType,
          city: city,
          country: country,
        );
      }),
    ],
  );

  @override
  void initState() {
    super.initState();
    widget.bridge.listen((type, value) {
      switch ((type, value)) {
        case ('setLatency', final num ms):
          _latency = Duration(milliseconds: ms.toInt());
        case ('setShouldFail', final bool shouldFail):
          _shouldFail = shouldFail;
        case ('refresh', _):
          container.refresh(breweryProvider);
      }
    });

    container.listen(breweryProvider, (_, state) {
      widget.bridge.emit('state', _describe(state));
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    container.dispose();
    super.dispose();
  }

  Map<String, Object?> _describe(AsyncValue<Brewery> state) {
    return {
      'kind': switch (state) {
        AsyncData() => 'AsyncData',
        AsyncError() => 'AsyncError',
        AsyncLoading() => 'AsyncLoading',
      },
      'isLoading': state.isLoading,
      'isRefreshing': state.isRefreshing,
      'value': state.value?.name,
      'error': state.error?.toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        // MaterialApp writes its title to the browser tab, so keep the page's.
        title: web.document.title,
        debugShowCheckedModeBanner: false,
        // Browsers report mouse drags as mouse events, which Flutter does not
        // treat as drag gestures by default. Enable them so that desktop users
        // can pull to refresh.
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: PointerDeviceKind.values.toSet(),
        ),
        home: BreweryView(),
      ),
    );
  }
}
