import 'package:floor/floor.dart';

@Entity(tableName: 'underemployee_entity')
class UnderemployeeEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final String name;
  final String email;
  final String phone;
  final String uid;  // username  
  final String password;

  // Modified constructor without `id` (it will be auto-generated)
  UnderemployeeEntity({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.uid,
  });

  @override
  String toString() {
    return 'Employee(id: $id, uid: $uid, name: $name)';
  } 
}