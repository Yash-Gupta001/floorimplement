import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  // Load theme preference from SharedPreferences
  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
  }

  // Toggle theme mode and save it to SharedPreferences
  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = !isDarkMode.value;
    prefs.setBool('isDarkMode', isDarkMode.value);
  }
}
