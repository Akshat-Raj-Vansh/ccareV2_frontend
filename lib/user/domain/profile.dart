import 'dart:convert';
import 'dart:html';
import 'package:collection/collection.dart';

class DoctorProfile {
  final String firstName;
  final String lastName;
  final Gender gender;
  final int age;
  final String specialization;
  final String uniqueCode;
  final String email;
  final Location location;

  DoctorProfile(this.firstName, this.lastName, this.gender, this.age,
      this.specialization, this.uniqueCode, this.email, this.location);

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'age': age,
      'specialisation': specialization,
      'uniqueCode': uniqueCode,
      'email': email,
      'location': location,
    };
  }

  factory DoctorProfile.fromMap(Map<String, dynamic> map) {
    return DoctorProfile(
      map['firstName'],
      map['lastName'],
      map['gender'],
      map['age'],
      map['specialization'],
      map['uniqueCode'],
      map['email'],
      map['location'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorProfile.fromJson(String source) =>
      DoctorProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DoctorProfile(firstName: $firstName, lastName: $lastName, gender: $gender, age:$age, specialization:$specialization, uniqueCode:$uniqueCode, email: $email, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is DoctorProfile &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.gender == gender &&
        other.age == age &&
        other.specialization == specialization &&
        other.uniqueCode == uniqueCode &&
        other.email == email &&
        other.location == location;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        gender.hashCode ^
        age.hashCode ^
        specialization.hashCode ^
        uniqueCode.hashCode ^
        email.hashCode ^
        location.hashCode;
  }
}

class PatientProfile {
  final String firstName;
  final String lastName;
  final int age;
  final Gender gender;

  PatientProfile(this.firstName, this.lastName, this.age, this.gender);
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
    };
  }

  factory PatientProfile.fromMap(Map<String, dynamic> map) {
    return PatientProfile(
      map['firstName'],
      map['lastName'],
      map['age'],
      map['gender'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientProfile.fromJson(String source) =>
      PatientProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PatientProfile(firstName: $firstName, lastName: $lastName, age: $age, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is PatientProfile &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.age == age &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        age.hashCode ^
        gender.hashCode;
  }
}

enum Gender { male, female, other }
