// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  EmployeeDao? _employeeDaoInstance;

  Underemployeedao? _underemployeedaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `underemployee_entity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `phone` TEXT NOT NULL, `designation` TEXT NOT NULL, `photo` BLOB, `employeeId` INTEGER NOT NULL, FOREIGN KEY (`employeeId`) REFERENCES `employee_entity` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `employee_entity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `phone` TEXT NOT NULL, `uid` TEXT NOT NULL, `password` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  EmployeeDao get employeeDao {
    return _employeeDaoInstance ??= _$EmployeeDao(database, changeListener);
  }

  @override
  Underemployeedao get underemployeedao {
    return _underemployeedaoInstance ??=
        _$Underemployeedao(database, changeListener);
  }
}

class _$EmployeeDao extends EmployeeDao {
  _$EmployeeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _employeeEntityInsertionAdapter = InsertionAdapter(
            database,
            'employee_entity',
            (EmployeeEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'uid': item.uid,
                  'password': item.password
                }),
        _employeeEntityUpdateAdapter = UpdateAdapter(
            database,
            'employee_entity',
            ['id'],
            (EmployeeEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'uid': item.uid,
                  'password': item.password
                }),
        _employeeEntityDeletionAdapter = DeletionAdapter(
            database,
            'employee_entity',
            ['id'],
            (EmployeeEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'uid': item.uid,
                  'password': item.password
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<EmployeeEntity> _employeeEntityInsertionAdapter;

  final UpdateAdapter<EmployeeEntity> _employeeEntityUpdateAdapter;

  final DeletionAdapter<EmployeeEntity> _employeeEntityDeletionAdapter;

  @override
  Future<List<UnderemployeeEntity>> findUnderemployeesByEmployeeId(
      int employeeId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM underemployee_entity WHERE employeeId = ?1',
        mapper: (Map<String, Object?> row) => UnderemployeeEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            employeeId: row['employeeId'] as int,
            designation: row['designation'] as String,
            photo: row['photo'] as Uint8List?),
        arguments: [employeeId]);
  }

  @override
  Future<List<EmployeeEntity>> findAllEmployees() async {
    return _queryAdapter.queryList('SELECT * FROM employee_entity',
        mapper: (Map<String, Object?> row) => EmployeeEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            password: row['password'] as String,
            uid: row['uid'] as String));
  }

  @override
  Future<List<EmployeeEntity>> printAllEmployees() async {
    return _queryAdapter.queryList('SELECT * FROM employee_entity',
        mapper: (Map<String, Object?> row) => EmployeeEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            password: row['password'] as String,
            uid: row['uid'] as String));
  }

  @override
  Future<EmployeeEntity?> findEmployeeByUidAndPassword(
    String uid,
    String password,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM employee_entity WHERE uid = ?1 AND password = ?2',
        mapper: (Map<String, Object?> row) => EmployeeEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            password: row['password'] as String,
            uid: row['uid'] as String),
        arguments: [uid, password]);
  }

  @override
  Future<EmployeeEntity?> findEmployeeByUid(String uid) async {
    return _queryAdapter.query('SELECT * FROM employee_entity WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => EmployeeEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            password: row['password'] as String,
            uid: row['uid'] as String),
        arguments: [uid]);
  }

  @override
  Future<void> deleteAllEmployees() async {
    await _queryAdapter.queryNoReturn('DELETE FROM employee_entity');
  }

  @override
  Future<void> insertEmployee(EmployeeEntity employee) async {
    await _employeeEntityInsertionAdapter.insert(
        employee, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEmployee(EmployeeEntity employee) async {
    await _employeeEntityUpdateAdapter.update(
        employee, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEmployee(EmployeeEntity employee) async {
    await _employeeEntityDeletionAdapter.delete(employee);
  }
}

class _$Underemployeedao extends Underemployeedao {
  _$Underemployeedao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _underemployeeEntityInsertionAdapter = InsertionAdapter(
            database,
            'underemployee_entity',
            (UnderemployeeEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'designation': item.designation,
                  'photo': item.photo,
                  'employeeId': item.employeeId
                }),
        _underemployeeEntityUpdateAdapter = UpdateAdapter(
            database,
            'underemployee_entity',
            ['id'],
            (UnderemployeeEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'designation': item.designation,
                  'photo': item.photo,
                  'employeeId': item.employeeId
                }),
        _underemployeeEntityDeletionAdapter = DeletionAdapter(
            database,
            'underemployee_entity',
            ['id'],
            (UnderemployeeEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'designation': item.designation,
                  'photo': item.photo,
                  'employeeId': item.employeeId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UnderemployeeEntity>
      _underemployeeEntityInsertionAdapter;

  final UpdateAdapter<UnderemployeeEntity> _underemployeeEntityUpdateAdapter;

  final DeletionAdapter<UnderemployeeEntity>
      _underemployeeEntityDeletionAdapter;

  @override
  Future<List<UnderemployeeEntity>> searchEmployeesByName(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM underemployee_entity WHERE name LIKE ?1',
        mapper: (Map<String, Object?> row) => UnderemployeeEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            employeeId: row['employeeId'] as int,
            designation: row['designation'] as String,
            photo: row['photo'] as Uint8List?),
        arguments: [query]);
  }

  @override
  Future<List<UnderemployeeEntity>> findUnderemployeesByEmployeeId(
      int employeeId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM underemployee_entity WHERE employeeId = ?1',
        mapper: (Map<String, Object?> row) => UnderemployeeEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            employeeId: row['employeeId'] as int,
            designation: row['designation'] as String,
            photo: row['photo'] as Uint8List?),
        arguments: [employeeId]);
  }

  @override
  Future<List<UnderemployeeEntity>> findAllUnderemployees() async {
    return _queryAdapter.queryList('SELECT * FROM underemployee_entity',
        mapper: (Map<String, Object?> row) => UnderemployeeEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            employeeId: row['employeeId'] as int,
            designation: row['designation'] as String,
            photo: row['photo'] as Uint8List?));
  }

  @override
  Future<List<UnderemployeeEntity>> printAllUnderemployees() async {
    return _queryAdapter.queryList('SELECT * FROM underemployee_entity',
        mapper: (Map<String, Object?> row) => UnderemployeeEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            employeeId: row['employeeId'] as int,
            designation: row['designation'] as String,
            photo: row['photo'] as Uint8List?));
  }

  @override
  Future<UnderemployeeEntity?> findUnderemployeeByUidAndPassword(
    String uid,
    String password,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM underemployee_entity WHERE uid = ?1 AND password = ?2',
        mapper: (Map<String, Object?> row) => UnderemployeeEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            employeeId: row['employeeId'] as int,
            designation: row['designation'] as String,
            photo: row['photo'] as Uint8List?),
        arguments: [uid, password]);
  }

  @override
  Future<UnderemployeeEntity?> findUnderemployeeByUid(String uid) async {
    return _queryAdapter.query(
        'SELECT * FROM underemployee_entity WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => UnderemployeeEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            employeeId: row['employeeId'] as int,
            designation: row['designation'] as String,
            photo: row['photo'] as Uint8List?),
        arguments: [uid]);
  }

  @override
  Future<void> deleteAllUnderemployees() async {
    await _queryAdapter.queryNoReturn('DELETE FROM underemployee_entity');
  }

  @override
  Future<void> insertUnderemployee(UnderemployeeEntity underemployee) async {
    await _underemployeeEntityInsertionAdapter.insert(
        underemployee, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUnderemployee(UnderemployeeEntity underemployee) async {
    await _underemployeeEntityUpdateAdapter.update(
        underemployee, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUnderemployee(UnderemployeeEntity underemployee) async {
    await _underemployeeEntityDeletionAdapter.delete(underemployee);
  }
}
