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
    //print('-----------------------------');
    //print(this.nTreatment.toString());
    //print(this.thrombolysis.toString());
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
    //print('NTR');
    //print(NTreatment.fromMap(map['normalTreatment']));
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
  YN lmwh;
  YN ivbolus;
  YN inj_eno;
  Statins statins;
  String statins_dose;
  YN beta_blockers;
  YN nitrates;
  YN diuretics;
  YN acei_arb;
  NTreatment({
    this.aspirin_loading,
    this.c_p_t_loading,
    this.lmwh,
    this.ivbolus,
    this.inj_eno,
    this.statins,
    this.statins_dose,
    this.beta_blockers,
    this.nitrates,
    this.diuretics,
    this.acei_arb,
  });

  NTreatment.initialize() {
    this.aspirin_loading = YN.nill;
    this.c_p_t_loading = YN.nill;
    this.lmwh = YN.nill;
    this.ivbolus = YN.nill;
    this.inj_eno = YN.nill;
    this.statins = Statins.nill;
    this.statins_dose = 'nill';
    this.beta_blockers = YN.nill;
    this.nitrates = YN.nill;
    this.diuretics = YN.nill;
    this.acei_arb = YN.nill;
  }

  NTreatment copyWith({
    YN aspirin_loading,
    YN c_p_t_loading,
    YN lmwh,
    YN ivbolus,
    YN inj_eno,
    Statins statins,
    String statins_dose,
    YN beta_blockers,
    YN nitrates,
    YN diuretics,
    YN acei_arb,
  }) {
    return NTreatment(
      aspirin_loading: aspirin_loading ?? this.aspirin_loading,
      c_p_t_loading: c_p_t_loading ?? this.c_p_t_loading,
      lmwh: lmwh ?? this.lmwh,
      ivbolus: ivbolus ?? this.ivbolus,
      inj_eno: inj_eno ?? this.inj_eno,
      statins: statins ?? this.statins,
      statins_dose: statins_dose ?? this.statins_dose,
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
      'lmwh': lmwh.toString().split('.')[1],
      'ivbolus': ivbolus.toString().split('.')[1],
      'inj_eno': inj_eno.toString().split('.')[1],
      'statins': statins.toString().split('.')[1],
      'statins_dose': statins_dose == "" ? "nill" : statins_dose,
      'beta_blockers': beta_blockers.toString().split('.')[1],
      'nitrates': nitrates.toString().split('.')[1],
      'diuretics': diuretics.toString().split('.')[1],
      'acei_arb': acei_arb.toString().split('.')[1],
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
      lmwh: ynCheck(map['lmwh']),
      ivbolus: ynCheck(map['ivbolus']),
      inj_eno: ynCheck(map['inj_eno']),
      statins: Statins.values.firstWhere(
          (element) => element.toString() == "Statins." + map['statins']),
      statins_dose: map['statins_dose'],
      beta_blockers: ynCheck(map['beta_blockers']),
      nitrates: ynCheck(map['nitrates']),
      diuretics: ynCheck(map['diuretics']),
      acei_arb: ynCheck(map['acei_arb']),
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
        other.ivbolus == ivbolus &&
        other.statins == statins &&
        other.statins_dose == statins_dose &&
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
  YN thrombolysis;
  YN tnk_stk_ret;
  YN discharged;
  YN death;
  YN referral;
  String reason_for_referral;
  Thrombolysis({
    this.thrombolysis,
    this.tnk_stk_ret,
    this.discharged,
    this.death,
    this.referral,
    this.reason_for_referral,
  });

  Thrombolysis.initialize() {
    this.thrombolysis = YN.nill;
    this.tnk_stk_ret = YN.nill;
    this.discharged = YN.nill;
    this.death = YN.nill;
    this.referral = YN.nill;
    this.reason_for_referral = "nill";
  }

  Thrombolysis copyWith({
    YN thrombolysis,
    YN tnk_stk_ret,
    YN discharged,
    YN death,
    YN referral,
    String reason_for_referral,
  }) {
    return Thrombolysis(
      thrombolysis: thrombolysis ?? this.thrombolysis,
      tnk_stk_ret: tnk_stk_ret ?? this.tnk_stk_ret,
      discharged: discharged ?? this.discharged,
      death: death ?? this.death,
      referral: referral ?? this.referral,
      reason_for_referral: reason_for_referral ?? this.reason_for_referral,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'thrombolysis': thrombolysis.toString().split('.')[1],
      'tnk_stk_ret': tnk_stk_ret.toString().split('.')[1],
      'discharged': discharged.toString().split('.')[1],
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
      thrombolysis: ynCheck(map['thrombolysis']),
      tnk_stk_ret: ynCheck(map['tnk_stk_ret']),
      discharged: ynCheck(map['discharged']),
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
    return 'Thrombolysis(thrombolysis: $thrombolysis, death: $death, referral: $referral, reason_for_referral: $reason_for_referral)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Thrombolysis &&
        other.thrombolysis == thrombolysis &&
        other.tnk_stk_ret == tnk_stk_ret &&
        other.discharged == discharged &&
        other.death == death &&
        other.referral == referral &&
        other.reason_for_referral == reason_for_referral;
  }

  @override
  int get hashCode {
    return thrombolysis.hashCode ^
        death.hashCode ^
        referral.hashCode ^
        reason_for_referral.hashCode;
  }
}
