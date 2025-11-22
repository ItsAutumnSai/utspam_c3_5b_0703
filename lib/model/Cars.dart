// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Cars {
  final int? carid;
  final String carName;
  final String carType;
  final String carPricePerDay;
  final String carImagePath;
  final bool isAvailable;
  Cars({
    this.carid,
    required this.carName,
    required this.carType,
    required this.carPricePerDay,
    required this.carImagePath,
    required this.isAvailable,
  });

  Cars copyWith({
    int? carid,
    String? carName,
    String? carType,
    String? carPricePerDay,
    String? carImagePath,
    bool? isAvailable,
  }) {
    return Cars(
      carid: carid ?? this.carid,
      carName: carName ?? this.carName,
      carType: carType ?? this.carType,
      carPricePerDay: carPricePerDay ?? this.carPricePerDay,
      carImagePath: carImagePath ?? this.carImagePath,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'carid': carid,
      'carName': carName,
      'carType': carType,
      'carPricePerDay': carPricePerDay,
      'carImagePath': carImagePath,
      'isAvailable': isAvailable,
    };
  }

  factory Cars.fromMap(Map<String, dynamic> map) {
    return Cars(
      carid: map['carid'] != null ? map['carid'] as int : null,
      carName: map['carName'] as String,
      carType: map['carType'] as String,
      carPricePerDay: map['carPricePerDay'] as String,
      carImagePath: map['carImagePath'] as String,
      isAvailable: map['isAvailable'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cars.fromJson(String source) => Cars.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cars(carid: $carid, carName: $carName, carType: $carType, carPricePerDay: $carPricePerDay, carImagePath: $carImagePath, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(covariant Cars other) {
    if (identical(this, other)) return true;
  
    return 
      other.carid == carid &&
      other.carName == carName &&
      other.carType == carType &&
      other.carPricePerDay == carPricePerDay &&
      other.carImagePath == carImagePath &&
      other.isAvailable == isAvailable;
  }

  @override
  int get hashCode {
    return carid.hashCode ^
      carName.hashCode ^
      carType.hashCode ^
      carPricePerDay.hashCode ^
      carImagePath.hashCode ^
      isAvailable.hashCode;
  }
}
