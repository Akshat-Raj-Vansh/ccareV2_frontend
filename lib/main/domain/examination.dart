//@dart=2.9
import 'dart:convert';

import 'package:ccarev2_frontend/main/domain/treatment.dart';

class Examination {
  NTreatment nTreatment;
  Thrombolysis thrombolysis;
  Examination({
    this.nTreatment,
    this.thrombolysis,
  });

  Examination.initialize() {
    this.nTreatment = NTreatment.initialize();
    this.thrombolysis = Thrombolysis.initialize();
    print('-----------------------------');
    print(this.nTreatment.toString());
    print(this.thrombolysis.toString());
  }

  Examination copyWith({
    NTreatment nTreatment,
    Thrombolysis thrombolysis,
  }) {
    return Examination(
      nTreatment: nTreatment ?? this.nTreatment,
      thrombolysis: thrombolysis ?? this.thrombolysis,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'normalTreatment': nTreatment.toMap(),
      'thrombolysis': thrombolysis.toMap(),
    };
  }

  factory Examination.fromMap(Map<String, dynamic> map) {
    print('NTR');
    print(NTreatment.fromMap(map['normalTreatment']));
    return Examination(
      nTreatment: NTreatment.fromMap(map['normalTreatment']),
      thrombolysis: Thrombolysis.fromMap(map['thrombolysis']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Examination.fromJson(String source) =>
      Examination.fromMap(json.decode(source));

  @override
  String toString() =>
      'Examination(nTreatment: $nTreatment, thrombolysis: $thrombolysis)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Examination &&
        other.nTreatment == nTreatment &&
        other.thrombolysis == thrombolysis;
  }

  @override
  int get hashCode => nTreatment.hashCode ^ thrombolysis.hashCode;
}

class NTreatment {
  YN aspirin_loading;
  YN c_p_t_loading;
  String lmwh;
  String statins;
  String beta_blockers;
  String nitrates;
  String diuretics;
  String acei_arb;
  NTreatment({
    this.aspirin_loading,
    this.c_p_t_loading,
    this.lmwh,
    this.statins,
    this.beta_blockers,
    this.nitrates,
    this.diuretics,
    this.acei_arb,
  });

  NTreatment.initialize() {
    this.aspirin_loading = YN.nill;
    this.c_p_t_loading = YN.nill;
    this.lmwh = "nill";
    this.statins = "nill";
    this.beta_blockers = "nill";
    this.nitrates = "nill";
    this.diuretics = "nill";
    this.acei_arb = "nill";
  }

  NTreatment copyWith({
    YN aspirin_loading,
    YN c_p_t_loading,
    String lmwh,
    String statins,
    String beta_blockers,
    String nitrates,
    String diuretics,
    String acei_arb,
  }) {
    return NTreatment(
      aspirin_loading: aspirin_loading ?? this.aspirin_loading,
      c_p_t_loading: c_p_t_loading ?? this.c_p_t_loading,
      lmwh: lmwh ?? this.lmwh,
      statins: statins ?? this.statins,
      beta_blockers: beta_blockers ?? this.beta_blockers,
      nitrates: nitrates ?? this.nitrates,
      diuretics: diuretics ?? this.diuretics,
      acei_arb: acei_arb ?? this.acei_arb,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'aspirin_loading': aspirin_loading.toString().split('.')[1],
      'c_p_t_loading': c_p_t_loading.toString().split('.')[1],
      'lmwh': lmwh == "" ? "nill" : lmwh,
      'statins': statins == "" ? "nill" : statins,
      'beta_blockers': beta_blockers == "" ? "nill" : beta_blockers,
      'nitrates': nitrates == "" ? "nill" : nitrates,
      'diuretics': diuretics == "" ? "nill" : diuretics,
      'acei_arb': acei_arb == "" ? "nill" : acei_arb,
    };
  }

  factory NTreatment.fromMap(Map<String, dynamic> map) {
    YN ynCheck(String value) {
      if (value == "no")
        return YN.no;
      else if (value == "yes") return YN.yes;
      return YN.nill;
    }

    return NTreatment(
      aspirin_loading: ynCheck(map['aspirin_loading']),
      c_p_t_loading: ynCheck(map['c_p_t_loading']),
      lmwh: map['lmwh'],
      statins: map['statins'],
      beta_blockers: map['beta_blockers'],
      nitrates: map['nitrates'],
      diuretics: map['diuretics'],
      acei_arb: map['acei_arb'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NTreatment.fromJson(String source) =>
      NTreatment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NTreatment(aspirin_loading: $aspirin_loading, c_p_t_loading: $c_p_t_loading, lmwh: $lmwh, statins: $statins, beta_blockers: $beta_blockers, nitrates: $nitrates, diuretics: $diuretics, acei_arb: $acei_arb)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NTreatment &&
        other.aspirin_loading == aspirin_loading &&
        other.c_p_t_loading == c_p_t_loading &&
        other.lmwh == lmwh &&
        other.statins == statins &&
        other.beta_blockers == beta_blockers &&
        other.nitrates == nitrates &&
        other.diuretics == diuretics &&
        other.acei_arb == acei_arb;
  }

  @override
  int get hashCode {
    return aspirin_loading.hashCode ^
        c_p_t_loading.hashCode ^
        lmwh.hashCode ^
        statins.hashCode ^
        beta_blockers.hashCode ^
        nitrates.hashCode ^
        diuretics.hashCode ^
        acei_arb.hashCode;
  }
}

class Thrombolysis {
  YN tnk_alu_stk_successful;
  YN death;
  YN referral;
  String reason_for_referral;
  Thrombolysis({
    this.tnk_alu_stk_successful,
    this.death,
    this.referral,
    this.reason_for_referral,
  });

  Thrombolysis.initialize() {
    this.tnk_alu_stk_successful = YN.nill;
    this.death = YN.nill;
    this.referral = YN.nill;
    this.reason_for_referral = "nill";
  }

  Thrombolysis copyWith({
    YN tnk_alu_stk_successful,
    YN death,
    YN referral,
    String reason_for_referral,
  }) {
    return Thrombolysis(
      tnk_alu_stk_successful:
          tnk_alu_stk_successful ?? this.tnk_alu_stk_successful,
      death: death ?? this.death,
      referral: referral ?? this.referral,
      reason_for_referral: reason_for_referral ?? this.reason_for_referral,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tnk_alu_stk_successful': tnk_alu_stk_successful.toString().split('.')[1],
      'death': death.toString().split('.')[1],
      'referral': referral.toString().split('.')[1],
      'reason_for_referral':
          reason_for_referral == "" ? "nill" : reason_for_referral,
    };
  }

  factory Thrombolysis.fromMap(Map<String, dynamic> map) {
    YN ynCheck(String value) {
      if (value == "no")
        return YN.no;
      else if (value == "yes") return YN.yes;
      return YN.nill;
    }

    return Thrombolysis(
      tnk_alu_stk_successful: ynCheck(map['tnk_alu_stk_successful']),
      death: ynCheck(map['death']),
      referral: ynCheck(map['referral']),
      reason_for_referral: map['reason_for_referral'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Thrombolysis.fromJson(String source) =>
      Thrombolysis.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Thrombolysis(tnk_alu_stk_successful: $tnk_alu_stk_successful, death: $death, referral: $referral, reason_for_referral: $reason_for_referral)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Thrombolysis &&
        other.tnk_alu_stk_successful == tnk_alu_stk_successful &&
        other.death == death &&
        other.referral == referral &&
        other.reason_for_referral == reason_for_referral;
  }

  @override
  int get hashCode {
    return tnk_alu_stk_successful.hashCode ^
        death.hashCode ^
        referral.hashCode ^
        reason_for_referral.hashCode;
  }
}
