import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String dbName = 'app_database.db';

  DbHelper._init();
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  factory DbHelper() {
    return instance;
  }

  Future<Database> get database async {
    _database = await _initDatabase(dbName);
    return _database!;
  }

  Future<Database> _initDatabase(String dbName) 
  async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate, onConfigure: _onConfigure);
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version)
  async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username VARCHAR(20) NOT NULL,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        nik VARCHAR(20) NOT NULL,
        email TEXT NOT NULL,
        phone VARCHAR(15) NOT NULL,
        address TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE cars (
        carid INTEGER PRIMARY KEY AUTOINCREMENT,
        carname TEXT NOT NULL,
        cartype TEXT NOT NULL,
        carpriceperday TEXT NOT NULL,
        carimagepath TEXT NOT NULL,
        isavailable BOOLEAN NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE renthistory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userid INTEGER NOT NULL,
        carid INTEGER NOT NULL,
        rentdate TEXT NOT NULL,
        rentdurationdays INTEGER NOT NULL,
        FOREIGN KEY (userid) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (carid) REFERENCES cars (carid) ON DELETE CASCADE
      )
    ''');
  }
}