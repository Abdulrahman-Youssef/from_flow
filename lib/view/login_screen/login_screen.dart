import 'package:flutter/material.dart';
import 'package:form_flow/core/data/constant/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.babyBlue,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 340, vertical: 150),
        decoration: BoxDecoration(
          color: AppColors.babyBlue,
        ),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.backGround,
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                height: 100,
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          "Supply Chain Manager",
                          style: TextStyle(
                              color: AppColors.backGround, fontSize: 25),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Please sign in to continue",
                            style: TextStyle(
                                fontSize: 15, color: AppColors.lightColorsNote),
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14),
                    Text(
                      "Username",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      decoration: InputDecoration(
                          fillColor: AppColors.filledTextFiled,
                          filled: true,
                          hintText: "Enter your username",
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Password",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      decoration: InputDecoration(
                          fillColor: AppColors.filledTextFiled,
                          filled: true,
                          hintText: "Enter your password",
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.mainColor)),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
