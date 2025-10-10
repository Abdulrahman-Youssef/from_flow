import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_flow/core/data/constant/Deliveries.dart';
import 'package:form_flow/models/supplier_data.dart';
import 'package:form_flow/models/trip_data.dart';
import 'package:form_flow/screens/home_screen.dart';
import 'package:get/get.dart';
import 'app_state.dart';
import 'models/shipment_model.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  Get.put(AppController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Supply Chain Manager',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF1E3A8A, {
          50: Color(0xFFEFF6FF),
          100: Color(0xFFDBEAFE),
          200: Color(0xFFBFDBFE),
          300: Color(0xFF93C5FD),
          400: Color(0xFF60A5FA),
          500: Color(0xFF3B82F6),
          600: Color(0xFF2563EB),
          700: Color(0xFF1D4ED8),
          800: Color(0xFF1E40AF),
          900: Color(0xFF1E3A8A),
        }),
        primaryColor: Color(0xFF1E3A8A),
        scaffoldBackgroundColor: Color(0xFFF9FAFB),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 4,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF1E3A8A), width: 2),
          ),
        ),
      ),
      home: GetX<AppController>(
        builder: (controller) {
          return controller.isLoggedIn.value
              // ? DashboardScreen()
              ? HomeScreen(
                  // deliveries: homeScreenList,
                  onDeliveryTap: (SupplyDeliveryData p1) {},
                  onAddNewDelivery: () {},
                )
              : LoginScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
