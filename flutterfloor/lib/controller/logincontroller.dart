import 'package:flutterfloor/database/app_database.dart';
import 'package:get/get.dart';

class Logincontroller extends GetxController {
  final AppDatabase database;
  Logincontroller({required this.database});

  RxString uid = ''.obs;
  RxString password = ''.obs;

  var isUidValid = true.obs;
  var isPasswordValid = true.obs;

  bool validateUser() {
    // Validate Username
    isUidValid.value = uid.value.isNotEmpty && uid.value.length >= 6;

    // Validate Password
    isPasswordValid.value =
        password.value.isNotEmpty && password.value.length >= 6;

    return isUidValid.value && isPasswordValid.value;
  }

  // authenticate ther user exist or not in database if exist then navigate to home page
  Future<bool> authenticateUser() async {
    final dao = database.employeeDao;
    final user =
        await dao.findEmployeeByUidAndPassword(uid.value, password.value);
    if (user != null) {
      return true;
    } else {
      Get.snackbar('Error', 'Invalid Username or Password');
      return false;
    }
  }
}