import 'package:flutter/material.dart';
import 'package:form_flow/screens/splash/splash_controller.dart';
import 'package:get/get.dart';

// 1. Extend GetView<SplashController>
class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. You don't need 'Get.find()' or 'Get.put()' at all.
    // The controller is automatically available as `controller`
    // (controller.onReady() is being called right now)

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}