import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dao/underemployeedao.dart';
import '../database/app_database.dart';
import '../entity/underemployee_entity.dart';

class Updatecontroller extends GetxController {
  final AppDatabase database;

  // Observable list of underemployees
  var underemployees = <UnderemployeeEntity>[].obs;

  Updatecontroller({required this.database});

  // Fetch underemployees by employeeId and update the observable list
  Future<void> fetchUnderemployees(int employeeId) async {
    final List<UnderemployeeEntity> updatedList = await database.underemployeedao.findUnderemployeesByEmployeeId(employeeId);
    underemployees.value = updatedList; // This will trigger UI updates automatically
  }

  // Update underemployee
  Future<void> updateUnderemployee(UnderemployeeEntity underemployee) async {
    try {
      await database.underemployeedao.updateUnderemployee(underemployee);
      fetchUnderemployees(underemployee.employeeId); // Re-fetch the updated list
      Get.snackbar('Success', 'Underemployee updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update underemployee: $e');
    }
  }

  // Show dialog for updating underemployee
  void showUpdateUnderemployeeDialog(
    BuildContext context,
    UnderemployeeEntity underemployee,
    Underemployeedao dao,
  ) {
    final TextEditingController nameController = TextEditingController(text: underemployee.name);
    final TextEditingController emailController = TextEditingController(text: underemployee.email);
    final TextEditingController phoneController = TextEditingController(text: underemployee.phone);

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
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  var updatedUnderemployee = UnderemployeeEntity(
                    id: underemployee.id,
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    employeeId: underemployee.employeeId,
                  );
                  // Update the underemployee in the database
                  await dao.updateUnderemployee(updatedUnderemployee);
                  fetchUnderemployees(updatedUnderemployee.employeeId); // Re-fetch the list
                  Get.snackbar('Success', 'Underemployee updated');
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
