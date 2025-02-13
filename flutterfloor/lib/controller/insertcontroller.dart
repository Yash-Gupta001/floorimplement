import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

import '../dao/underemployeedao.dart';
import '../database/app_database.dart';
import '../entity/underemployee_entity.dart';

class Insertcontroller extends GetxController {
  final AppDatabase database;

  Insertcontroller({required this.database});

  // Rx variables for the underemployee fields
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString selectedDesignation = ''.obs;

  // Store the image as bytes 
  Rx<Uint8List?> photo = Rx<Uint8List?>(null);

  var isFormValid = true.obs;

  // Validation for the underemployee fields
  bool validateForm() {
    isFormValid.value = name.value.isNotEmpty &&
        email.value.isNotEmpty &&
        phone.value.isNotEmpty &&
        selectedDesignation.value.isNotEmpty;
    return isFormValid.value;
  }

  // Insert the underemployee into the database
  Future<void> insertUnderemployee(int employeeId) async {
    if (validateForm()) {
      final underemployee = UnderemployeeEntity(
        name: name.value,
        email: email.value,
        phone: phone.value,
        employeeId: employeeId, // Dynamically set the employeeId
        designation: selectedDesignation.value,
        photo: photo.value,
      );

      try {
        await database.underemployeedao.insertUnderemployee(underemployee);
        Get.snackbar('Success', 'Employee added');
      } catch (e) {
        Get.snackbar('Error', 'Failed to add Employee');
        print(e);
      }
    } else {
      Get.snackbar('Validation Error', 'Please fill all the fields correctly');
    }
  }

  // Function to show the dialog for adding a new employee
  void showAddUnderemployeeDialog(
  BuildContext context, Underemployeedao dao, int employeeId) {
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // List of designations
  final List<String> designations = [
    'Manager',
    'Developer',
    'Deployment',
    'Tester',
    'HR'
  ];

  final ImagePicker _picker = ImagePicker();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: Text('Add Employee'),
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

                // DropdownButton for designation
                Obx(() {
                  return DropdownButton<String>(
                    value: selectedDesignation.value.isNotEmpty
                        ? selectedDesignation.value
                        : null,
                    hint: Text('Select Designation'),
                    onChanged: (String? newDesignation) {
                      if (newDesignation != null) {
                        selectedDesignation.value = newDesignation;
                      }
                    },
                    items: designations.map((String designation) {
                      return DropdownMenuItem<String>(
                        value: designation,
                        child: Text(designation),
                      );
                    }).toList(),
                  );
                }),

                // to select a photo
                Row(
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final XFile? pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);
                      
                          if (pickedFile != null) {
                            // Convert the picked image to bytes (Uint8List)
                            final imageFile = File(pickedFile.path);
                            final bytes = await imageFile.readAsBytes();
                            photo.value = bytes; 
                          }
                        },
                        child: Center(child: Text('employee photo')),
                      ),
                    ),
                  ],
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
                      phoneController.text.isNotEmpty &&
                      selectedDesignation.value.isNotEmpty) {
                    var underemployee = UnderemployeeEntity(
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      employeeId: employeeId, // Pass the logged-in employee's ID
                      designation: selectedDesignation.value,
                      photo: photo.value,
                    );
                    await dao.insertUnderemployee(underemployee);
                    Get.snackbar('Success', 'Employee added');
                    Navigator.of(context).pop();
                  } else {
                    Get.snackbar('Error', 'Please fill in all fields');
                  }
                },
                child: Text('Add Employee'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
