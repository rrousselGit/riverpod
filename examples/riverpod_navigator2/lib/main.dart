import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_navigator2/navigation/app_router.dart';
import 'package:riverpod_navigator2/providers/app_state_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late AppRouter _appRouter;


  @override
  void initState() {
    _appRouter = AppRouter(
      appStateManager: ref.read(appStateManager),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Router(
        routerDelegate: _appRouter,
      ),
    );
  }
}
