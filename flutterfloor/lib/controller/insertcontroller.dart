import 'package:flutter/material.dart';
import 'package:flutterfloor/dao/underemployeedao.dart';
import 'package:flutterfloor/database/app_database.dart';
import 'package:flutterfloor/entity/underemployee_entity.dart';
import 'package:get/get.dart';

class Insertcontroller extends GetxController {
  final AppDatabase database;

  Insertcontroller({required this.database});

  // You can define Rx variables for the underemployee fields
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;

  var isFormValid = true.obs;

  // Validation for the underemployee fields
  bool validateForm() {
    isFormValid.value = name.value.isNotEmpty &&
        email.value.isNotEmpty &&
        phone.value.isNotEmpty;
    return isFormValid.value;
  }

  // Insert the underemployee into the database
  Future<void> insertUnderemployee(int employeeId) async {
    if (validateForm()) {
      final underemployee = UnderemployeeEntity(
        name: name.value,
        email: email.value,
        phone: phone.value,
        employeeId: employeeId,  // Dynamically set the employeeId
      );

      try {
        await database.underemployeedao.insertUnderemployee(underemployee);
        Get.snackbar('Success', 'Member added');
      } catch (e) {
        Get.snackbar('Error', 'Failed to add member: $e');
      }
    } else {
      Get.snackbar('Validation Error', 'Please fill all the fields correctly');
    }
  }

  // Function to show the dialog for adding a new underemployee
  void showAddUnderemployeeDialog(BuildContext context, Underemployeedao dao, int employeeId) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text('Add a team member'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // Validate form data before adding underemployee
                    if (nameController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        phoneController.text.isNotEmpty) {
                      var underemployee = UnderemployeeEntity(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text, 
                        employeeId: employeeId,  // Pass the logged-in employee's ID
                      );
                      await dao.insertUnderemployee(underemployee);
                      Get.snackbar('Success', 'Member added');
                      Navigator.of(context).pop(); // Close the dialog
                    } else {
                      Get.snackbar('Error', 'Please fill in all fields');
                    }
                  },
                  child: Text('Add Team Member'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
