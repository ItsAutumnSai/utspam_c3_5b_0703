// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RentHistory {
  final int? id;
  final int? userId;
  final int? carId;
  final String rentDate;
  final int rentDurationDays;
  RentHistory({
    this.id,
    this.userId,
    this.carId,
    required this.rentDate,
    required this.rentDurationDays,
  });

  RentHistory copyWith({
    int? id,
    int? userId,
    int? carId,
    String? rentDate,
    int? rentDurationDays,
  }) {
    return RentHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      rentDate: rentDate ?? this.rentDate,
      rentDurationDays: rentDurationDays ?? this.rentDurationDays,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'carId': carId,
      'rentDate': rentDate,
      'rentDurationDays': rentDurationDays,
    };
  }

  factory RentHistory.fromMap(Map<String, dynamic> map) {
    return RentHistory(
      id: map['id'] != null ? map['id'] as int : null,
      userId: map['userId'] != null ? map['userId'] as int : null,
      carId: map['carId'] != null ? map['carId'] as int : null,
      rentDate: map['rentDate'] as String,
      rentDurationDays: map['rentDurationDays'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RentHistory.fromJson(String source) => RentHistory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RentHistory(id: $id, userId: $userId, carId: $carId, rentDate: $rentDate, rentDurationDays: $rentDurationDays)';
  }

  @override
  bool operator ==(covariant RentHistory other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.carId == carId &&
      other.rentDate == rentDate &&
      other.rentDurationDays == rentDurationDays;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      carId.hashCode ^
      rentDate.hashCode ^
      rentDurationDays.hashCode;
  }
}
