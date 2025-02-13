import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../dao/underemployeedao.dart';
import '../database/app_database.dart';
import '../entity/underemployee_entity.dart';

class Updatecontroller extends GetxController {
  final AppDatabase database;
  RxString selectedDesignation = ''.obs;
  Rx<Uint8List?> selectedImage = Rx<Uint8List?>(null); // Store the selected image

  var underemployees = <UnderemployeeEntity>[].obs;

  Updatecontroller({required this.database});

  // Fetch underemployees by employeeId
  Future<void> fetchUnderemployees(int employeeId) async {
    final List<UnderemployeeEntity> updatedList = await database
        .underemployeedao
        .findUnderemployeesByEmployeeId(employeeId);
    underemployees.value = updatedList;
  }

  // Update underemployee
  Future<void> updateUnderemployee(UnderemployeeEntity underemployee) async {
    try {
      await database.underemployeedao.updateUnderemployee(underemployee);
      fetchUnderemployees(underemployee.employeeId);
      Get.snackbar('Success', 'Employee updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update employee');
      print(e);
    }
  }

  // Show dialog for updating underemployee
  void showUpdateUnderemployeeDialog(
    BuildContext context,
    UnderemployeeEntity underemployee,
    Underemployeedao dao,
  ) {
    final TextEditingController nameController =
        TextEditingController(text: underemployee.name);
    final TextEditingController emailController =
        TextEditingController(text: underemployee.email);
    final TextEditingController phoneController =
        TextEditingController(text: underemployee.phone);

    // List of possible designations
    final List<String> designations = [
      'Manager',
      'Developer',
      'Deployment',
      'Tester',
      'HR'
    ];

    // Set the selected designation to the current underemployee designation
    selectedDesignation.value = underemployee.designation;

    final ImagePicker _picker = ImagePicker();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Member Information'),
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

              // Reactive DropdownButton for designation
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

              // Show the selected image or a default icon
              selectedImage.value != null
                  ? Image.memory(
                      selectedImage.value!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.person_2_sharp,
                      size: 100,
                      color: Colors.grey,
                    ),

              // Button to pick a new photo
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // to pick image from the gallery
                      final XFile? pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery);

                      if (pickedFile != null) {
                        // Convert the picked image to bytes
                        final imageFile = File(pickedFile.path);
                        final bytes = await imageFile.readAsBytes();
                        selectedImage.value = bytes;
                      }
                    },
                    child: Center(
                      child: Text('Pick a Photo'),
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
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty &&
                    selectedDesignation.value.isNotEmpty) {
                  var updatedUnderemployee = UnderemployeeEntity(
                    id: underemployee.id,
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    employeeId: underemployee.employeeId,
                    designation: selectedDesignation.value,
                    photo: selectedImage.value, // Save the photo as bytes
                  );

                  // Update the underemployee in the database
                  await dao.updateUnderemployee(updatedUnderemployee);

                  // Update the observable list
                  final index = underemployees.indexWhere(
                      (element) => element.id == updatedUnderemployee.id);
                  if (index != -1) {
                    underemployees[index] = updatedUnderemployee;
                  }

                  Get.snackbar('Success', 'Employee updated');
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar('Error', 'Please fill in all fields');
                }
              },
              child: Text('Update Member'),
            ),
          ],
        );
      },
    );
  }
}