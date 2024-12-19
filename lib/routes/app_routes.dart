import 'package:get/get.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../middlewares/auth_middleware.dart';

class AppRoutes {
  static const String INITIAL = '/login';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String HOME = '/home';

  static final routes = [
    GetPage(
      name: LOGIN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: REGISTER,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: HOME,
      page: () => HomeScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}