import 'package:get/get.dart';

import '../floor_database/entity/underemployee_entity.dart';
import 'update_controller.dart';

class Searchemployeecontroller extends GetxController {
  var searchResults = <UnderemployeeEntity>[].obs;
  var searchQuery = ''.obs;
  var errorMessage = ''.obs;

  final Updatecontroller updateController;

  Searchemployeecontroller({required this.updateController});

  // Search method to filter employees by name
  void searchEmployees(String query) {
    searchQuery.value = query;
    errorMessage.value = ''; 
    if (query.isNotEmpty) {
      var results = updateController.underemployees
          .where((employee) =>employee.name.toLowerCase().startsWith(query.toLowerCase())).toList();

      if (results.isEmpty) {
        searchResults.value = <UnderemployeeEntity>[]; 
        errorMessage.value = 'No employee of this name exists'; 
      } else {
        searchResults.value = results;
      }
    } else {
      searchResults.value = updateController.underemployees; 
    }
  }
}