import 'dart:convert';

class PatientListInfo {
  final String id;
  final String name;
  final int age;
  final String gender;
  PatientListInfo({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
  });

  PatientListInfo copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
  }) {
    return PatientListInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
    };
  }

  factory PatientListInfo.fromMap(Map<String, dynamic> map) {
    return PatientListInfo(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age']?.toInt() ?? 0,
      gender: map['gender'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientListInfo.fromJson(String source) =>
      PatientListInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PatientListInfo(id: $id, name: $name, age: $age, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientListInfo &&
        other.id == id &&
        other.name == name &&
        other.age == age &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ age.hashCode ^ gender.hashCode;
  }
}
