import 'package:flutterfloor/database/app_database.dart';
import 'package:flutterfloor/entity/employee_entity.dart';
import 'package:get/get.dart';

class Registercontroller {
  final AppDatabase database;

  Registercontroller({required this.database});

  RxString name = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs; 
  RxString uid = "".obs;   // username
  RxString password = "".obs;

  var isNameValid = true.obs;
  var isEmailValid = true.obs;
  var isPhoneValid = true.obs;
  var isUidValid = true.obs;
  var isPasswordValid = true.obs;
  var isPasswordVisible = false.obs; // Initially password is hidden


  // Validate the user input fields
  bool validateUser() {
    // Validate Name (Must not be empty)
    isNameValid.value = name.value.isNotEmpty;

    // Validate Email
    isEmailValid.value =
        RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.value);

    // Validate Phone
    isPhoneValid.value = phone.value.isNotEmpty && phone.value.length == 10;

    // Validate Username
    isUidValid.value = uid.value.isNotEmpty && uid.value.length >= 6;

    // Validate Password
    isPasswordValid.value = password.value.isNotEmpty && password.value.length >= 6;

    return isNameValid.value && isEmailValid.value && isPhoneValid.value && isUidValid.value && isPasswordValid.value;
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
      Get.snackbar('Error', 'Failed to register employee: $e');
    }
  }
}
