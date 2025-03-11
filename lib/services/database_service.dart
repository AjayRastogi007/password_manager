import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DatabaseService {
  static sql.Database? _db;
  static final DatabaseService instance = DatabaseService._internal();
  factory DatabaseService() => instance;

  DatabaseService._internal();

  static const _vaultsTableName = 'vaults';
  static const _vaultsIdColumnName = 'id';
  static const _vaultsTitleColumnName = 'title';
  static const _vaultsUsernameColumnName = 'username';
  static const _vaultsUrlColumnName = 'url';
  static const _vaultsPasswordColumnName = 'password';
  static const _vaultsCategoryColumnName = 'category';
  static const _vaultsStrengthColumnName = 'strength';
  static const _vaultsNotesColumnName = 'notes';
  static const _vaultsAddedDateColumnName = 'addedDate';

  Future<sql.Database?> get database async {
    _db ??= await _initDB();
    return _db;
  }

  Future<Database> _initDB() async {
    String databaseDirPath = await sql.getDatabasesPath();
    String databasePath = path.join(databaseDirPath, 'vaults_database.db');
    return await sql.openDatabase(databasePath,
        version: 1, onCreate: _createDB);
  }

  Future _createDB(sql.Database db, int version) async {
    await db.execute('''
        CREATE TABLE $_vaultsTableName (
          $_vaultsIdColumnName TEXT PRIMARY KEY,
          $_vaultsTitleColumnName TEXT NOT NULL,
          $_vaultsUsernameColumnName TEXT NOT NULL,
          $_vaultsUrlColumnName TEXT NOT NULL,
          $_vaultsPasswordColumnName TEXT NOT NULL,
          $_vaultsStrengthColumnName TEXT NOT NULL,
          $_vaultsCategoryColumnName TEXT NOT NULL,
          $_vaultsNotesColumnName TEXT,
          $_vaultsAddedDateColumnName TEXT NOT NULL
        )
        ''');
  }

// insert
  Future<void> addVaults(Map<String, dynamic> row) async {
    final db = await instance.database;
    await db!.insert(_vaultsTableName, row,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

// read
  Future<List<Map<String, dynamic>>> getVaults() async {
    final db = await instance.database;
    return await db!.query(_vaultsTableName);
  }

  // update
  Future<void> updateVaults(Map<String, dynamic> row) async {
    final db = await instance.database;
    await db!.update(
      _vaultsTableName,
      row,
      where: '$_vaultsIdColumnName = ?',
      whereArgs: [row[_vaultsIdColumnName]],
    );
  }

  // delete
  Future<void> deleteVaults(String id) async {
    final db = await instance.database;
    await db!.delete(
      _vaultsTableName,
      where: '$_vaultsIdColumnName = ?',
      whereArgs: [id],
    );
  }

  // close
  Future close() async {
    final db = await instance.database;
    db!.close();
  }
}
