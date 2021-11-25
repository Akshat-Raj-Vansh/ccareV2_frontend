import 'dart:convert';

import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter/foundation.dart';

import 'package:ccarev2_frontend/user/domain/location.dart';

class DoctorProfile {
  final String name;
  final String hospitalName;
  final String email;
  final String phoneNumber;
  final UserType type;
  final Location location;
  DoctorProfile({
    required this.name,
    required this.hospitalName,
    required this.email,
    required this.phoneNumber,
    required this.type,
    required this.location,
  });

  DoctorProfile copyWith({
    String? name,
    String? hospitalName,
    String? email,
    String? phoneNumber,
    UserType? type,
    Location? location,
  }) {
    return DoctorProfile(
      name: name ?? this.name,
      hospitalName: hospitalName ?? this.hospitalName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type ?? this.type,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hospitalName': hospitalName,
      'email': email,
      'phoneNumber': phoneNumber,
      'type': type.toString().split('.')[1],
      'location': location.toMap(),
    };
  }

  factory DoctorProfile.fromMap(Map<String, dynamic> map) {
    return DoctorProfile(
      name: map['name'],
      hospitalName: map['hospitalName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      type: UserType.values.firstWhere(
          (element) => element.toString() == "UserType." + map['type']),
      location: Location.fromMap(map['location']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorProfile.fromJson(String source) =>
      DoctorProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DoctorProfile(name: $name, hospitalName: $hospitalName, email: $email, phoneNumber: $phoneNumber, type: $type, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DoctorProfile &&
        other.name == name &&
        other.hospitalName == hospitalName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.type == type &&
        other.location == location;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        hospitalName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        type.hashCode ^
        location.hashCode;
  }
}

class PatientProfile {
  final String name;
  final String gender;
  final int age;
  PatientProfile({
    required this.name,
    required this.gender,
    required this.age,
  });

  PatientProfile copyWith({
    String? name,
    String? gender,
    int? age,
  }) {
    return PatientProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'age': age,
    };
  }

  factory PatientProfile.fromMap(Map<String, dynamic> map) {
    return PatientProfile(
      name: map['name'],
      gender: map['gender'],
      age: map['age'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientProfile.fromJson(String source) =>
      PatientProfile.fromMap(json.decode(source));

  @override
  String toString() =>
      'PatientProfile(name: $name, gender: $gender, age: $age)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientProfile &&
        other.name == name &&
        other.gender == gender &&
        other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ gender.hashCode ^ age.hashCode;
}

class DriverProfile {
  final String name;
  final String uniqueCode;
  final String plateNumber;
  final Location location;
  DriverProfile({
    required this.name,
    required this.uniqueCode,
    required this.plateNumber,
    required this.location,
  });

  DriverProfile copyWith({
    String? name,
    String? uniqueCode,
    String? plateNumber,
    Location? location,
  }) {
    return DriverProfile(
      name: name ?? this.name,
      uniqueCode: uniqueCode ?? this.uniqueCode,
      plateNumber: plateNumber ?? this.plateNumber,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uniqueCode': uniqueCode,
      'plateNumber': plateNumber,
      'location': location.toMap(),
    };
  }

  factory DriverProfile.fromMap(Map<String, dynamic> map) {
    return DriverProfile(
      name: map['name'],
      uniqueCode: map['uniqueCode'],
      plateNumber: map['plateNumber'],
      location: Location.fromMap(map['location']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverProfile.fromJson(String source) =>
      DriverProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DriverProfile(name: $name, uniqueCode: $uniqueCode, plateNumber: $plateNumber, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DriverProfile &&
        other.name == name &&
        other.uniqueCode == uniqueCode &&
        other.plateNumber == plateNumber &&
        other.location == location;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        uniqueCode.hashCode ^
        plateNumber.hashCode ^
        location.hashCode;
  }
}
