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
    if (_database != null) return _database!;
    _database = await _initDatabase(dbName);
    return _database!;
  }

  Future<Database> _initDatabase(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
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
    await _insertInitialCars(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      await db.execute('''
        DELETE FROM cars 
      ''');

      await _insertInitialCars(db);
    }
  }

  Future<void> _insertInitialCars(Database db) async {
    final initial = [
      {
        'carname': 'Toyota Crown 2.4',
        'cartype': 'Luxury sedan',
        'carpriceperday': '2000000',
        'carimagepath': 'assets/images/cars/toyotacrown.png',
        'isavailable': 1,
      },
      {
        'carname': 'BYD Atto 3',
        'cartype': 'Electric MPV',
        'carpriceperday': '2000000',
        'carimagepath': 'assets/images/cars/bydatto3.png',
        'isavailable': 1,
      },
      {
        'carname': 'MINI Cooper S Cabrio',
        'cartype': 'Hatchback',
        'carpriceperday': '3500000',
        'carimagepath': 'assets/images/cars/minicoopers.png',
        'isavailable': 1,
      },
      {
        'carname': 'Toyota Avanza',
        'cartype': 'MPV',
        'carpriceperday': '350000',
        'carimagepath': 'assets/images/cars/avanza.png',
        'isavailable': 1,
      },
      {
        'carname': 'Honda Brio',
        'cartype': 'Hatchback',
        'carpriceperday': '300000',
        'carimagepath': 'assets/images/cars/brio.png',
        'isavailable': 1,
      },
      {
        'carname': 'Toyota Fortuner',
        'cartype': 'SUV',
        'carpriceperday': '650000',
        'carimagepath': 'assets/images/cars/fortuner.png',
        'isavailable': 1,
      },
    ];

    final batch = db.batch();
    for (final car in initial) {
      batch.insert('cars', car, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  /// Close the database (optional helper)
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  void log(String message) {
    print('[DB LOG] $message');
  }
}
