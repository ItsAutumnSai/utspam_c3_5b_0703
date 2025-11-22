import '../model/Cars.dart';
import 'db_helper.dart';

class CarsDao {
  final DbHelper _dbHelper = DbHelper.instance;

  Future<int> insertCar(Cars car) async {
    final db = await _dbHelper.database;
    final map = {
      'carname': car.carName,
      'cartype': car.carType,
      'carpriceperday': car.carPricePerDay,
      'carimagepath': car.carImagePath,
      'isavailable': car.isAvailable ? 1 : 0,
    };
    _dbHelper.log('Inserting car: ${car.carName}');
    return db.insert('cars', map);
  }

  Future<List<Cars>> getAllCars() async {
    final db = await _dbHelper.database;
    final rows = await db.query('cars');
    return rows.map((r) {
      final mapped = {
        'carid': r['carid'],
        'carName': r['carname'],
        'carType': r['cartype'],
        'carPricePerDay': r['carpriceperday'],
        'carImagePath': r['carimagepath'],
        'isAvailable': (r['isavailable'] == 1) || (r['isavailable'] == 1),
      };
      return Cars.fromMap(Map<String, dynamic>.from(mapped));
    }).toList();
  }

  Future<Cars?> getCarById(int id) async {
    final db = await _dbHelper.database;
    final rows = await db.query('cars', where: 'carid = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    final r = rows.first;
    final mapped = {
      'carid': r['carid'],
      'carName': r['carname'],
      'carType': r['cartype'],
      'carPricePerDay': r['carpriceperday'],
      'carImagePath': r['carimagepath'],
      'isAvailable': r['isavailable'] == 1,
    };
    return Cars.fromMap(Map<String, dynamic>.from(mapped));
  }

  Future<int> updateCarAvailability(int carId, bool available) async {
    final db = await _dbHelper.database;
    _dbHelper.log('Updating car availability: $carId to $available');
    return db.update(
      'cars',
      {'isavailable': available ? 1 : 0},
      where: 'carid = ?',
      whereArgs: [carId],
    );
  }

  Future<int> deleteCar(int id) async {
    final db = await _dbHelper.database;
    _dbHelper.log('Deleting car id: $id');
    return db.delete('cars', where: 'carid = ?', whereArgs: [id]);
  }
}
