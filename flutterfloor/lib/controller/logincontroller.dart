import 'package:flutterfloor/database/app_database.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Logincontroller extends GetxController {
  final AppDatabase database;
  Logincontroller({required this.database});

  RxString uid = ''.obs;
  RxString password = ''.obs;

  var isUidValid = true.obs;
  var isPasswordValid = true.obs;

  // Secure storage instance
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  bool validateUser() {
    // Validate Username
    isUidValid.value = uid.value.isNotEmpty && uid.value.length >= 6;

    // Validate Password
    isPasswordValid.value =
        password.value.isNotEmpty && password.value.length >= 6;

    return isUidValid.value && isPasswordValid.value;
  }

  // authenticate the user and store credentials if successful
  Future<bool> authenticateUser() async {
    final dao = database.employeeDao;
    final user =
        await dao.findEmployeeByUidAndPassword(uid.value, password.value);
    if (user != null) {
      // Save the user's UID securely to keep them logged in
      await _secureStorage.write(key: 'uid', value: user.uid);

      return true;
    } else {
      Get.snackbar('Error', 'Invalid Username or Password');
      return false;
    }
  }

  // Check if user is already logged in by checking secure storage
  Future<bool> checkIfUserIsLoggedIn() async {
    final storedUid = await _secureStorage.read(key: 'uid');
    if (storedUid != null) {
      // You can fetch additional data for the user if needed
      return true;
    }
    return false;
  }
}
