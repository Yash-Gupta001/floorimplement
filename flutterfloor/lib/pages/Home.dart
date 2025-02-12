import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import '../controller/insertcontroller.dart';
import '../controller/logincontroller.dart';
import '../database/app_database.dart';
import '../entity/employee_entity.dart';
import '../ui_component/appbar.dart';
import '../ui_component/button.dart';
import 'showunderemployee.dart';
import 'login.dart';

class Home extends StatelessWidget {
  final Insertcontroller controller =
      Get.put(Insertcontroller(database: Get.find()));
  final Logincontroller logincontroller =
      Get.put(Logincontroller(database: Get.find<AppDatabase>()));

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final database = Get.find<AppDatabase>();
    final dao = database.employeeDao;
    final underdao = database.underemployeedao;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(title: 'User details', leading: false),
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(
            content: Text('Press again to exit'),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),

                // Using FutureBuilder to fetch employee data
                FutureBuilder<EmployeeEntity?>(
                  future: dao.findEmployeeByUid(logincontroller.uid.value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      var employee = snapshot.data;
                      if (employee != null) {
                        // Employee data found, you can now safely access `employee`
                        return Center(
                          child: Column(
                            children: [
                              Text('Employee Details\n',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightGreenAccent)),
                              SizedBox(height: 8),
                              Text('Employee ID: ${employee.id}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700])),
                              SizedBox(height: 4),
                              Text('Employee Name: ${employee.name}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700])),
                              SizedBox(height: 4),
                              Text('Employee Email: ${employee.email}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700])),
                              SizedBox(height: 4),
                              Text('Employee Phone: ${employee.phone}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700])),

                              SizedBox(height: 20),

                              // to view the team details
                              CustomButton(
                                text: 'Get Team Details',
                                onPressed: () {
                                  // navigate to the team details
                                  Get.to(() => Showunderemployee(employee.id!));
                                },
                              ),

                              SizedBox(height: 13),

                              // Custom Button to add a team member
                              CustomButton(
                                text: 'Add Team Member',
                                onPressed: () {
                                  controller.showAddUnderemployeeDialog(
                                      context, underdao, employee.id!);
                                },
                              ),
                              
                            ],
                          ),
                        );
                      } else {
                        return Text('No employee found');
                      }
                    } else {
                      return Text('No data available');
                    }
                  },
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),

        // Action Button to log out
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'logout',
          onPressed: () {
            Get.dialog(AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.offAll(() => Login());
                  },
                  child: const Text('Logout'),
                ),
              ],
            ));
            //Get.offAll(() => Login());
          },
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          tooltip: 'Logout',
          // ignore: deprecated_member_use
          splashColor: Colors.white.withOpacity(0.3),
          icon: Icon(
            Icons.logout,
            color: Colors.white,
            size: 30, // Icon size
          ),
          label: Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
