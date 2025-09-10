import 'package:flutter/material.dart';
import 'package:form_flow/core/data/constant/app_colors.dart';
import 'package:form_flow/view/form_screen/form_screen.dart';
import 'package:form_flow/view/form_screen/widgets/drop_down_menu.dart';
import 'package:form_flow/view/login_screen/login_screen.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.mainColor,
      ),
      home: LoginScreen(),
    );
  }
}
