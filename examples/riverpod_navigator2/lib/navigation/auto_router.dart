import 'package:auto_route/annotations.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';


@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      page: HomeScreen,
    ),
    AutoRoute(
      path: '/login',
      page: LoginScreen,
    ),
  ],
)
class $AppRouter {}
