import 'package:floor/floor.dart';

@Entity(tableName: 'underemployee_entity')
class UnderemployeeEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final String name;
  final String email;
  final String phone;


  UnderemployeeEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  String toString() {
    return 'Employee(id: $id, name: $name)';
  } 
}