import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
                // Check if UID exists, then fetch user data
                FutureBuilder<String?>(
                  future: _getUidFromSecureStorage(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data != null) {
                      // If UID is available, fetch employee details
                      final uid = snapshot.data!;
                      return FutureBuilder<EmployeeEntity?>(
                        future: dao.findEmployeeByUid(uid),
                        builder: (context, employeeSnapshot) {
                          if (employeeSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (employeeSnapshot.hasError) {
                            return Text('Error: ${employeeSnapshot.error}');
                          } else if (employeeSnapshot.hasData &&
                              employeeSnapshot.data != null) {
                            var employee = employeeSnapshot.data;
                            return Center(
                              child: Column(
                                children: [
                                  Text('Employee Details\n',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple)),
                                  SizedBox(height: 8),
                                  Text('Employee ID: ${employee?.id}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700])),
                                  SizedBox(height: 4),
                                  Text('Employee Name: ${employee?.name}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700])),
                                  SizedBox(height: 4),
                                  Text('Employee Email: ${employee?.email}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700])),
                                  SizedBox(height: 4),
                                  Text('Employee Phone: ${employee?.phone}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700])),
                                  SizedBox(height: 20),
                                  CustomButton(
                                    text: 'Get Employee Details',
                                    onPressed: () {
                                      // navigate to the employee details
                                      Get.to(() =>
                                          Showunderemployee(employee!.id!));
                                    },
                                  ),
                                  SizedBox(height: 13),
                                  CustomButton(
                                    text: 'Add Employee',
                                    onPressed: () {
                                      controller.showAddUnderemployeeDialog(
                                          context, underdao, employee!.id!);
                                    },
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                'No employee found',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Schyler'),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No data available!',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.red,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Schyler'),
                        ),
                      );
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
          onPressed: () async {
            // Show logout confirmation dialog
            Get.dialog(AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // Clear UID from secure storage
                    final FlutterSecureStorage storage = FlutterSecureStorage();
                    await storage.delete(
                        key:
                            'uid'); // this will remove uid after pressing logout
                    Get.offAll(() => Login());
                  },
                  child: const Text('Logout'),
                ),
              ],
            ));
          },
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          tooltip: 'Logout',
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

  // Fetch UID from secure storage
  Future<String?> _getUidFromSecureStorage() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: 'uid');
  }
}
