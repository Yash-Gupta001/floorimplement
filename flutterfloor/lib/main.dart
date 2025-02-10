import 'package:flutter/material.dart';
import 'package:flutterfloor/database/app_database.dart';
import 'package:flutterfloor/pages/Home.dart';
import 'package:flutterfloor/pages/Register.dart';
import 'package:flutterfloor/pages/login.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  
  Get.put<AppDatabase>(database);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      getPages: [
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/home', page: () => Home()),
        GetPage(name: '/register', page: () =>  Register())
      ],
    );
  }
}