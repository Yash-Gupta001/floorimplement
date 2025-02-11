import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutterfloor/dao/employeedao.dart';
import 'package:flutterfloor/dao/underemployeedao.dart';  
import 'package:flutterfloor/entity/employee_entity.dart';
import 'package:flutterfloor/entity/underemployee_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';  

@Database(version: 1, entities: [UnderemployeeEntity,EmployeeEntity])
abstract class AppDatabase extends FloorDatabase {
  EmployeeDao get employeeDao;
  Underemployeedao get underemployeedao;
}

// flutter packages pub run build_runner build
