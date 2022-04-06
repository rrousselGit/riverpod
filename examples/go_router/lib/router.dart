import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';
import 'user.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // Keep this to `true` if want to know what's going on under the hood
    debugLogDiagnostics: true,
    redirect: (state) {
      // We want to READ the state, here.
      // GoRouter is already aware of state changes through `refreshListenable`
      final user = ref.read(userProvider);

      // From here we can use the state and implement our custom logic
      final areWeLoggingIn = state.location == '/login';

      if (user == null) {
        // We're not logged in
        // So, IF we aren't in the login page, go there.
        return areWeLoggingIn ? null : '/login';
      }
      // We're logged in

      // At this point, IF we're in the login page, go to the home page
      if (areWeLoggingIn) return '/';

      // There's no need for a redirect at this point.
      return null;
    },
    // This is crucial to make the router work with Riverpod.
    refreshListenable: RouterNotifier(ref),
    routes: [
      GoRoute(
        name: "home",
        path: '/',
        builder: (context, _) => const HomePage(),
      ),
      GoRoute(
        name: "login",
        path: '/login',
        builder: (context, _) => const LoginPage(),
      ),
    ],
  );
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  /// Creates a Notifier to be used in GoRouter
  ///
  /// While it is not recommended to use `ChangeNotifier` anywhere else
  /// (reference: https://riverpod.dev/docs/concepts/providers/#different-types-of-providers),
  /// `ChangeNotifier` is a forced choice with go_router.
  ///
  /// GoRouter's refreshListenable only accepts a `Listenable` object as a parameter
  /// and therefore `ChangeNotifier` is used here,
  /// whereas `StateNotifier` is not a `Listenable`, so we can't use it.
  ///
  /// Here we inject a `Ref` so that it's possible to exploit `ref.listen()` to
  /// notify GoRouter that something's changed in our providers.
  ///
  /// Note how we're forced to explicitly call `notifyListeners()`
  /// to make this work.
  RouterNotifier(this._ref) {
    _ref.listen<User?>(
      userProvider,
      (_, __) => notifyListeners(),
    );
  }
}
