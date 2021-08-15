import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

class MedicalProfile {
  final String userId;
  final String firstName;
  final String lastName;
  final int height;
  final int weight;

  MedicalProfile(
    this.userId,
    this.firstName,
    this.lastName,
    this.height,
    this.weight,
  );

  MedicalProfile copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    int? height,
    int? weight,
  }) {
    return MedicalProfile(
      userId ?? this.userId,
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      height ?? this.height,
      weight ?? this.weight,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'height': height,
      'weight': weight,
    };
  }

  factory MedicalProfile.fromMap(Map<String, dynamic> map) {
    return MedicalProfile(
      map['_userId'],
      map['firstName'],
      map['lastName'],
      map['height'],
      map['weight'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicalProfile.fromJson(String source) =>
      MedicalProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MedicalProfile(userId:$userId, firstName: $firstName, lastName: $lastName,height: $height, weight: $weight)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is MedicalProfile &&
        other.userId == userId &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.height == height &&
        other.weight == weight;
  }
}
