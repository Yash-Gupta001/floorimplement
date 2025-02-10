import 'package:flutter/material.dart';
import 'package:flutterfloor/controller/registercontroller.dart';
import 'package:flutterfloor/ui_component/appbar.dart';
import 'package:flutterfloor/ui_component/button.dart';
import 'package:get/get.dart';
import 'package:flutterfloor/database/app_database.dart';

class Register extends StatelessWidget {
  final Registercontroller controller =
      Get.put(Registercontroller(database: Get.find<AppDatabase>()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Register', leading: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name TextField
              _buildTextField(
                label: "Name",
                controller: controller.name,
                isValid: controller.isNameValid,
                onChanged: (text) {
                  controller.name.value = text;
                },
              ),

              // Email TextField
              _buildTextField(
                label: "Email",
                controller: controller.email,
                isValid: controller.isEmailValid,
                onChanged: (text) {
                  controller.email.value = text;
                },
              ),

              // Phone TextField
              _buildTextField(
                label: "Phone",
                controller: controller.phone,
                isValid: controller.isPhoneValid,
                keyboardType: TextInputType.phone, // This ensures numeric keyboard appears
                onChanged: (text) {
                  controller.phone.value = text;
                },
              ),

              // Username TextField
              _buildTextField(
                label: "Username",
                controller: controller.uid,
                isValid: controller.isUidValid,
                onChanged: (text) {
                  controller.uid.value = text;
                },
              ),

              // Password TextField with eye icon for visibility toggle
              _buildTextField(
                label: "Password",
                controller: controller.password,
                isValid: controller.isPasswordValid,
                obscureText: !controller.isPasswordVisible.value, // Use RxBool for visibility
                onChanged: (text) {
                  controller.password.value = text;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    controller.isPasswordVisible.value =
                        !controller.isPasswordVisible.value;
                  },
                ),
              ),

              SizedBox(height: 20),

              // Register Button with validation check
              CustomButton(
                text: 'Register',
                onPressed: () async {
                  if (controller.validateUser()) {
                    // Call registerEmployee without passing id (it's auto-generated)
                    await controller.registerEmployee();
                    Get.snackbar('Success', 'Employee Registered');
                  } else {
                    Get.snackbar('Validation Error', 'Please fill all fields correctly');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required RxString controller,
    required RxBool isValid,
    bool obscureText = false,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text, // Default to normal keyboard
    Widget? suffixIcon, // Suffix icon to add something like an eye icon
  }) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(height: 8),
          TextField(
            onChanged: onChanged,
            obscureText: obscureText, // Whether to obscure the text (password)
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              errorText: isValid.value ? null : 'Invalid $label',
              suffixIcon: suffixIcon, // Add the eye icon here
            ),
          ),
          SizedBox(height: 16),
        ],
      );
    });
  }
}
