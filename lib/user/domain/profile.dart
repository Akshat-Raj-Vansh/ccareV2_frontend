import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class DoctorProfile {
  final String name;
  final String specialization;
  final String uniqueCode;
  final String email;
  final Map<String, LocationData> location;
  DoctorProfile({
    required this.name,
    required this.specialization,
    required this.uniqueCode,
    required this.email,
    required this.location,
  });

  DoctorProfile copyWith({
    String? name,
    String? specialization,
    String? uniqueCode,
    String? email,
    Map<String, LocationData>? location,
  }) {
    return DoctorProfile(
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      uniqueCode: uniqueCode ?? this.uniqueCode,
      email: email ?? this.email,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialization': specialization,
      'uniqueCode': uniqueCode,
      'email': email,
      'location': location,
    };
  }

  factory DoctorProfile.fromMap(Map<String, dynamic> map) {
    return DoctorProfile(
      name: map['name'],
      specialization: map['specialization'],
      uniqueCode: map['uniqueCode'],
      email: map['email'],
      location: Map<String, LocationData>.from(map['location']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorProfile.fromJson(String source) =>
      DoctorProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DoctorProfile(name: $name, specialization: $specialization, uniqueCode: $uniqueCode, email: $email, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DoctorProfile &&
        other.name == name &&
        other.specialization == specialization &&
        other.uniqueCode == uniqueCode &&
        other.email == email &&
        mapEquals(other.location, location);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        specialization.hashCode ^
        uniqueCode.hashCode ^
        email.hashCode ^
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
  final Map<String, LocationData> location;
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
    Map<String, LocationData>? location,
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
      'location': location,
    };
  }

  factory DriverProfile.fromMap(Map<String, dynamic> map) {
    return DriverProfile(
      name: map['name'],
      uniqueCode: map['uniqueCode'],
      plateNumber: map['plateNumber'],
      location: Map<String, LocationData>.from(map['location']),
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
        mapEquals(other.location, location);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        uniqueCode.hashCode ^
        plateNumber.hashCode ^
        location.hashCode;
  }
}
