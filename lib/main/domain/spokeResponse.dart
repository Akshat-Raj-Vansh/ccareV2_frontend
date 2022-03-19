//@dart=2.9
import 'dart:convert';

class SpokeResponse {
  static Map<ChestP, String> chestMapping = {
    ChestP.nill: "nill",
    ChestP.NC: "Not changed at all",
    ChestP.PD: "Partially decreased",
    ChestP.CD: "Completely disappeared",
  };
  static Map<STE, String> steMapping = {
    STE.nill: "nill",
    STE.A: "Elevation normalized completely",
    STE.B: "Regressed by more than 70",
    STE.C: "Decreased by 50 to 70%",
    STE.D: "regressed by less than 50% from "
  };
  static Map<SRes, String> steResMapping = {
    SRes.nill: "nill",
    SRes.A: "No resolution",
    SRes.B: "Partial resolution",
    SRes.C: "Complete resolution",
  };

  getChestString() {
    return chestMapping[this.chest_pain];
  }

  getSteString() {
    return steMapping[this.st_elevation];
  }

  getSResString() {
    return steResMapping[this.st_segment_res];
  }

  static _getSResString(SRes sRes) {
    return steResMapping[sRes];
  }

  static _getChestString(ChestP value) {
    return chestMapping[value];
  }

  static _getSteString(STE value) {
    return steMapping[value];
  }

  String note;
  ChestP chest_pain;
  STE st_elevation;
  SRes st_segment_res;
  SpokeResponse(
    this.note,
    this.chest_pain,
    this.st_elevation,
    this.st_segment_res,
  );

  SpokeResponse.initialize() {
    this.note =
        "Data to be shared by doctors at spoke centre after one hour of initiating thrombolytic treatment as advised from hub centre.";
    this.chest_pain = ChestP.nill;
    this.st_elevation = STE.nill;
    this.st_segment_res = SRes.nill;
  }

  Map<String, dynamic> toMap() {
    return {
      'note': note,
      'chest_pain': chest_pain.toString().split(".")[1],
      'st_elevation': st_elevation.toString().split(".")[1],
      'st_segment_res': st_segment_res.toString().split(".")[1],
    };
  }

  factory SpokeResponse.fromMap(Map<String, dynamic> map) {
    return SpokeResponse(
        map['note'] ?? '',
        ChestP.values.firstWhere((element) =>
                element.toString() == "ChestP." + map['chest_pain']) ??
            ChestP.nill,
        STE.values.firstWhere((element) =>
                element.toString() == "STE." + map['st_elevation']) ??
            STE.nill,
        SRes.values.firstWhere((element) =>
                element.toString() == "SRes." + map['st_segment_res']) ??
            SRes.nill);
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
enum SRes { A, B, C, nill }
