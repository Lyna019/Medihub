import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._privateConstructor();
  static Database? _database;

  DBHelper._privateConstructor();

  factory DBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'user_credentials.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
      'CREATE TABLE user_credentials(id INTEGER PRIMARY KEY, email TEXT, password TEXT)',
    );
  }

  Future<void> saveCredentials(String email, String password) async {
    final db = await database;
    await db.delete('user_credentials');
    await db.insert(
      'user_credentials',
      {'email': email, 'password': password},
    );
  }
  Future<void> deleteCredentials() async {
  final db = await database;
  await db.delete('user_credentials');
}

  Future<Map<String, dynamic>> getCredentials() async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db.query('user_credentials');
    if (rows.isNotEmpty) {
      return rows.first;
    }
    return {};
  }
}