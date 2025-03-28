import 'dart:async';
import 'dart:typed_data';
// import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/employee_dao.dart';
import '../dao/under_employee_dao.dart';
import '../entity/employee_entity.dart';
import '../entity/underemployee_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [UnderemployeeEntity,EmployeeEntity])
abstract class AppDatabase extends FloorDatabase {
  EmployeeDao get employeeDao;
  Underemployeedao get underemployeedao;
}

// flutter packages pub run build_runner build