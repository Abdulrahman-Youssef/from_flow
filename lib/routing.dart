// app_routes.dart
import 'package:form_flow/core/bindings/dashboard_binding.dart';
import 'package:form_flow/core/bindings/home_page_binding.dart';
import 'package:form_flow/core/bindings/login_binding.dart';
import 'package:form_flow/core/bindings/splash_binding.dart';
import 'package:form_flow/core/data/constant/app_routes.dart';
import 'package:form_flow/core/middleware/auth_middleware.dart';
import 'package:form_flow/screens/Dashboard/dashboard_screen.dart';
import 'package:form_flow/screens/login/login_screen.dart';
import 'package:form_flow/screens/splash/splash_screen.dart';
import 'package:get/get.dart';
import 'screens/home/home_screen.dart';

class MyRouting {
  // Route names
  // Route pages
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
      middlewares: [AuthMiddleware()],
      // binding: HomeBinding(), // Optional: for dependency injection
    ),
    GetPage(
      name: AppRoutes.homePage,
      page: () => HomeScreen(onDeliveryTap: (s) {}, onAddNewDelivery: () {}),
      transition: Transition.noTransition,
      binding: HomePageBinding(),// Optional: customize transition
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
      // middlewares: [AuthMiddleware()],
      transition: Transition.native, // Optional: customize transition
    ),
  ];
}
