import '../model/RentHistory.dart';
import 'db_helper.dart';

class RentHistoryDao {
  final DbHelper _dbHelper = DbHelper.instance;

  Future<int> addRent(RentHistory rent) async {
    final db = await _dbHelper.database;
    final map = {
      'userid': rent.userId,
      'carid': rent.carId,
      'rentdate': rent.rentDate,
      'rentdurationdays': rent.rentDurationDays,
    };
    _dbHelper.log(
      'Adding rent history: User ${rent.userId}, Car ${rent.carId}',
    );
    return db.insert('renthistory', map);
  }

  Future<List<RentHistory>> getAllRents() async {
    final db = await _dbHelper.database;
    final rows = await db.query('renthistory');
    return rows.map((r) {
      final mapped = {
        'id': r['id'],
        'userId': r['userid'],
        'carId': r['carid'],
        'rentDate': r['rentdate'],
        'rentDurationDays': r['rentdurationdays'],
      };
      return RentHistory.fromMap(Map<String, dynamic>.from(mapped));
    }).toList();
  }

  Future<List<RentHistory>> getRentsByUser(int userId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'renthistory',
      where: 'userid = ?',
      whereArgs: [userId],
    );
    return rows.map((r) {
      final mapped = {
        'id': r['id'],
        'userId': r['userid'],
        'carId': r['carid'],
        'rentDate': r['rentdate'],
        'rentDurationDays': r['rentdurationdays'],
      };
      return RentHistory.fromMap(Map<String, dynamic>.from(mapped));
    }).toList();
  }

  Future<int> deleteRent(int id) async {
    final db = await _dbHelper.database;
    _dbHelper.log('Deleting rent history id: $id');
    return db.delete('renthistory', where: 'id = ?', whereArgs: [id]);
  }
}
