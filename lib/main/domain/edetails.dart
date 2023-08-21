import 'dart:convert';

import 'package:ccarev2_frontend/user/domain/location.dart';

class EDetails {
  PatientDetails? patientDetails;
  DoctorDetails? doctorDetails;
  DriverDetails? driverDetails;
  DoctorDetails? hubDetails;
  EDetails({
    this.patientDetails,
    this.doctorDetails,
    this.driverDetails,
    this.hubDetails,
  });

  EDetails copyWith({
    PatientDetails? patientDetails,
    DoctorDetails? doctorDetails,
    DriverDetails? driverDetails,
    DoctorDetails? hubDetails,
  }) {
    return EDetails(
      patientDetails: patientDetails ?? this.patientDetails,
      doctorDetails: doctorDetails ?? this.doctorDetails,
      driverDetails: driverDetails ?? this.driverDetails,
      hubDetails: hubDetails ?? this.hubDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientDetails': patientDetails?.toMap(),
      'doctorDetails': doctorDetails?.toMap(),
      'driverDetails': driverDetails?.toMap(),
      'hubDetails': hubDetails?.toMap(),
    };
  }

  factory EDetails.fromMap(Map<String, dynamic> map) {
    return EDetails(
      patientDetails: map['patientDetails'] != null
          ? PatientDetails.fromMap(map['patientDetails'])
          : null,
      doctorDetails: map['doctorDetails'] != null
          ? DoctorDetails.fromMap(map['doctorDetails'])
          : null,
      driverDetails: map['driverDetails'] != null
          ? DriverDetails.fromMap(map['driverDetails'])
          : null,
      hubDetails: map['hubDetails'] != null
          ? DoctorDetails.fromMap(map['hubDetails'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EDetails.fromJson(String source) =>
      EDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EDetails(patientDetails: $patientDetails, doctorDetails: $doctorDetails, driverDetails: $driverDetails, hubDetails: $hubDetails)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EDetails &&
        other.patientDetails == patientDetails &&
        other.doctorDetails == doctorDetails &&
        other.driverDetails == driverDetails &&
        other.hubDetails == hubDetails;
  }

  @override
  int get hashCode {
    return patientDetails.hashCode ^
        doctorDetails.hashCode ^
        driverDetails.hashCode ^
        hubDetails.hashCode;
  }
}

enum EStatus { OTW, EMERGENCY, ATH, UGT }

class PatientDetails {
  final String id;
  final String name;
  final Location location;
  final String action;
  final int age;
  final String gender;
  final String contactNumber;
  final String address;
  final EStatus status;
  PatientDetails({
    required this.id,
    required this.name,
    required this.location,
    required this.action,
    required this.age,
    required this.gender,
    required this.contactNumber,
    required this.address,
    required this.status,
  });

  PatientDetails copyWith({
    String? id,
    String? name,
    Location? location,
    String? action,
    int? age,
    String? gender,
    String? contactNumber,
    String? address,
    EStatus? status,
  }) {
    return PatientDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      action: action ?? this.action,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location.toMap(),
      'action': action,
      'age': age,
      'gender': gender,
      'contactNumber': contactNumber,
      'address': address,
      'status': status.toString(),
    };
  }

  factory PatientDetails.fromMap(Map<String, dynamic> map) {
    return PatientDetails(
      id: map['id'],
      name: map['name'],
      location: Location.fromMap(map['location']),
      action: map['action'],
      age: map['age'],
      gender: map['gender'],
      contactNumber: map['contactNumber'],
      address: map['address'] ?? "",
      status: EStatus.values.firstWhere(
          (element) => element.toString() == "EStatus." + map["status"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientDetails.fromJson(String source) =>
      PatientDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PatientDetails(id: $id, name: $name, location: $location,action:$action, age: $age, gender: $gender, contactNumber: $contactNumber, address: $address, status:$status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientDetails &&
        other.id == id &&
        other.name == name &&
        other.location == location &&
        other.action == action &&
        other.age == age &&
        other.gender == gender &&
        other.contactNumber == contactNumber &&
        other.address == address &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        location.hashCode ^
        action.hashCode ^
        age.hashCode ^
        gender.hashCode ^
        contactNumber.hashCode ^
        address.hashCode ^
        status.hashCode;
  }
}

class DoctorDetails {
  final String id;
  final String name;
  final Location location;
  final String hospital;
  final String contactNumber;
  final String address;
  DoctorDetails({
    required this.id,
    required this.name,
    required this.location,
    required this.hospital,
    required this.contactNumber,
    required this.address,
  });

  DoctorDetails copyWith({
    String? id,
    String? name,
    Location? location,
    String? hospital,
    String? contactNumber,
    String? address,
  }) {
    return DoctorDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      hospital: hospital ?? this.hospital,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location.toMap(),
      'hospital': hospital,
      'contactNumber': contactNumber,
      'address': address,
    };
  }

  factory DoctorDetails.fromMap(Map<String, dynamic> map) {
    return DoctorDetails(
      id: map['id'],
      name: map['name'],
      location: Location.fromMap(map['location']),
      hospital: map['hospital'],
      contactNumber: map['contactNumber'],
      address: map['address'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorDetails.fromJson(String source) =>
      DoctorDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DoctorDetails(id: $id, name: $name, location: $location, hospital: $hospital, contactNumber: $contactNumber, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DoctorDetails &&
        other.id == id &&
        other.name == name &&
        other.location == location &&
        other.hospital == hospital &&
        other.contactNumber == contactNumber &&
        other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        location.hashCode ^
        hospital.hashCode ^
        contactNumber.hashCode ^
        address.hashCode;
  }
}

class DriverDetails {
  final String id;
  final String name;
  final Location location;
  final String plateNumber;
  final String contactNumber;
  final String address;
  DriverDetails({
    required this.id,
    required this.name,
    required this.location,
    required this.plateNumber,
    required this.contactNumber,
    required this.address,
  });

  DriverDetails copyWith({
    String? id,
    String? name,
    Location? location,
    String? plateNumber,
    String? contactNumber,
    String? address,
  }) {
    return DriverDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      plateNumber: plateNumber ?? this.plateNumber,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location.toMap(),
      'plateNumber': plateNumber,
      'contactNumber': contactNumber,
      'address': address,
    };
  }

  factory DriverDetails.fromMap(Map<String, dynamic> map) {
    return DriverDetails(
      id: map['id'],
      name: map['name'],
      location: Location.fromMap(map['location']),
      plateNumber: map['plateNumber'],
      contactNumber: map['contactNumber'],
      address: map['address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverDetails.fromJson(String source) =>
      DriverDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DriverDetails(id: $id, name: $name, location: $location, plateNumber: $plateNumber, contactNumber: $contactNumber, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DriverDetails &&
        other.id == id &&
        other.name == name &&
        other.location == location &&
        other.plateNumber == plateNumber &&
        other.contactNumber == contactNumber &&
        other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        location.hashCode ^
        plateNumber.hashCode ^
        contactNumber.hashCode ^
        address.hashCode;
  }
}
