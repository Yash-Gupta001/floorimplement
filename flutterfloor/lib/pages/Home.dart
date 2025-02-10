import 'package:flutter/material.dart';
import 'package:flutterfloor/controller/insertcontroller.dart';
import 'package:flutterfloor/controller/logincontroller.dart';
import 'package:flutterfloor/database/app_database.dart';
import 'package:flutterfloor/entity/employee_entity.dart';
import 'package:flutterfloor/pages/showallemployee.dart';
import 'package:flutterfloor/ui_component/appbar.dart';
import 'package:flutterfloor/ui_component/button.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final Insertcontroller controller =
      Get.put(Insertcontroller(database: Get.find()));

  final Logincontroller logincontroller = Get.put(Logincontroller(
      database: Get.find<AppDatabase>()));

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final database = Get.find<AppDatabase>();
    final dao = database.employeeDao;
    final underdao = database.underemployeedao;

    return Scaffold(

      appBar: CustomAppbar(title: 'User details', leading: false),


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            

            SizedBox(height: 20),

            // Display employee details
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
                    return Column(
                      children: [
                        Text(
                          'Employee Details\n'
                          'Employee ID: ${employee.id}\n'
                          'Employee Name: ${employee.name}\n'
                          'Employee Email: ${employee.email}\n'
                          'Employee Phone: ${employee.phone}\n'
                          'Employee User Name: ${employee.uid}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
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

            // go to show all employee page

            CustomButton(
              text: 'Get Employee Details',
              onPressed: () {
                Get.to(Showallemployee());
              },
            ),

            SizedBox(height: 13),

            // Add Employee button
            CustomButton(
              text: 'Add Employee',
              onPressed: () async {
                controller.showAddUnderemployeeDialog(context, underdao);
              },
            ),

            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}