import 'dart:convert';

import 'package:ccarev2_frontend/user/domain/doc_info.dart';

class HubInfo {
  final Info docInfo;
  final String docUID;
  HubInfo({
    required this.docInfo,
    required this.docUID,
  });

  HubInfo copyWith({
    Info? docInfo,
    String? docUID,
  }) {
    return HubInfo(
      docInfo: docInfo ?? this.docInfo,
      docUID: docUID ?? this.docUID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docInfo': docInfo.toMap(),
      'docUID': docUID,
    };
  }

  factory HubInfo.fromMap(Map<String, dynamic> map) {
    return HubInfo(
      docInfo: Info.fromMap(map['docInfo']),
      docUID: map['docUID'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HubInfo.fromJson(String source) =>
      HubInfo.fromMap(json.decode(source));

  @override
  String toString() => 'HubInfo(docInfo: $docInfo, docUID: $docUID)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HubInfo &&
        other.docInfo == docInfo &&
        other.docUID == docUID;
  }

  @override
  int get hashCode => docInfo.hashCode ^ docUID.hashCode;
}
