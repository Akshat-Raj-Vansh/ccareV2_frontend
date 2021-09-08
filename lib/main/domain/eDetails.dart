
import 'dart:convert';

import 'package:ccarev2_frontend/user/domain/location.dart';

class EDetails {
  PatientDetails ? patientDetails;
  DoctorDetails ? doctorDetails;
  DriverDetails ? driverDetails;
  EDetails({
    this.patientDetails,
    this.doctorDetails,
    this.driverDetails,
  });

  EDetails copyWith({
    PatientDetails ? patientDetails,
    DoctorDetails ? doctorDetails,
    DriverDetails ? driverDetails,
  }) {
    return EDetails(
      patientDetails: patientDetails ?? this.patientDetails,
      doctorDetails: doctorDetails ?? this.doctorDetails,
      driverDetails: driverDetails ?? this.driverDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientDetails': patientDetails?.toMap(),
      'doctorDetails': doctorDetails?.toMap(),
      'driverDetails': driverDetails?.toMap(),
    };
  }

  factory EDetails.fromMap(Map<String, dynamic> map) {
    return EDetails(
      patientDetails: map['patientDetails']!=null?PatientDetails .fromMap(map['patientDetails']):null,
      doctorDetails: map['doctorDetails']!=null?DoctorDetails .fromMap(map['doctorDetails']):null,
      driverDetails: map['driverDetails']!=null?DriverDetails .fromMap(map['driverDetails']):null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EDetails.fromJson(String source) => EDetails.fromMap(json.decode(source));

  @override
  String toString() => 'EDetails(patientDetails: $patientDetails, doctorDetails: $doctorDetails, driverDetails: $driverDetails)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is EDetails &&
      other.patientDetails == patientDetails &&
      other.doctorDetails == doctorDetails &&
      other.driverDetails == driverDetails;
  }

  @override
  int get hashCode => patientDetails.hashCode ^ doctorDetails.hashCode ^ driverDetails.hashCode;
}



class PatientDetails {
    final String name;
   final Location location;
    final int age;
    final String gender;
    final String contactNumber;    
  PatientDetails({
    required this.name,
    required this.location,
    required this.age,
    required this.gender,
    required this.contactNumber,
  });

  PatientDetails copyWith({
    String? name,
    Location? location,
    int? age,
    String? gender,
    String? contactNumber,
  }) {
    return PatientDetails(
      name: name ?? this.name,
      location: location ?? this.location,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      contactNumber: contactNumber ?? this.contactNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location.toMap(),
      'age': age,
      'gender': gender,
      'contactNumber': contactNumber,
    };
  }

  factory PatientDetails.fromMap(Map<String, dynamic> map) {
    return PatientDetails(
      name: map['name'],
      location: Location.fromMap(map['location']),
      age: map['age'],
      gender: map['gender'],
      contactNumber: map['contactNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientDetails.fromJson(String source) => PatientDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PatientDetails(name: $name, location: $location, age: $age, gender: $gender, contactNumber: $contactNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PatientDetails &&
      other.name == name &&
      other.location == location &&
      other.age == age &&
      other.gender == gender &&
      other.contactNumber == contactNumber;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      location.hashCode ^
      age.hashCode ^
      gender.hashCode ^
      contactNumber.hashCode;
  }
}

class DoctorDetails {
   final String name;
   final Location location;
    final String hospital;
    final String contactNumber;  
  DoctorDetails({
    required this.name,
    required this.location,
    required this.hospital,
    required this.contactNumber,
  });

  DoctorDetails copyWith({
    String? name,
    Location? location,
    String? hospital,
    String? contactNumber,
  }) {
    return DoctorDetails(
      name: name ?? this.name,
      location: location ?? this.location,
      hospital: hospital ?? this.hospital,
      contactNumber: contactNumber ?? this.contactNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location.toMap(),
      'hospital': hospital,
      'contactNumber': contactNumber,
    };
  }

  factory DoctorDetails.fromMap(Map<String, dynamic> map) {
    return DoctorDetails(
      name: map['name'],
      location: Location.fromMap(map['location']),
      hospital: map['hospital'],
      contactNumber: map['contactNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorDetails.fromJson(String source) => DoctorDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DoctorDetails(name: $name, location: $location, hospital: $hospital, contactNumber: $contactNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DoctorDetails &&
      other.name == name &&
      other.location == location &&
      other.hospital == hospital &&
      other.contactNumber == contactNumber;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      location.hashCode ^
      hospital.hashCode ^
      contactNumber.hashCode;
  }
}


class DriverDetails {
   final String name;
   final Location location;
    final String plateNumber;
    final String contactNumber;  
  DriverDetails({
    required this.name,
    required this.location,
    required this.plateNumber,
    required this.contactNumber,
  });

  DriverDetails copyWith({
    String? name,
    Location? location,
    String? plateNumber,
    String? contactNumber,
  }) {
    return DriverDetails(
      name: name ?? this.name,
      location: location ?? this.location,
      plateNumber: plateNumber ?? this.plateNumber,
      contactNumber: contactNumber ?? this.contactNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location.toMap(),
      'plateNumber': plateNumber,
      'contactNumber': contactNumber,
    };
  }

  factory DriverDetails.fromMap(Map<String, dynamic> map) {
    return DriverDetails(
      name: map['name'],
      location: Location.fromMap(map['location']),
      plateNumber: map['plateNumber'],
      contactNumber: map['contactNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverDetails.fromJson(String source) => DriverDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DriverDetails(name: $name, location: $location, plateNumber: $plateNumber, contactNumber: $contactNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DriverDetails &&
      other.name == name &&
      other.location == location &&
      other.plateNumber == plateNumber &&
      other.contactNumber == contactNumber;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      location.hashCode ^
      plateNumber.hashCode ^
      contactNumber.hashCode;
  }
}
