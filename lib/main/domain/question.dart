import 'dart:convert';

import 'package:collection/collection.dart';

class QuestionTree {
  final String question;
  final String parent;
  final String when;
  final List<String> options;
  final QuestionType questionType;
  final NodeType nodeType;
  bool status = false;
  late List<String> answers;
  QuestionTree({
    required this.question,
    required this.parent,
    required this.when,
    required this.options,
    required this.questionType,
    required this.nodeType,
  });

  QuestionTree copyWith({
    String? question,
    String? parent,
    String? when,
    List<String>? options,
    QuestionType? questionType,
    NodeType? nodeType,
  }) {
    return QuestionTree(
      question: question ?? this.question,
      parent: parent ?? this.parent,
      when: when ?? this.when,
      options: options ?? this.options,
      questionType: questionType ?? this.questionType,
      nodeType: nodeType ?? this.nodeType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'parent': parent,
      'when': when,
      'options': options,
      'questionType': questionType.toString(),
      'nodeType': nodeType.toString(),
    };
  }

  factory QuestionTree.fromMap(Map<String, dynamic> map) {
    print(map["questionType"]);
    return QuestionTree(
      question: map['question'],
      parent: map['parent'],
      when: map['when'],
      options: List<String>.from(map['options']),
      questionType: QuestionType.values.firstWhere((element) =>
          element.toString() == "QuestionType." + map["questionType"]),
      nodeType: NodeType.values.firstWhere(
          (element) => element.toString() == "NodeType." + map["nodeType"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionTree.fromJson(String source) =>
      QuestionTree.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuestionTree(question: $question, parent: $parent, when: $when, options: $options, questionType: $questionType, nodeType: $nodeType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is QuestionTree &&
        other.question == question &&
        other.parent == parent &&
        other.when == when &&
        listEquals(other.options, options) &&
        other.questionType == questionType &&
        other.nodeType == nodeType;
  }

  @override
  int get hashCode {
    return question.hashCode ^
        parent.hashCode ^
        when.hashCode ^
        options.hashCode ^
        questionType.hashCode ^
        nodeType.hashCode;
  }

  answer(List<String> option) {
    answers = option;
    status = true;
  }
}

enum QuestionType { BOOLEAN, MCQ, SELECTION }
enum NodeType { QUESTION, RESULT }
