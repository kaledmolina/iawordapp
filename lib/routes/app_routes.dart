import 'package:get/get.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../middlewares/auth_middleware.dart';

class AppRoutes {
  static const String initial = '/login';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static final routes = [
    GetPage(
      name: login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: register,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
