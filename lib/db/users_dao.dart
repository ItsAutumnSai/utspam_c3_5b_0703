import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../model/Users.dart';
import 'db_helper.dart';

class UsersDao {
  final DbHelper _dbHelper = DbHelper.instance;

  // inserts the user row. Returns the inserted row id.
  Future<int> registerUser({
    required String username,
    required String password,
    required String name,
    required String nik,
    required String email,
    required String phone,
    required String address,
  }) async {
    final db = await _dbHelper.database;
    final hashed = sha256.convert(utf8.encode(password)).toString();
    final map = {
      'username': username,
      'password': hashed,
      'name': name,
      'nik': nik,
      'email': email,
      'phone': phone,
      'address': address,
    };
    _dbHelper.log('Inserting user: $username');
    return db.insert('users', map);
  }

  // Returns the `Users` instance if authentication succeeds, otherwise null.
  Future<Users?> authenticate(String username, String password) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isEmpty) return null;
    final stored = maps.first;
    final storedHash = stored['password'] as String?;
    if (storedHash == null) return null;
    final candidateHash = sha256.convert(utf8.encode(password)).toString();
    if (storedHash == candidateHash) return Users.fromMap(stored);
    return null;
  }

  // Future<int> createUser(Users user) async {
  //   final db = await _dbHelper.database;
  //   return db.insert('users', user.toMap());
  // }

  Future<Users?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Users.fromMap(maps.first);
    return null;
  }

  Future<Users?> getUserByUsername(String username) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) return Users.fromMap(maps.first);
    return null;
  }

  Future<List<Users>> getAllUsers() async {
    final db = await _dbHelper.database;
    final maps = await db.query('users');
    return maps.map((m) => Users.fromMap(m)).toList();
  }

  Future<int> updateUser(Users user) async {
    final db = await _dbHelper.database;
    _dbHelper.log('Updating user: ${user.username}');
    return db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.database;
    _dbHelper.log('Deleting user id: $id');
    return db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
