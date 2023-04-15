// ignore_for_file: unused_import, prefer_const_constructors
// Ignored so that uncommenting the code to mock HTP requests is simple.
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/fake_marvel.dart';
import 'src/marvel.dart';
import 'src/screens/character_detail.dart';
import 'src/screens/home.dart';

void main() {
  runApp(
    ProviderScope(
      // uncomment to mock the HTTP requests

      // overrides: [
      //   dioProvider.overrideWithValue(FakeDio(null))
      // ],
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      builder: (context, child) {
        return _Unfocus(
          child: child!,
        );
      },
      home: const Portal(child: Home()),
      onGenerateRoute: (settings) {
        if (settings.name == null) {
          return null;
        }
        final split = settings.name!.split('/');
        Widget? result;
        if (settings.name!.startsWith('/characters/') && split.length == 3) {
          result = ProviderScope(
            overrides: [
              selectedCharacterId.overrideWithValue(split.last),
            ],
            child: const CharacterView(),
          );
        }

        if (result == null) {
          return null;
        }
        return MaterialPageRoute<void>(builder: (context) => result!);
      },
      routes: {
        '/character': (c) => const CharacterView(),
      },
    );
  }
}

/// A widget that unfocus everything when tapped.
///
/// This implements the "Unfocus when tapping in empty space" behavior for the
/// entire application.
class _Unfocus extends HookConsumerWidget {
  const _Unfocus({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
