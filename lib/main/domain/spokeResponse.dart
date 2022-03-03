//@dart=2.9
import 'dart:convert';

class SpokeResponse {
  Map<ChestP, String> chestMapping = {
    ChestP.NC: "Not changed at all",
    ChestP.PD: "Partially decreased",
    ChestP.CD: "Completely disappeared",
  };
  Map<STE, String> steMapping = {
    STE.A: "Elevation normalized completely",
    STE.B: "Regressed by more than 70",
    STE.C: "Decreased by 50 to 70%",
    STE.D: "regressed by less than 50% from "
  };

  getChestString() {
    return chestMapping[this.chest_pain];
  }

  getSteString() {
    return steMapping[this.st_elevation];
  }

  final String note;
  final ChestP chest_pain;
  final STE st_elevation;
  SpokeResponse(
    this.note,
    this.chest_pain,
    this.st_elevation,
  );

  Map<String, dynamic> toMap() {
    return {
      'note': note,
      'chest_pain': chest_pain.toString().split(".")[1],
      'st_elevation': st_elevation.toString().split(".")[1],
    };
  }

  factory SpokeResponse.fromMap(Map<String, dynamic> map) {
    return SpokeResponse(
      map['note'] ?? '',
      ChestP.values.firstWhere((element) =>
              element.toString() == "ChestP" + map['chest_pain']) ??
          ChestP.nill,
      STE.values.firstWhere(
              (element) => element.toString() == "STE" + map['st_elevation']) ??
          STE.nill,
    );
  }

  String toJson() => json.encode(toMap());

  factory SpokeResponse.fromJson(String source) =>
      SpokeResponse.fromMap(json.decode(source));

  @override
  String toString() =>
      'SpokeResponse(note: $note, chest_pain: $chest_pain, st_elevation: $st_elevation)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpokeResponse &&
        other.note == note &&
        other.chest_pain == chest_pain &&
        other.st_elevation == st_elevation;
  }

  @override
  int get hashCode =>
      note.hashCode ^ chest_pain.hashCode ^ st_elevation.hashCode;
}

enum ChestP { NC, PD, CD, nill }
enum STE { A, B, C, D, nill }
