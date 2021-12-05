import 'dart:convert';

class Message {
  final String text;
  final String senderID;
  final String receiverID;

  Message(
    this.text,
    this.senderID,
    this.receiverID,
  );

  Message copyWith({
    String? text,
    String? senderID,
    String? receiverID,
  }) {
    return Message(
      text ?? this.text,
      senderID ?? this.senderID,
      receiverID ?? this.receiverID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderID': senderID,
      'receiverID': receiverID,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      map['message'],
      map['from'],
      map['to'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() =>
      'Message(text: $text, senderID: $senderID, receiverID: $receiverID)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.text == text &&
        other.senderID == senderID &&
        other.receiverID == receiverID;
  }

  @override
  int get hashCode => text.hashCode ^ senderID.hashCode ^ receiverID.hashCode;
}
