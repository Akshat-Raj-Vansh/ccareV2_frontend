import 'dart:convert';


class HubInfo {
final String name;
final String hospitalName;
final String email;
final String phoneNumber;
final String id;
  HubInfo({
    required this.name,
    required this.hospitalName,
    required this.email,
    required this.phoneNumber,
    required this.id,
  });

  HubInfo copyWith({
    String? name,
    String? hospitalName,
    String? email,
    String? phoneNumber,
    String? id,
  }) {
    return HubInfo(
      name: name ?? this.name,
      hospitalName: hospitalName ?? this.hospitalName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hospitalName': hospitalName,
      'email': email,
      'phoneNumber': phoneNumber,
      'id': id,
    };
  }

  factory HubInfo.fromMap(Map<String, dynamic> map) {
    return HubInfo(
      name: map['name'],
      hospitalName: map['hospitalName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HubInfo.fromJson(String source) => HubInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HubInfo(name: $name, hospitalName: $hospitalName, email: $email, phoneNumber: $phoneNumber, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is HubInfo &&
      other.name == name &&
      other.hospitalName == hospitalName &&
      other.email == email &&
      other.phoneNumber == phoneNumber &&
      other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      hospitalName.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      id.hashCode;
  }
}
