import 'package:flutterfloor/floor_database/database/app_database.dart';
import 'package:get/get.dart';

import '../floor_database/entity/employee_entity.dart';

class Registercontroller {
  final AppDatabase database;

  Registercontroller({required this.database});

  RxString name = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString uid = "".obs; // username
  RxString password = "".obs;
  
  var isNameValid = true.obs;
  var isEmailValid = true.obs;
  var isPhoneValid = true.obs;
  var isUidValid = true.obs;
  var isPasswordValid = true.obs;

  // RxBool for password visibility
  var isPasswordVisible = false.obs;

  // Validate the user input fields
  bool validateUser() {
    // Validate Name (Must not be empty)
    isNameValid.value = name.value.isNotEmpty;

    // to check the email
    isEmailValid.value =
        RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.value);

    // to check entered length of phone number is 10 or not
    isPhoneValid.value = phone.value.isNotEmpty && phone.value.length == 10;

    // to check uid is not empty and length is greater than 6
    isUidValid.value = uid.value.isNotEmpty && uid.value.length >= 6;

    // to check password is not empty and length is greater than 6
    isPasswordValid.value =
        password.value.isNotEmpty && password.value.length >= 6;

    return isNameValid.value &&
        isEmailValid.value &&
        isPhoneValid.value &&
        isUidValid.value &&
        isPasswordValid.value;
  }

  // Register the employee into the database
  Future<void> registerEmployee() async {
    try {
      final employee = EmployeeEntity(
        name: name.value,
        email: email.value,
        phone: phone.value,
        password: password.value,
        uid: uid.value,
      );

      final dao = database.employeeDao;
      await dao.insertEmployee(employee);
      Get.snackbar('Success', 'Employee Registered');
    } catch (e) {
      Get.snackbar('Error', 'userID already exists');
      print('$e');
    }
  }
}