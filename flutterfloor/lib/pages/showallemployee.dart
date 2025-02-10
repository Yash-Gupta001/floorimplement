import 'package:flutter/material.dart';
import 'package:flutterfloor/entity/underemployee_entity.dart';
import 'package:flutterfloor/ui_component/appbar.dart';
import 'package:flutterfloor/database/app_database.dart';
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
    final dao = database.underemployeedao;

    return Scaffold(
      appBar: CustomAppbar(title: 'All Team Members', leading: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<UnderemployeeEntity>>(
                future: dao.printAllUnderemployees(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<UnderemployeeEntity> underemployees = snapshot.data!;

                    return ListView.builder(
                      itemCount: underemployees.length,
                      itemBuilder: (context, index) {
                        UnderemployeeEntity employee = underemployees[index];

                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.23,
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  await dao.deleteUnderemployee(employee);
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
                    title: Text('Delete All Members'),
                    content:
                        Text('Are you sure you want to delete all members?'),
                    actions: [
                      // Cancel button
                      TextButton(
                        onPressed: () {
                          Get.back(); 
                        },
                        child: Text('Cancel'),
                      ),
                      // Delete button
                      TextButton(
                        onPressed: () async {
                          await dao
                              .deleteAllUnderemployees(); 
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
                'Delete All Members',
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