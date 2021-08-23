import 'dart:convert';
import 'package:collection/collection.dart';

class DoctorProfile {
  final String firstName;
  final String lastName;
  final Address address;
  final String email;
  final String phone;
  final String uniqueCode;

  DoctorProfile(this.firstName, this.lastName, this.address, this.email,
      this.phone, this.uniqueCode);

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address': address.toMap(),
      'email': email,
      'phone': phone,
      'uniqueCode': uniqueCode,
    };
  }

  factory DoctorProfile.fromMap(Map<String, dynamic> map) {
    return DoctorProfile(
      map['firstName'],
      map['lastName'],
      Address.fromMap(map['address']),
      map['email'],
      map['phone'],
      map['uniqueCode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorProfile.fromJson(String source) =>
      DoctorProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DoctorProfile(firstName: $firstName, lastName: $lastName, address: $address, email: $email, uniqueCode: $uniqueCode, phone: $phone,)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is DoctorProfile &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.address == address &&
        other.email == email &&
        other.uniqueCode == uniqueCode &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        address.hashCode ^
        email.hashCode ^
        uniqueCode.hashCode ^
        phone.hashCode;
  }
}

class Address {
  final String hospitalAddress;
  final String city;
  final String district;
  final String state;
  final int pincode;

  Address({
    required this.hospitalAddress,
    required this.city,
    required this.district,
    required this.state,
    required this.pincode,
  });

  Address copyWith({
    String? hospitalAddress,
    String? city,
    String? district,
    String? state,
    int? pincode,
  }) {
    return Address(
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      city: city ?? this.city,
      district: district ?? this.district,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hospitalAddress': hospitalAddress,
      'city': city,
      'district': district,
      'state': state,
      'pincode': pincode,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      hospitalAddress: map['hospitalAddress'],
      city: map['city'],
      district: map['district'],
      state: map['state'],
      pincode: map['pincode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Address(hospitalAddress: $hospitalAddress, city: $city, district: $district, state: $state, pincode: $pincode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Address &&
        other.hospitalAddress == hospitalAddress &&
        other.city == city &&
        other.district == district &&
        other.state == state &&
        other.pincode == pincode;
  }

  @override
  int get hashCode {
    return hospitalAddress.hashCode ^
        city.hashCode ^
        district.hashCode ^
        state.hashCode ^
        pincode.hashCode;
  }
}

class PatientProfile {
  final String firstName;
  final String lastName;
  final int age;
  final Sex sex;
  final String phone;

  PatientProfile(this.firstName, this.lastName, this.age, this.sex, this.phone);
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'sex': sex,
      'phone': phone,
    };
  }

  factory PatientProfile.fromMap(Map<String, dynamic> map) {
    return PatientProfile(
      map['firstName'],
      map['lastName'],
      map['age'],
      map['sex'],
      map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientProfile.fromJson(String source) =>
      PatientProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PatientProfile(firstName: $firstName, lastName: $lastName, age: $age, sex: $sex, phone: $phone,)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is PatientProfile &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.age == age &&
        other.sex == sex &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        age.hashCode ^
        sex.hashCode ^
        phone.hashCode;
  }
}

enum Sex { male, female, other }
