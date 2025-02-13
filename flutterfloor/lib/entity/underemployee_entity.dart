import 'dart:typed_data';
import 'package:floor/floor.dart';
import 'employee_entity.dart';

@Entity(
  tableName: 'underemployee_entity',
  foreignKeys: [
    ForeignKey(
      childColumns: ['employeeId'],
      parentColumns: ['id'],
      entity: EmployeeEntity,
    )
  ],
)
class UnderemployeeEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final String name;
  final String email;
  final String phone;
  final String designation;
  final Uint8List? photo; // binary data to store a image
  

  @ColumnInfo(name: 'employeeId')
  final int employeeId; // Foreign key reference to EmployeeEntity



  UnderemployeeEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.employeeId,
    required this.designation,
    required this.photo,  // the photo is optional 
  });

  @override
  String toString() {
    return 'Underemployee(id: $id, name: $name, employeeId: $employeeId, designation: $designation)';
  }
}
