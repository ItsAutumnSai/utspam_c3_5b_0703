// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Users {
    final int? id;
    final String username;
    final String password;
    final String name;
    final String nik;
    final String email;
    final String phone;
    final String address;
  Users({
    this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.nik,
    required this.email,
    required this.phone,
    required this.address,
  });

  Users copyWith({
    int? id,
    String? username,
    String? password,
    String? name,
    String? nik,
    String? email,
    String? phone,
    String? address,
  }) {
    return Users(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      nik: nik ?? this.nik,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'nik': nik,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'] != null ? map['id'] as int : null,
      username: map['username'] as String,
      password: map['password'] as String,
      name: map['name'] as String,
      nik: map['nik'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) => Users.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Users(id: $id, username: $username, password: $password, name: $name, nik: $nik, email: $email, phone: $phone, address: $address)';
  }

  @override
  bool operator ==(covariant Users other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.username == username &&
      other.password == password &&
      other.name == name &&
      other.nik == nik &&
      other.email == email &&
      other.phone == phone &&
      other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      password.hashCode ^
      name.hashCode ^
      nik.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      address.hashCode;
  }
}
