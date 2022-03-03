//@dart=2.9
import 'dart:convert';

import 'package:collection/collection.dart';

class HubResponse {
  final EcgInterperation ecg;
  final Advice advice;
  HubResponse({
    this.ecg,
    this.advice,
  });

  HubResponse copyWith({
    EcgInterperation ecg,
    Advice advice,
  }) {
    return HubResponse(
      ecg: ecg ?? this.ecg,
      advice: advice ?? this.advice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ecg': ecg.toMap(),
      'advice': advice.toMap(),
    };
  }

  factory HubResponse.fromMap(Map<String, dynamic> map) {
    return HubResponse(
      ecg: EcgInterperation.fromMap(map['ecg']),
      advice: Advice.fromMap(map['advice']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HubResponse.fromJson(String source) =>
      HubResponse.fromMap(json.decode(source));

  @override
  String toString() => 'HubResponse(ecg: $ecg, advice: $advice)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HubResponse && other.ecg == ecg && other.advice == advice;
  }

  @override
  int get hashCode => ecg.hashCode ^ advice.hashCode;
}

class EcgInterperation {
  final Rythm rythm;
  final STElevation st_elevation;
  final STDepression st_depression;
  final TInversion t_wave_inversion;
  final BBBlock bbBlock;
  final YN lvh;
  final YN rvh;
  final YN rae;
  final YN lae;
  final Diagonis diagonis;
  EcgInterperation({
    this.rythm,
    this.st_elevation,
    this.st_depression,
    this.t_wave_inversion,
    this.bbBlock,
    this.lvh,
    this.rvh,
    this.rae,
    this.lae,
    this.diagonis,
  });

  EcgInterperation copyWith({
    Rythm rythm,
    STElevation st_elevation,
    STDepression st_depression,
    TInversion t_wave_inversion,
    BBBlock bbBlock,
    YN lvh,
    YN rvh,
    YN rae,
    YN lae,
    Diagonis diagonis,
  }) {
    return EcgInterperation(
      rythm: rythm ?? this.rythm,
      st_elevation: st_elevation ?? this.st_elevation,
      st_depression: st_depression ?? this.st_depression,
      t_wave_inversion: t_wave_inversion ?? this.t_wave_inversion,
      bbBlock: bbBlock ?? this.bbBlock,
      lvh: lvh ?? this.lvh,
      rvh: rvh ?? this.rvh,
      rae: rae ?? this.rae,
      lae: lae ?? this.lae,
      diagonis: diagonis ?? this.diagonis,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rythm': rythm.toString().split(".")[1],
      'st_elevation': st_elevation.toMap(),
      'st_depression': st_depression.toMap(),
      't_wave_inversion': t_wave_inversion.toMap(),
      'bbBlock': bbBlock.toString().split(".")[1],
      'lvh': lvh.toString().split(".")[1],
      'rvh': rvh.toString().split(".")[1],
      'rae': rae.toString().split(".")[1],
      'lae': lae.toString().split(".")[1],
      'diagonis': diagonis.toString().split(".")[1],
    };
  }

  factory EcgInterperation.fromMap(Map<String, dynamic> map) {
    YN ynCheck(String value) {
      if (value == "no")
        return YN.no;
      else if (value == "yes") return YN.yes;
      return YN.nill;
    }

    return EcgInterperation(
      rythm: Rythm.values.firstWhere(
          (element) => element.toString() == "Rythm." + map['rythm']),
      st_elevation: STElevation.fromMap(map['st_elevation']),
      st_depression: STDepression.fromMap(map['st_depression']),
      t_wave_inversion: TInversion.fromMap(map['t_wave_inversion']),
      bbBlock: BBBlock.values.firstWhere(
          (element) => element.toString() == "BBBlock." + map['bbblock']),
      lvh: ynCheck(map['lvh']),
      rvh: ynCheck(map['rvh']),
      rae: ynCheck(map['rae']),
      lae: ynCheck(map['lae']),
      diagonis: Diagonis.values.firstWhere(
          (element) => element.toString() == "Diagonis." + map['diagonis']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EcgInterperation.fromJson(String source) =>
      EcgInterperation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EcgInterperation(rythm: $rythm, st_elevation: $st_elevation, st_depression: $st_depression, t_wave_inversion: $t_wave_inversion, bbBlock: $bbBlock, lvh: $lvh, rvh: $rvh, rae: $rae, lae: $lae, diagonis: $diagonis)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EcgInterperation &&
        other.rythm == rythm &&
        other.st_elevation == st_elevation &&
        other.st_depression == st_depression &&
        other.t_wave_inversion == t_wave_inversion &&
        other.bbBlock == bbBlock &&
        other.lvh == lvh &&
        other.rvh == rvh &&
        other.rae == rae &&
        other.lae == lae &&
        other.diagonis == diagonis;
  }

  @override
  int get hashCode {
    return rythm.hashCode ^
        st_elevation.hashCode ^
        st_depression.hashCode ^
        t_wave_inversion.hashCode ^
        bbBlock.hashCode ^
        lvh.hashCode ^
        rvh.hashCode ^
        rae.hashCode ^
        lae.hashCode ^
        diagonis.hashCode;
  }
}

class Advice {
  final String ecg_repeat;
  final YN trop_i_repeat;
  final List<MedField> medicines;
  final YN oxygen_inhalation;
  final YN nebulization;
  final BioChemistry bioChemistry;
  Advice({
    this.ecg_repeat,
    this.trop_i_repeat,
    this.medicines,
    this.oxygen_inhalation,
    this.nebulization,
    this.bioChemistry,
  });

  Advice copyWith({
    String ecg_repeat,
    YN trop_i_repeat,
    List<MedField> medicines,
    YN oxygen_inhalation,
    YN nebulization,
    BioChemistry bioChemistry,
  }) {
    return Advice(
      ecg_repeat: ecg_repeat ?? this.ecg_repeat,
      trop_i_repeat: trop_i_repeat ?? this.trop_i_repeat,
      medicines: medicines ?? this.medicines,
      oxygen_inhalation: oxygen_inhalation ?? this.oxygen_inhalation,
      nebulization: nebulization ?? this.nebulization,
      bioChemistry: bioChemistry ?? this.bioChemistry,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ecg_repeat': ecg_repeat,
      'trop_i_repeat': trop_i_repeat.toString().split(".")[1],
      'medicines': medicines.map((x) => x.toMap()).toList(),
      'oxygen_inhalation': oxygen_inhalation.toString().split(".")[1],
      'nebulization': nebulization.toString().split(".")[1],
      'bioChemistry': bioChemistry.toMap(),
    };
  }

  factory Advice.fromMap(Map<String, dynamic> map) {
    YN ynCheck(String value) {
      if (value == "no")
        return YN.no;
      else if (value == "yes") return YN.yes;
      return YN.nill;
    }

    return Advice(
      ecg_repeat: map['ecg_repeat'] ?? '',
      trop_i_repeat: ynCheck(map['trop_i_repeat']),
      medicines: List<MedField>.from(
          map['medicines']?.map((x) => MedField.fromMap(x))),
      oxygen_inhalation: ynCheck(map['oxygen_inhalation']),
      nebulization: ynCheck(map['nebulization']),
      bioChemistry: BioChemistry.fromMap(map['bioChemistry']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Advice.fromJson(String source) => Advice.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Advice(ecg_repeat: $ecg_repeat, trop_i_repeat: $trop_i_repeat, medicines: $medicines, oxygen_inhalation: $oxygen_inhalation, nebulization: $nebulization, bioChemistry: $bioChemistry)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Advice &&
        other.ecg_repeat == ecg_repeat &&
        other.trop_i_repeat == trop_i_repeat &&
        listEquals(other.medicines, medicines) &&
        other.oxygen_inhalation == oxygen_inhalation &&
        other.nebulization == nebulization &&
        other.bioChemistry == bioChemistry;
  }

  @override
  int get hashCode {
    return ecg_repeat.hashCode ^
        trop_i_repeat.hashCode ^
        medicines.hashCode ^
        oxygen_inhalation.hashCode ^
        nebulization.hashCode ^
        bioChemistry.hashCode;
  }
}

class STElevation {
  final YN anterior;
  final YN posterior;
  final YN lateral;
  final YN inferior;
  final YN rv;
  STElevation({
    this.anterior,
    this.posterior,
    this.lateral,
    this.inferior,
    this.rv,
  });

  STElevation copyWith({
    YN anterior,
    YN posterior,
    YN lateral,
    YN inferior,
    YN rv,
  }) {
    return STElevation(
      anterior: anterior ?? this.anterior,
      posterior: posterior ?? this.posterior,
      lateral: lateral ?? this.lateral,
      inferior: inferior ?? this.inferior,
      rv: rv ?? this.rv,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'anterior': anterior.toString().split('.')[1],
      'posterior': posterior.toString().split('.')[1],
      'lateral': lateral.toString().split('.')[1],
      'inferior': inferior.toString().split('.')[1],
      'rv': rv.toString().split('.')[1],
    };
  }

  factory STElevation.fromMap(Map<String, dynamic> map) {
    YN ynCheck(String value) {
      if (value == "no")
        return YN.no;
      else if (value == "yes") return YN.yes;
      return YN.nill;
    }

    return STElevation(
      anterior: ynCheck(map['anterior']),
      posterior: ynCheck(map['posterior']),
      lateral: ynCheck(map['lateral']),
      inferior: ynCheck(map['inferior']),
      rv: ynCheck(map['rv']),
    );
  }

  String toJson() => json.encode(toMap());

  factory STElevation.fromJson(String source) =>
      STElevation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'STElevation(anterior: $anterior, posterior: $posterior, lateral: $lateral, inferior: $inferior, rv: $rv)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is STElevation &&
        other.anterior == anterior &&
        other.posterior == posterior &&
        other.lateral == lateral &&
        other.inferior == inferior &&
        other.rv == rv;
  }

  @override
  int get hashCode {
    return anterior.hashCode ^
        posterior.hashCode ^
        lateral.hashCode ^
        inferior.hashCode ^
        rv.hashCode;
  }
}

class STDepression {
  final YN inferior_lead;
  final YN lateral_lead;
  final YN anterior_lead;
  STDepression({
    this.inferior_lead,
    this.lateral_lead,
    this.anterior_lead,
  });

  STDepression copyWith({
    YN inferior_lead,
    YN lateral_lead,
    YN anterior_lead,
  }) {
    return STDepression(
      inferior_lead: inferior_lead ?? this.inferior_lead,
      lateral_lead: lateral_lead ?? this.lateral_lead,
      anterior_lead: anterior_lead ?? this.anterior_lead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inferior_lead': inferior_lead.toString().split(".")[1],
      'lateral_lead': lateral_lead.toString().split(".")[1],
      'anterior_lead': anterior_lead.toString().split(".")[1],
    };
  }

  factory STDepression.fromMap(Map<String, dynamic> map) {
    YN ynCheck(String value) {
      if (value == "no")
        return YN.no;
      else if (value == "yes") return YN.yes;
      return YN.nill;
    }

    return STDepression(
      inferior_lead: ynCheck(map['inferior_lead']),
      lateral_lead: ynCheck(map['lateral_lead']),
      anterior_lead: ynCheck(map['anterior_lead']),
    );
  }

  String toJson() => json.encode(toMap());

  factory STDepression.fromJson(String source) =>
      STDepression.fromMap(json.decode(source));

  @override
  String toString() =>
      'STDepression(inferior_lead: $inferior_lead, lateral_lead: $lateral_lead, anterior_lead: $anterior_lead)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is STDepression &&
        other.inferior_lead == inferior_lead &&
        other.lateral_lead == lateral_lead &&
        other.anterior_lead == anterior_lead;
  }

  @override
  int get hashCode =>
      inferior_lead.hashCode ^ lateral_lead.hashCode ^ anterior_lead.hashCode;
}

class TInversion {
  final YN inferior_lead;
  final YN lateral_lead;
  final YN anterior_lead;
  TInversion({
    this.inferior_lead,
    this.lateral_lead,
    this.anterior_lead,
  });

  TInversion copyWith({
    YN inferior_lead,
    YN lateral_lead,
    YN anterior_lead,
  }) {
    return TInversion(
      inferior_lead: inferior_lead ?? this.inferior_lead,
      lateral_lead: lateral_lead ?? this.lateral_lead,
      anterior_lead: anterior_lead ?? this.anterior_lead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inferior_lead': inferior_lead.toString().split(".")[1],
      'lateral_lead': lateral_lead.toString().split(".")[1],
      'anterior_lead': anterior_lead.toString().split(".")[1],
    };
  }

  factory TInversion.fromMap(Map<String, dynamic> map) {
    YN ynCheck(String value) {
      if (value == "no")
        return YN.no;
      else if (value == "yes") return YN.yes;
      return YN.nill;
    }

    return TInversion(
      inferior_lead: ynCheck(map['inferior_lead']),
      lateral_lead: ynCheck(map['lateral_lead']),
      anterior_lead: ynCheck(map['anterior_lead']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TInversion.fromJson(String source) =>
      TInversion.fromMap(json.decode(source));

  @override
  String toString() =>
      'STDepression(inferior_lead: $inferior_lead, lateral_lead: $lateral_lead, anterior_lead: $anterior_lead)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TInversion &&
        other.inferior_lead == inferior_lead &&
        other.lateral_lead == lateral_lead &&
        other.anterior_lead == anterior_lead;
  }

  @override
  int get hashCode =>
      inferior_lead.hashCode ^ lateral_lead.hashCode ^ anterior_lead.hashCode;
}

class BioChemistry {
  final YN sugar;
  final YN bu_creatinine;
  final YN electrolytes;
  final YN hemogram;

  BioChemistry({
    this.sugar,
    this.bu_creatinine,
    this.electrolytes,
    this.hemogram,
  });

  BioChemistry copyWith({
    YN sugar,
    YN bu_creatinine,
    YN electrolytes,
    YN hemogram,
  }) {
    return BioChemistry(
      sugar: sugar ?? this.sugar,
      bu_creatinine: bu_creatinine ?? this.bu_creatinine,
      electrolytes: electrolytes ?? this.electrolytes,
      hemogram: hemogram ?? this.hemogram,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sugar': sugar.toString().split(".")[1],
      'bu_creatinine': bu_creatinine.toString().split(".")[1],
      'electrolytes': electrolytes.toString().split(".")[1],
      'hemogram': hemogram.toString().split(".")[1],
    };
  }

  factory BioChemistry.fromMap(Map<String, dynamic> map) {
    YN ynCheck(String value) {
      if (value == "no")
        return YN.no;
      else if (value == "yes") return YN.yes;
      return YN.nill;
    }

    return BioChemistry(
      sugar: ynCheck(map['sugar']),
      bu_creatinine: ynCheck(map['bu_creatinine']),
      electrolytes: ynCheck(map['electrolytes']),
      hemogram: ynCheck(map['hemogram']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BioChemistry.fromJson(String source) =>
      BioChemistry.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BioChemistry(sugar: $sugar, bu_creatinine: $bu_creatinine, electrolytes: $electrolytes, hemogram: $hemogram)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BioChemistry &&
        other.sugar == sugar &&
        other.bu_creatinine == bu_creatinine &&
        other.electrolytes == electrolytes &&
        other.hemogram == hemogram;
  }

  @override
  int get hashCode {
    return sugar.hashCode ^
        bu_creatinine.hashCode ^
        electrolytes.hashCode ^
        hemogram.hashCode;
  }
}

class MedField {
  final String name;
  final YN value;

  MedField({
    this.name,
    this.value,
  });

  MedField copyWith({
    String name,
    YN value,
  }) {
    return MedField(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value.toString().split(".")[1],
    };
  }

  factory MedField.fromMap(Map<String, dynamic> map) {
    YN ynCheck(String value) {
      if (value == "no")
        return YN.no;
      else if (value == "yes") return YN.yes;
      return YN.nill;
    }

    return MedField(
      name: map['name'] ?? '',
      value: ynCheck(map['value']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MedField.fromJson(String source) =>
      MedField.fromMap(json.decode(source));

  @override
  String toString() => 'MedField(name: $name, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedField && other.name == name && other.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}

enum YN { nill, yes, no }
enum BBBlock { No, LBBB, RBBB, nill }
enum Diagonis { STEMI, NSTEMI, SACS, NCCP }
enum Rythm { NSR, A_Fib, A, V_Block }
