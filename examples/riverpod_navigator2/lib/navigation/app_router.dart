import 'package:flutter/cupertino.dart';
import '../providers/app_state_manager.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AppRouter extends RouterDelegate
    with PopNavigatorRouterDelegateMixin, ChangeNotifier {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;

  AppRouter({
    required this.appStateManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
  }
  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isLoggedIn) LoginScreen.page(),
        if (appStateManager.isLoggedIn) HomeScreen.page(),
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async => {};
}
