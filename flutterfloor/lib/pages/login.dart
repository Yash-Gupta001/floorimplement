import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/employee_login_controller.dart';
import '../database/app_database.dart';
import '../ui_component/custom_appbar.dart';
import '../ui_component/custom_button.dart';
import 'Home.dart';
import 'Register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final Logincontroller logincontroller =
        Get.put(Logincontroller(database: Get.find<AppDatabase>()));

    // Check if the user is already logged in
    logincontroller.checkIfUserIsLoggedIn().then((isLoggedIn) {
      if (isLoggedIn) {
        // If already logged in, navigate to the Home screen
        Get.offAll(Home());
      }
    });

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
                TextField(
                  onChanged: (value) {
                    logincontroller.uid.value = value;
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
                    logincontroller.password.value = value;
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
                    if (logincontroller.validateUser()) {
                      bool isAuthenticated = await logincontroller.authenticateUser();

                      if (isAuthenticated) {
                        Get.offAll(Home());
                      } else {
                        // If authentication fails
                        Get.snackbar('Error', 'Invalid username or password');
                      }
                    } else {
                      // If validation fails
                      Get.snackbar('Error', 'Please enter a valid username and password');
                    }
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
