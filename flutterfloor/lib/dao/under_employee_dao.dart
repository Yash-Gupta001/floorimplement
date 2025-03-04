import 'package:floor/floor.dart';

import '../entity/underemployee_entity.dart';

@dao
abstract class Underemployeedao {

  // Search employee by name
  @Query('SELECT * FROM underemployee_entity WHERE name LIKE :query')
  Future<List<UnderemployeeEntity>> searchEmployeesByName(String query);


  @Query('SELECT * FROM underemployee_entity WHERE employeeId = :employeeId')
  Future<List<UnderemployeeEntity>> findUnderemployeesByEmployeeId(
      int employeeId);

  // query find all underemployees
  @Query('SELECT * FROM underemployee_entity')
  Future<List<UnderemployeeEntity>> findAllUnderemployees();

  // print all underemployees
  @Query('SELECT * FROM underemployee_entity')
  Future<List<UnderemployeeEntity>> printAllUnderemployees();

  // insert an underemployee
  @insert
  Future<void> insertUnderemployee(UnderemployeeEntity underemployee);

  // update an underemployee
  @update
  Future<void> updateUnderemployee(UnderemployeeEntity underemployee);

  // delete an underemployee
  @delete
  Future<void> deleteUnderemployee(UnderemployeeEntity underemployee);

  // Query to find an underemployee by their UID and password
  @Query(
      'SELECT * FROM underemployee_entity WHERE uid = :uid AND password = :password')
  Future<UnderemployeeEntity?> findUnderemployeeByUidAndPassword(
      String uid, String password);

  // Query to find an underemployee by their UID
  @Query('SELECT * FROM underemployee_entity WHERE uid = :uid')
  Future<UnderemployeeEntity?> findUnderemployeeByUid(String uid);

  // delete all underemployees from the database
  @Query('DELETE FROM underemployee_entity')
  Future<void> deleteAllUnderemployees();
}
