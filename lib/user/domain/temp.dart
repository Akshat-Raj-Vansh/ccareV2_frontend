//@dart=2.9
import 'dart:convert';

class Temp {
  final bool doctorAccepted;
  final bool driverAccepted;
  final bool notificationSent;
  Temp({
    this.doctorAccepted,
    this.driverAccepted,
    this.notificationSent,
  });

  Temp copyWith({
    bool doctorAccepted,
    bool driverAccepted,
    bool notificationSent,
  }) {
    return Temp(
      doctorAccepted: doctorAccepted ?? this.doctorAccepted,
      driverAccepted: driverAccepted ?? this.driverAccepted,
      notificationSent: notificationSent ?? this.notificationSent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorAccepted': doctorAccepted,
      'driverAccepted': driverAccepted,
      'notificationSent': notificationSent,
    };
  }

  factory Temp.fromMap(Map<String, dynamic> map) {
    return Temp(
      doctorAccepted: map['doctorAccepted'],
      driverAccepted: map['driverAccepted'],
      notificationSent: map['notificationSent'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Temp.fromJson(String source) => Temp.fromMap(json.decode(source));

  @override
  String toString() =>
      'Temp(doctorAccepted: $doctorAccepted, driverAccepted: $driverAccepted, notificationSent: $notificationSent)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Temp &&
        other.doctorAccepted == doctorAccepted &&
        other.driverAccepted == driverAccepted &&
        other.notificationSent == notificationSent;
  }

  @override
  int get hashCode =>
      doctorAccepted.hashCode ^
      driverAccepted.hashCode ^
      notificationSent.hashCode;
}
