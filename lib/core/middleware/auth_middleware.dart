// lib/core/middleware/auth_middleware.dart

import 'package:flutter/material.dart';
import 'package:form_flow/app_state.dart';
import 'package:form_flow/core/data/constant/app_routes.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  // You can override the priority to ensure it runs first
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final appController = Get.find<AppController>();

    // If the user is not logged in and tries to go to any page
    // other than the login page, redirect them to the login page.
    if (!appController.isLoggedIn.value && route != AppRoutes.login) {
      return const RouteSettings(name: AppRoutes.login);
    }

    // If the user IS logged in and tries to go to the login page,
    // send them to the home page instead.
    if (appController.isLoggedIn.value && route == AppRoutes.login) {
      return const RouteSettings(name: AppRoutes.homePage);
    }

    // If neither of the above conditions are met, do nothing.
    return null;
  }
}