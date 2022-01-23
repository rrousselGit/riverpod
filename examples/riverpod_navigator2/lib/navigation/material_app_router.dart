import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_state_manager.dart';

import 'auto_router.gr.dart';

class MaterialAppRouter extends ConsumerWidget {
  MaterialAppRouter({
    Key? key,
  }) : super(key: key);

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routeInformationParser:
          _appRouter.defaultRouteParser(includePrefixMatches: true),
      routerDelegate: AutoRouterDelegate.declarative(
        _appRouter,
        routes: (_) => [
          if (ref.watch(appStateManager).isLoggedIn) const HomeRoute()
          else const LoginRoute(),
        ],
      ),
    );
  }
}