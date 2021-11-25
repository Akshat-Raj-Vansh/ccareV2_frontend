import 'dart:convert';

class Info {
  final String name;
  final String hospital;
  final String phone;
  Info({
    required this.name,
    required this.hospital,
    required this.phone,
  });

  Info copyWith({
    String? name,
    String? hospital,
    String? phone,
  }) {
    return Info(
      name: name ?? this.name,
      hospital: hospital ?? this.hospital,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hospital': hospital,
      'phone': phone,
    };
  }

  factory Info.fromMap(Map<String, dynamic> map) {
    return Info(
      name: map['name'],
      hospital: map['hospital'],
      phone: map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Info.fromJson(String source) => Info.fromMap(json.decode(source));

  @override
  String toString() => 'Info(name: $name, hospital: $hospital, phone:$phone)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Info &&
        other.name == name &&
        other.hospital == hospital &&
        other.phone == phone;
  }

  @override
  int get hashCode => name.hashCode ^ hospital.hashCode ^ phone.hashCode;
}
