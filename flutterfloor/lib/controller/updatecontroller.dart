import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dao/underemployeedao.dart';
import '../database/app_database.dart';
import '../entity/underemployee_entity.dart';

class Updatecontroller extends GetxController {
  final AppDatabase database;
  RxString selectedDesignation = ''.obs;

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
      Get.snackbar('Success', 'employee updated');
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
      'Deployement',
      'Tester',
      'HR'
    ];

    // Set the selected designation to the current underemployee designation
    selectedDesignation.value = underemployee.designation;

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

              // DropdownButton for designation
              DropdownButton<String>(
                value: selectedDesignation.value.isNotEmpty
                    ? selectedDesignation.value
                    : null,
                hint: Text('Select Designation'),
                onChanged: (String? newDesignation) {
                  if (newDesignation != null) {
                    selectedDesignation.value =
                        newDesignation; // Update selectedDesignation
                  }
                },
                items: designations.map((String designation) {
                  return DropdownMenuItem<String>(
                    value: designation,
                    child: Text(designation),
                  );
                }).toList(),
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
                    designation: selectedDesignation
                        .value, // Use selected designation here
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
