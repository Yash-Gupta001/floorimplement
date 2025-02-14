import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'database/app_database.dart';
import 'pages/Home.dart';
import 'pages/Register.dart';
import 'pages/login.dart';

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
      // theme: ThemeData(
      //   useMaterial3: true,
      //   colorSchemeSeed: const Color.fromRGBO(86, 80, 14, 171),
      // ),
      // darkTheme: ThemeData(
      //   useMaterial3: true,
      //   brightness: Brightness.dark,
      //   colorSchemeSeed: const Color.fromRGBO(86, 80, 14, 171),
      // ),
      // themeMode: ThemeMode.dark,
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