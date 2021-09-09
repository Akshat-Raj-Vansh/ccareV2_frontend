import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ccarev2_frontend/user/domain/location.dart';

class DoctorProfile {
  final String name;
  final String specialization;
  final String uniqueCode;
  final String email;
  final Location location;
  final String hospital;
  DoctorProfile({
    required this.name,
    required this.specialization,
    required this.uniqueCode,
    required this.email,
    required this.location,
    required this.hospital,
  });

  DoctorProfile copyWith({
    String? name,
    String? specialization,
    String? uniqueCode,
    String? email,
    Location? location,
    String? hospital,
  }) {
    return DoctorProfile(
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      uniqueCode: uniqueCode ?? this.uniqueCode,
      email: email ?? this.email,
      location: location ?? this.location,
      hospital: hospital ?? this.hospital,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialization': specialization,
      'uniqueCode': uniqueCode,
      'email': email,
      'location': location.toMap(),
      'hospital': hospital,
    };
  }

  factory DoctorProfile.fromMap(Map<String, dynamic> map) {
    return DoctorProfile(
      name: map['name'],
      specialization: map['specialization'],
      uniqueCode: map['uniqueCode'],
      email: map['email'],
      location: Location.fromMap(map['location']),
      hospital: map['hospital'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorProfile.fromJson(String source) =>
      DoctorProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DoctorProfile(name: $name, specialization: $specialization, uniqueCode: $uniqueCode, email: $email, location: $location, hospital: $hospital)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DoctorProfile &&
        other.name == name &&
        other.specialization == specialization &&
        other.uniqueCode == uniqueCode &&
        other.email == email &&
        other.location == location &&
        other.hospital == hospital;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        specialization.hashCode ^
        uniqueCode.hashCode ^
        email.hashCode ^
        location.hashCode ^
        hospital.hashCode;
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
