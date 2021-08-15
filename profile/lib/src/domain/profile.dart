import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

class Profile {
  final String firstName;
  final String lastName;
  final Address address;
  final DateTime dob;
  final String specialisation;
  final String uniqueCode;
  final int emergencyContact;

  Profile(
    this.firstName,
    this.lastName,
    this.address,
    this.dob,
    this.specialisation,
    this.uniqueCode,
    this.emergencyContact,
  );

  Profile copyWith({
    String? firstName,
    String? lastName,
    Address? address,
    DateTime? dob,
    String? specialisation,
    String? uniqueCode,
    int? emergencyContact,
  }) {
    return Profile(
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      address ?? this.address,
      dob ?? this.dob,
      specialisation ?? this.specialisation,
      uniqueCode ?? this.uniqueCode,
      emergencyContact ?? this.emergencyContact,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address': address.toMap(),
      'dob': dob.millisecondsSinceEpoch,
      'specialisation': specialisation,
      'uniqueCode': uniqueCode,
      'emergencyContact': emergencyContact,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      map['firstName'],
      map['lastName'],
      Address.fromMap(map['address']),
      DateTime.parse(map['dob']),
      map['specialisation'],
      map['uniqueCode'],
      map['emergencyContact'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(firstName: $firstName, lastName: $lastName, address: $address, dob: $dob, specialisation: $specialisation, uniqueCode: $uniqueCode, emergencyContact: $emergencyContact,)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Profile &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.address == address &&
        other.dob == dob &&
        other.specialisation == specialisation &&
        other.uniqueCode == uniqueCode &&
        other.emergencyContact == emergencyContact;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        address.hashCode ^
        dob.hashCode ^
        specialisation.hashCode ^
        uniqueCode.hashCode ^
        emergencyContact.hashCode;
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
