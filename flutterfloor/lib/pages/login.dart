import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/logincontroller.dart';
import '../database/app_database.dart';
import '../ui_component/appbar.dart';
import '../ui_component/button.dart';
import 'Home.dart';
import 'Register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final Logincontroller logincontroller =
        Get.put(Logincontroller(database: Get.find<AppDatabase>()));

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(
          title: "Login",
          leading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                // Username (UID) field
                TextField(
                  onChanged: (value) {
                    logincontroller.uid.value =
                        value; // Update UID in controller
                  },
                  decoration: InputDecoration(
                    labelText: 'Username (UID)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // Password field
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    logincontroller.password.value =
                        value; 
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                CustomButton(
                  text: "Login",
                  onPressed: () async {
                    // First, validate the user input
                    if (logincontroller.validateUser()) {
                      // Then, await the result of the authenticateUser method
                      bool isAuthenticated =
                          await logincontroller.authenticateUser();

                      if (isAuthenticated) {
                        // If authenticated, navigate to the home page
                        Get.offAll(Home());
                      } else {
                        // If authentication fails, show an error message
                        Get.snackbar('Error', 'Invalid username or password');
                      }
                    } else {
                      // If validation fails, show an error message
                      Get.snackbar('Error',
                          'Please enter a valid username and password');
                    }
                    // print('Login button pressed');
                  },
                ),
                SizedBox(height: 10),

                CustomButton(
                  text: "Register",
                  onPressed: () {
                    // Navigate to the register page
                    Get.to(Register());
                    print('Register button pressed');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
