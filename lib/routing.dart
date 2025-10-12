// app_routes.dart
import 'package:form_flow/controller/dashboard_controller.dart';
import 'package:form_flow/core/binding/dashboard_binding.dart';
import 'package:form_flow/core/data/constant/app_routes.dart';
import 'package:form_flow/core/middleware/auth_middleware.dart';
import 'package:form_flow/models/shipment_model.dart';
import 'package:form_flow/screens/dashboard_screen.dart';
import 'package:form_flow/screens/login_screen.dart';
import 'package:get/get.dart';
import 'screens/home_screen.dart';

class MyRouting {
  // Route names
  // Route pages
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      middlewares: [AuthMiddleware()],
      // binding: HomeBinding(), // Optional: for dependency injection
    ),
    GetPage(
      name: AppRoutes.homePage,
      page: () => HomeScreen(onDeliveryTap: (s) {}, onAddNewDelivery: () {}),
      transition: Transition.noTransition, // Optional: customize transition
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.native, // Optional: customize transition
    ),
  ];
}
