import 'package:get/get.dart';
import '../entity/underemployee_entity.dart';
import '../controller/updatecontroller.dart';

class Searchemployeecontroller extends GetxController {
  var searchResults = <UnderemployeeEntity>[].obs;
  var searchQuery = ''.obs;

  final Updatecontroller updateController;

  Searchemployeecontroller({required this.updateController});

  // Search method to filter employees by name
  void searchEmployees(String query) {
  searchQuery.value = query;
  if (query.isNotEmpty) {
    var results = updateController.underemployees
        .where((employee) =>
            employee.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    searchResults.value = results;

    // If no results are found, show a message for no employees found
    if (results.isEmpty) {
      searchResults.value = [];
    }
  } else {
    searchResults.value = updateController.underemployees;
  }
}

}
