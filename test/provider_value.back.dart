  // group('Provider.value', () {
  //   testWidgets(
  //       "doesn't rebuild dependents when Provider.value update with == value",
  //       (tester) async {
  //     final useProvider = Provider.value(42);

  //     var buildCount = 0;
  //     final child = HookBuilder(builder: (c) {
  //       buildCount++;
  //       return Text(
  //         useProvider().toString(),
  //         textDirection: TextDirection.ltr,
  //       );
  //     });

  //     await tester.pumpWidget(
  //       ProviderScope(
  //         overrides: [
  //           useProvider.overrideForSubtree(Provider.value(0)),
  //         ],
  //         child: child,
  //       ),
  //     );

  //     expect(buildCount, 1);
  //     expect(find.text('0'), findsOneWidget);

  //     await tester.pumpWidget(
  //       ProviderScope(
  //         overrides: [
  //           useProvider.overrideForSubtree(Provider.value(0)),
  //         ],
  //         child: child,
  //       ),
  //     );

  //     expect(buildCount, 1);
  //     expect(find.text('0'), findsOneWidget);
  //   });
  //   testWidgets('expose value as is', (tester) async {
  //     final useProvider = Provider.value(42);

  //     await tester.pumpWidget(
  //       ProviderScope(
  //         child: HookBuilder(builder: (c) {
  //           return Text(
  //             useProvider().toString(),
  //             textDirection: TextDirection.ltr,
  //           );
  //         }),
  //       ),
  //     );

  //     expect(find.text('42'), findsOneWidget);
  //   });

  //   testWidgets('override updates rebuild dependents with new value',
  //       (tester) async {
  //     final useProvider = Provider.value(0);
  //     final child = HookBuilder(builder: (c) {
  //       return Text(
  //         useProvider().toString(),
  //         textDirection: TextDirection.ltr,
  //       );
  //     });

  //     await tester.pumpWidget(
  //       ProviderScope(
  //         overrides: [useProvider.overrideForSubtree(Provider.value(42))],
  //         child: child,
  //       ),
  //     );

  //     expect(find.text('42'), findsOneWidget);

  //     await tester.pumpWidget(
  //       ProviderScope(
  //         overrides: [useProvider.overrideForSubtree(Provider.value(21))],
  //         child: child,
  //       ),
  //     );

  //     expect(find.text('42'), findsNothing);
  //     expect(find.text('21'), findsOneWidget);
  //   });
  // });
 