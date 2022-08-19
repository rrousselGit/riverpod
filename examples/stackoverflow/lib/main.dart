import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'common.dart';
import 'home.dart';

part 'main.g.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

@riverpod
class Count extends _$Count {
  @override
  int build() {
    print('count1');
    return 42;
  }

  void increment() => state++;
}

@riverpod
class Count2 extends _$Count2 {
  @override
  int build() {
    print('count2');
    return 4;
  }

  void increment() => state++;
}

class CHeck extends StatefulWidget {
  const CHeck({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<CHeck> createState() => _CHeckState();
}

class _CHeckState extends State<CHeck> {
  @override
  void initState() {
    super.initState();
    print('Init ');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(
        'Hello ${CountProvider.hashCode} // ${CountProvider.debugGetCreateSourceHash!()}');
    return MaterialApp(
      home: CHeck(
        child: Scaffold(
          body: Column(
            children: [
              Text(ref.watch(CountProvider).toString()),
              ElevatedButton(
                onPressed: () => ref.read(CountProvider.notifier).increment(),
                child: Text('+2'),
              ),
              Text(ref.watch(Count2Provider).toString()),
              ElevatedButton(
                onPressed: () => ref.read(Count2Provider.notifier).increment(),
                child: Text('+1'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String? prevHash;
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   Stream<void>.periodic(Duration(seconds: 5)).listen((event) {
//   //     printHash();
//   //   });
//   // }

//   void printHash() {
//     final prev = prevHash;
//     prevHash = $countHash();

//     print('from: $prev\nto: $prevHash');

//     if (prev != prevHash) {
//       print('changed');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     printHash();
//     // print('oy');
//     return MaterialApp(
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color(0xFF2d2d2d),
//       ),
//       builder: (context, child) {
//         final theme = Theme.of(context);

//         return ProviderScope(
//           overrides: [
//             /// We override "themeProvider" with a valid theme instance.
//             /// This allows providers such as "tagThemeProvider" to read the
//             /// current theme, without having a BuildContext.
//             themeProvider.overrideWithValue(theme),
//           ],
//           child: ListTileTheme(
//             textColor: const Color(0xFFe7e8eb),
//             child: child!,
//           ),
//         );
//       },
//       home: const MyHomePage(),
//     );
//   }
// }
