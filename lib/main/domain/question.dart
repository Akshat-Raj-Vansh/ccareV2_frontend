import 'dart:convert';

import 'package:collection/collection.dart';

class QuestionTree {
  final String question;
  final String parent;
  final String when;
  final List<String> options;
  final QuestionType question_type;
  final NodeType node_type;
  bool status = false;
  List<String> answers = [];
  QuestionTree({
    required this.question,
    required this.parent,
    required this.when,
    required this.options,
    required this.question_type,
    required this.node_type,
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
      question_type: questionType ?? this.question_type,
      node_type: nodeType ?? this.node_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'parent': parent,
      'when': when,
      'options': options,
      'questionType': question_type.toString(),
      'nodeType': node_type.toString(),
    };
  }

  factory QuestionTree.fromMap(Map<String, dynamic> map) {
    print(map["questionType"]);
    return QuestionTree(
      question: map['question'],
      parent: map['parent'],
      when: map['when'],
      options: List<String>.from(map['options']),
      question_type: QuestionType.values.firstWhere((element) =>
          element.toString() == "QuestionType." + map["question_type"]),
      node_type: NodeType.values.firstWhere(
          (element) => element.toString() == "NodeType." + map["node_type"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionTree.fromJson(String source) =>
      QuestionTree.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuestionTree(question: $question, parent: $parent, when: $when, options: $options, question_type: $question_type, node_type: $node_type)';
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
        other.question_type == question_type &&
        other.node_type == node_type;
  }

  @override
  int get hashCode {
    return question.hashCode ^
        parent.hashCode ^
        when.hashCode ^
        options.hashCode ^
        question_type.hashCode ^
        node_type.hashCode;
  }

  answer(List<String> option) {
    answers = option;
    status = true;
  }
}

enum QuestionType { BOOLEAN, MCQ, SELECTION, _ }
enum NodeType { QUESTION, RESULT }
