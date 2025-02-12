import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../controller/updatecontroller.dart';
import '../database/app_database.dart';
import '../ui_component/appbar.dart';

class Showunderemployee extends StatefulWidget {
  final int employeeId;

  const Showunderemployee(this.employeeId);

  @override
  // ignore: library_private_types_in_public_api
  _ShowunderemployeeState createState() => _ShowunderemployeeState();
}

class _ShowunderemployeeState extends State<Showunderemployee> {
  final Updatecontroller controller =
      Get.put(Updatecontroller(database: Get.find()));

  final AppDatabase database = Get.find<AppDatabase>();

  @override
  void initState() {
    super.initState();
    // Fetch underemployees when the screen loads
    controller.fetchUnderemployees(widget.employeeId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(title: 'Team Members', leading: true),
        body: Column(
          children: [
            // List of underemployees using Obx
            Expanded(
              child: Obx(() {
                if (controller.underemployees.isEmpty) {
                  return const Center(child: Text('No underemployees found'));
                }
                return ListView.builder(
                  itemCount: controller.underemployees.length,
                  itemBuilder: (context, index) {
                    var underemployee = controller.underemployees[index];

                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        extentRatio: 0.38,
                        children: [
                          // Delete team member from the database
                          SlidableAction(
                            onPressed: (context) async {
                              // Delete underemployee from the database
                              await database.underemployeedao
                                  .deleteUnderemployee(underemployee);
                              // Update the observable list
                              controller.underemployees.remove(underemployee);
                              // Show a snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '${underemployee.name} Deleted')),
                              );
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                            borderRadius: BorderRadius.circular(8),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                          ),

                          // Update team member data in the database
                          SlidableAction(
                            onPressed: (context) {
                              controller.showUpdateUnderemployeeDialog(
                                context,
                                underemployee,
                                controller.database.underemployeedao,
                              );
                            },
                            backgroundColor: Colors.lightGreenAccent,
                            foregroundColor: Colors.white,
                            icon: Icons.update,
                            label: 'Update',
                            borderRadius: BorderRadius.circular(8),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                          ),
                        ],
                      ),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(underemployee.name),
                          subtitle: Text(
                            'Employee Email: ${underemployee.email}\n'
                            'Employee Phone number: ${underemployee.phone}',
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // For deleting all members
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Delete All Members'),
                      content: const Text(
                          'Are you sure you want to delete all members?'),
                      actions: [
                        // Cancel button
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Cancel'),
                        ),
                        // Delete button
                        TextButton(
                          onPressed: () async {
                            await database.underemployeedao
                                .deleteAllUnderemployees();
                            // Clear the observable list
                            controller.underemployees.clear();
                            Get.back();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                child: Text(
                  'Delete All Members',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}