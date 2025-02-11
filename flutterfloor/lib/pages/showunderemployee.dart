import 'package:flutter/material.dart';
import 'package:flutterfloor/database/app_database.dart';
import 'package:flutterfloor/entity/underemployee_entity.dart';
import 'package:flutterfloor/ui_component/appbar.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Showunderemployee extends StatefulWidget {
  final int employeeId;

  const Showunderemployee(this.employeeId);

  @override
  // ignore: library_private_types_in_public_api
  _ShowunderemployeeState createState() =>
      _ShowunderemployeeState();
}

class _ShowunderemployeeState
    extends State<Showunderemployee> {
  final AppDatabase database = Get.find<AppDatabase>();

  // Variable to store the current future of underemployees
  late Future<List<UnderemployeeEntity>> futureUnderemployees;

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch underemployees based on employeeId
    futureUnderemployees = _fetchUnderemployees();
  }

  Future<List<UnderemployeeEntity>> _fetchUnderemployees() async {
    return await database.underemployeedao.findUnderemployeesByEmployeeId(widget.employeeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Team Members', leading: true),
      body: Column(
        children: [
          // FutureBuilder for the list of underemployees
          Expanded(
            child: FutureBuilder<List<UnderemployeeEntity>>(
              future: futureUnderemployees,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  var underemployees = snapshot.data;
                  return ListView.builder(
                    itemCount: underemployees?.length ?? 0,
                    itemBuilder: (context, index) {
                      var underemployee = underemployees![index];
                      
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.23,
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                // Delete underemployee from the database
                                await database.underemployeedao.deleteUnderemployee(underemployee);
                                // After deletion, re-fetch the updated data
                                setState(() {
                                  futureUnderemployees = _fetchUnderemployees();
                                });
                                // Update UI after delete
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${underemployee.name} deleted')),
                                );
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
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
                } else {
                  return const Center(child: Text('No underemployees found'));
                }
              },
            ),
          ),
          
          // Elevated Button for deleting all members
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
        
                Get.dialog(
                  AlertDialog(
                    title: const Text('Delete All Members'),
                    content: const Text('Are you sure you want to delete all members?'),
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
                          await database.underemployeedao.deleteAllUnderemployees();  
                          setState(() {
                            futureUnderemployees = _fetchUnderemployees(); 
                          });
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
                side: const BorderSide(
                  color: Colors.redAccent,
                  width: 2), 
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
    );
  }
}
