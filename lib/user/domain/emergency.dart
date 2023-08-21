import 'dart:convert';

class Emergency {
  double latitude;
  double longitude;
  bool ambulanceRequired;
  String action;
  Emergency({
    required this.latitude,
    required this.longitude,
    required this.ambulanceRequired,
    required this.action,
  });

  Emergency copyWith({
    double? latitude,
    double? longitude,
    bool? ambulanceRequired,
    String? action,
  }) {
    return Emergency(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ambulanceRequired: ambulanceRequired ?? this.ambulanceRequired,
      action: action ?? this.action,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'ambulanceRequired': ambulanceRequired,
      'action': action,
    };
  }

  factory Emergency.fromMap(Map<String, dynamic> map) {
    return Emergency(
      latitude: map['latitude'],
      longitude: map['longitude'],
      ambulanceRequired: map['ambulanceRequired'],
      action: map['action'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Emergency.fromJson(String source) =>
      Emergency.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Emergency(latitude: $latitude, longitude: $longitude, ambulanceRequired: $ambulanceRequired, action: $action)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Emergency &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.ambulanceRequired == ambulanceRequired &&
        other.action == action;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
        longitude.hashCode ^
        ambulanceRequired.hashCode ^
        action.hashCode;
  }
}
