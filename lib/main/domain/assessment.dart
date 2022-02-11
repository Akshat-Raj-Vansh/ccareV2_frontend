import 'dart:convert';

class PatientAssessment {
  final String question;
  final String answer;
  PatientAssessment({
    required this.question,
    required this.answer,
  });

  PatientAssessment copyWith({
    String? question,
    String? answer,
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
      answer: map['answer'] ?? '',
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

    return other is PatientAssessment &&
        other.question == question &&
        other.answer == answer;
  }

  @override
  int get hashCode => question.hashCode ^ answer.hashCode;
}
