import 'package:floor/floor.dart';
import 'package:flutterfloor/entity/employee_entity.dart';

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

  @ColumnInfo(name: 'employeeId')
  final int employeeId;  // Foreign key reference to EmployeeEntity

  UnderemployeeEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.employeeId, // Include the foreign key here
  });

  @override
  String toString() {
    return 'Underemployee(id: $id, name: $name, employeeId: $employeeId)';
  } 
}
