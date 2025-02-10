import 'package:flutter/material.dart';
import 'package:flutterfloor/ui_component/appbar.dart';
import 'package:flutterfloor/database/app_database.dart';
import 'package:flutterfloor/entity/employee_entity.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Showallemployee extends StatefulWidget {
  const Showallemployee({super.key});

  @override
  State<Showallemployee> createState() => ShowallemployeeState();
}

class ShowallemployeeState extends State<Showallemployee> {
  @override
  Widget build(BuildContext context) {
    final database = Get.find<AppDatabase>();
    final dao = database.employeeDao;

    return Scaffold(
      appBar: CustomAppbar(title: 'All Employees', leading: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<EmployeeEntity>>(
                future: dao.printAllEmployees(), // Fetch all employees from DB
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<EmployeeEntity> employees = snapshot.data!;

                    return ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        EmployeeEntity employee = employees[index];

                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.23,
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  await dao.deleteEmployee(employee);
                                  setState(() {});
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),

                              // SlidableAction(
                              //   onPressed: (context) async {
                              //     await dao.updateEmployee(employee);
                              //     setState(() {});
                              //   },
                              //   backgroundColor: Colors.lightGreenAccent,
                              //   foregroundColor: Colors.white,
                              //   icon: Icons.edit,
                              //   label: 'Update',
                              // ),
                            ],
                          ),
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(employee.name),
                              subtitle: Text(
                                  'Employee Email: ${employee.email}\n'
                                  'Employee ID: ${employee.id}\n'
                                  'Employee User Name: ${employee.uid}\n'
                                  'Employee Phone number: ${employee.phone}'),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No employees found.'));
                  }
                },
              ),
            ),
            // Button to delete all employees at the bottom
            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                // Show confirmation dialog before deleting all employees
                Get.dialog(
                  AlertDialog(
                    title: Text('Delete All Employees'),
                    content:
                        Text('Are you sure you want to delete all employees?'),
                    actions: [
                      // Cancel button
                      TextButton(
                        onPressed: () {
                          Get.back(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      // Delete button
                      TextButton(
                        onPressed: () async {
                          await dao
                              .deleteAllEmployees(); 
                          setState(() {}); 
                          Get.back(); 
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              // ignore: sort_child_properties_last
              child: Text(
                'Delete All Employees',
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white, 
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, 
                minimumSize: Size(
                    double.infinity, 50), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25), 
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 15), 
                side: BorderSide(
                    color: Colors.redAccent,
                    width: 2), 
              ),
            )
          ],
        ),
      ),
    );
  }
}