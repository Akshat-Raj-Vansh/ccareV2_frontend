import 'dart:convert';
import 'package:collection/collection.dart';

class DoctorProfile {
  final String firstName;
  final String lastName;
  final Gender gender;
  final int age;
  final String specialization;
  final String uniqueCode;
  final String email;
  final String location;

  DoctorProfile(this.firstName, this.lastName, this.gender, this.age,
      this.specialization, this.uniqueCode, this.email, this.location);

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender == Gender.male ? "Male" : "Female",
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
      map['gender'] == "Male" ? Gender.male : Gender.female,
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
  final Gender gender;
  final int age;

  PatientProfile(this.firstName, this.lastName, this.gender, this.age);
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender == Gender.male ? "Male" : "Female",
      'age': age,
    };
  }

  factory PatientProfile.fromMap(Map<String, dynamic> map) {
    return PatientProfile(
      map['firstName'],
      map['lastName'],
      map['gender'],
      map['age'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientProfile.fromJson(String source) =>
      PatientProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PatientProfile(firstName: $firstName, lastName: $lastName, gender: $gender, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is PatientProfile &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.gender == gender &&
        other.age == age;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        gender.hashCode ^
        age.hashCode;
  }
}

enum Gender { male, female, other }
