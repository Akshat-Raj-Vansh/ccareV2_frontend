import 'dart:convert';

import 'package:collection/collection.dart';

class PatientAssessment {
  final String question;
  final List<String> answer;
  PatientAssessment({
    required this.question,
    required this.answer,
  });

  PatientAssessment copyWith({
    String? question,
    List<String>? answer,
  }) {
    return PatientAssessment(
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }

  factory PatientAssessment.fromMap(Map<String, dynamic> map) {
    return PatientAssessment(
      question: map['question'] ?? '',
      answer: List<String>.from(map['answer']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientAssessment.fromJson(String source) =>
      PatientAssessment.fromMap(json.decode(source));

  @override
  String toString() =>
      'PatientAssessment(question: $question, answer: $answer)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is PatientAssessment &&
        other.question == question &&
        listEquals(other.answer, answer);
  }

  @override
  int get hashCode => question.hashCode ^ answer.hashCode;
}
