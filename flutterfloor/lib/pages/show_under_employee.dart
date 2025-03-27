import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/update_controller.dart';
import '../controller/search_employee_controller.dart';
import '../floor_database/database/app_database.dart';
import '../ui_component/custom_appbar.dart';
import '../ui_component/custom_delete_button.dart';
import '../ui_component/custom_search_bar.dart';

class Showunderemployee extends StatefulWidget {
  final int employeeId;

  const Showunderemployee(this.employeeId);

  @override
  _ShowunderemployeeState createState() => _ShowunderemployeeState();
}

class _ShowunderemployeeState extends State<Showunderemployee> {
  final Updatecontroller controller =
      Get.put(Updatecontroller(database: Get.find()));
  final Searchemployeecontroller searchController =
      Get.put(Searchemployeecontroller(updateController: Get.find()));
  final AppDatabase database = Get.find<AppDatabase>();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch underemployees when the screen loads
    controller.fetchUnderemployees(widget.employeeId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
                  FocusScope.of(context).unfocus();
                },
        child: Scaffold(
          appBar: CustomAppbar(title: 'Employee Data', leading: true),
          body: Column(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: CustomSearchBar(controller: _searchController),
              ),
        
              // List of underemployees
              Expanded(
                child: Obx(() {
                  // Search results or full list if no search results
                  final employeesToDisplay =
                      searchController.searchResults.isNotEmpty
                          ? searchController.searchResults
                          : controller.underemployees;
        
                  if (searchController.errorMessage.isNotEmpty) {
                    // Display error message if there's no employee found
                    return Center(
                      child: Text(
                        searchController.errorMessage.value,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  } else if (employeesToDisplay.isEmpty) {
                    // If no employees are available
                    return Center(
                      child: Text(
                        'No employees available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
        
                  return ListView.builder(
                    itemCount: employeesToDisplay.length,
                    itemBuilder: (context, index) {
                      var underemployee = employeesToDisplay[index];
        
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.45,
                          children: [
                            // Delete slidable button
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SlidableAction(
                                  onPressed: (context) async {
                                    // Delete underemployee from the database
                                    await database.underemployeedao
                                        .deleteUnderemployee(underemployee);
                                    controller.underemployees
                                        .remove(underemployee);
                                    // Show a snackbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                          '${underemployee.name} Deleted'
                                          )),
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
                              ),
                            ),
                            // Update employee data in the database
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SlidableAction(
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
                              ),
                            )
                          ],
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 5.0,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            title: Text(
                              underemployee.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 24,
                                letterSpacing: 1.2,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: underemployee.photo != null
                                        ? ClipRRect(
                                            child: Image.memory(
                                              underemployee.photo!,
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Icon(
                                            Icons.person_2_sharp,
                                            size: 100,
                                            color: Colors.grey.shade400,
                                          ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Employee Email: ${underemployee.email}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Employee Phone: ${underemployee.phone}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Designation: ${underemployee.designation}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      'Contact employee',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.chat,
                                          color: Colors.green,
                                          size: 28,
                                        ),
                                        onPressed: () {
                                          String phone = underemployee.phone;
                                          String whatsappUrl =
                                              "https://wa.me/$phone";
                                          launchUrl(Uri.parse(whatsappUrl));
                                        },
                                      ),
                                      SizedBox(width: 4),
                                      IconButton(
                                        icon: Icon(
                                          Icons.email,
                                          color: Colors.blue,
                                          size: 28,
                                        ),
                                        onPressed: () {
                                          String email = underemployee.email;
                                          String emailUrl = "mailto:$email";
                                          launchUrl(Uri.parse(emailUrl));
                                        },
                                      ),
                                      SizedBox(width: 4),
                                      IconButton(
                                        icon: Icon(
                                          Icons.phone,
                                          color: Colors.teal,
                                          size: 28,
                                        ),
                                        onPressed: () {
                                          String phoneNumber =
                                              underemployee.phone;
                                          String phoneUrl = "tel:$phoneNumber";
                                          launchUrl(Uri.parse(phoneUrl));
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
        
              // For deleting all Employees
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomdeleteButton(
                  text: 'Delete All Employees',
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Delete All Employees'),
                        content: const Text(
                            'Are you sure you want to delete all employees?'),
                        actions: [
                          // Cancel button
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          // Delete button
                          TextButton(
                            onPressed: () async {
                              await database.underemployeedao
                                  .deleteAllUnderemployees();
                              controller.underemployees.clear();
                              Get.back();
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}