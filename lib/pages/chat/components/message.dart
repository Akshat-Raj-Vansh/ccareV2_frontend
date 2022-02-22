import 'dart:convert';

class Message {
  final String text;
  final String senderID;
  final String receiverID;
  final String type;
  final String time;
  String? path;
  Message(this.text, this.senderID, this.receiverID, this.type, this.time,
      {this.path});

  Message copyWith({
    String? text,
    String? senderID,
    String? receiverID,
    String? type,
    String? time,
    String? path,
  }) {
    return Message(text ?? this.text, senderID ?? this.senderID,
        receiverID ?? this.receiverID, type ?? this.type, time ?? this.time,
        path: path ?? this.path);
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderID': senderID,
      'receiverID': receiverID,
      'type': type,
      'time': time,
      'path': path,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      map['text'] ?? '',
      map['senderID'] ?? '',
      map['receiverID'] ?? '',
      map['type'] ?? '',
      map['time'] ?? '',
      path: map['path'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(text: $text, senderID: $senderID, receiverID: $receiverID, type: $type, time: $time, path: $path)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.text == text &&
        other.senderID == senderID &&
        other.receiverID == receiverID &&
        other.type == type &&
        other.time == time &&
        other.path == path;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        senderID.hashCode ^
        receiverID.hashCode ^
        type.hashCode ^
        time.hashCode ^
        path.hashCode;
  }
}
