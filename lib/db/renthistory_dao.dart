import '../model/RentHistory.dart';
import 'db_helper.dart';
import 'cars_dao.dart';
import 'package:intl/intl.dart';

class RentHistoryDao {
  final DbHelper _dbHelper = DbHelper.instance;

  Future<int> addRent(RentHistory rent) async {
    final db = await _dbHelper.database;
    final map = {
      'userid': rent.userId,
      'carid': rent.carId,
      'rentdate': rent.rentDate,
      'rentdurationdays': rent.rentDurationDays,
      'isRentActive': rent.isRentActive,
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
        'isRentActive': r['isRentActive'],
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
        'isRentActive': r['isRentActive'],
      };
      return RentHistory.fromMap(Map<String, dynamic>.from(mapped));
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getRentHistoryWithCars(int userId) async {
    final db = await _dbHelper.database;
    final rows = await db.rawQuery(
      '''
      SELECT rh.*, c.carname, c.carpriceperday 
      FROM renthistory rh
      INNER JOIN cars c ON rh.carid = c.carid
      WHERE rh.userid = ?
    ''',
      [userId],
    );
    return rows;
  }

  Future<int> deleteRent(int id) async {
    final db = await _dbHelper.database;
    _dbHelper.log('Deleting rent history id: $id');
    return db.delete('renthistory', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> checkAndUpdateExpiredRents() async {
    final db = await _dbHelper.database;
    final carsDao = CarsDao();

    // Get all active rents
    final activeRentsRows = await db.query(
      'renthistory',
      where: 'isRentActive = ?',
      whereArgs: [1],
    );

    final activeRents = activeRentsRows.map((r) {
      final mapped = {
        'id': r['id'],
        'userId': r['userid'],
        'carId': r['carid'],
        'rentDate': r['rentdate'],
        'rentDurationDays': r['rentdurationdays'],
        'isRentActive': r['isRentActive'],
      };
      return RentHistory.fromMap(Map<String, dynamic>.from(mapped));
    }).toList();

    final now = DateTime.now();

    for (final rent in activeRents) {
      final rentDate = DateFormat('yyyy-MM-dd').parse(rent.rentDate);
      final endDate = rentDate.add(Duration(days: rent.rentDurationDays));

      // If now is after end date, mark as finished (2) and make car available
      if (now.isAfter(endDate)) {
        await db.update(
          'renthistory',
          {'isRentActive': 2},
          where: 'id = ?',
          whereArgs: [rent.id],
        );

        if (rent.carId != null) {
          await carsDao.updateCarAvailability(rent.carId!, true);
        }

        _dbHelper.log(
          'Rent ${rent.id} expired. Car ${rent.carId} is now available.',
        );
      }
    }
  }
}
