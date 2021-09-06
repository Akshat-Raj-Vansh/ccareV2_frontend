//@dart=2.9
import 'dart:convert';

import 'package:ccarev2_frontend/user/domain/location.dart';

class ELocations {
   Location patientLocation;
   Location doctorLocation;
   Location driverLocation;

  ELocations({
    this.patientLocation,
    this.doctorLocation,
    this.driverLocation,}
  );


  Map<String, dynamic> toMap() {
    return {
      'patientLocation': patientLocation.toMap(),
      'doctorLocation': doctorLocation.toMap(),
      'driverLocation': driverLocation.toMap(),
    };
  }

  factory ELocations.fromMap(Map<String, dynamic> map) {
    return ELocations(
      patientLocation: Location.fromMap(map['patientLocation']),
      doctorLocation: Location.fromMap(map['doctorLocation']),
      driverLocation: Location.fromMap(map['driverLocation']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ELocations.fromJson(String source) => ELocations.fromMap(json.decode(source));

  @override
  String toString() => 'ELocations(patientLocation: $patientLocation, doctorLocation: $doctorLocation, driverLocation: $driverLocation)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ELocations &&
      other.patientLocation == patientLocation &&
      other.doctorLocation == doctorLocation &&
      other.driverLocation == driverLocation;
  }

  @override
  int get hashCode => patientLocation.hashCode ^ doctorLocation.hashCode ^ driverLocation.hashCode;
}
