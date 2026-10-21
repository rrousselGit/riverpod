@TestOn('browser')
library;

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart' as sdk;
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_devtool/main.dart';
import 'package:riverpod_devtool/src/frames.dart';
import 'package:riverpod_devtool/src/ui_primitives/search_bar.dart';

Future<void> pumpExtension(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        filteredFramesProvider.overrideWith((ref) => const AsyncLoading()),
      ],
      child: const RiverpodDevtoolExtension(),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('initializes the extension manager before reading its theme', (
    tester,
  ) async {
    expect(() => extensionManager, throwsStateError);
    await pumpExtension(tester);
    expect(extensionManager, isA<ExtensionManager>());
    expect(tester.takeException(), isNull);
  });

  testWidgets('connection message inherits readable light and dark styles', (
    tester,
  ) async {
    await pumpExtension(tester);
    final message = find.text(
      'Waiting to connect to the Riverpod application...',
    );
    for (final isDark in [false, true]) {
      extensionManager.darkThemeEnabled.value = isDark;
      await tester.pumpAndSettle();
      final context = tester.element(message);
      final theme = Theme.of(context);
      final style = DefaultTextStyle.of(context).style;
      expect(theme.brightness, isDark ? Brightness.dark : Brightness.light);
      expect(style.color, theme.textTheme.bodyMedium!.color);
      expect(style.fontSize, theme.textTheme.bodyMedium!.fontSize);
      expect(style.decoration, TextDecoration.none);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('sidebar search supports SDK and material_ui localizations', (
    tester,
  ) async {
    await pumpExtension(tester);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final context = tester.element(find.text('No frame selected'));
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          body: DevtoolSearchBar(
            hintText: 'Search Providers',
            controller: controller,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final searchContext = tester.element(find.byType(DevtoolSearchBar));
    expect(MaterialLocalizations.of(searchContext), isNotNull);
    expect(sdk.MaterialLocalizations.of(searchContext), isNotNull);
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(sdk.TextField), 'counter');
    expect(controller.text, 'counter');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
