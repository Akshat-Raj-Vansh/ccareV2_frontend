import 'dart:convert';

import 'package:ccarev2_frontend/main/domain/treatment.dart';

class Examination {
  late NTreatment nTreatment;
  late Thrombolysis thrombolysis;
  Examination({
    required this.nTreatment,
    required this.thrombolysis,
  });

  Examination.initialize() {
    this.nTreatment = NTreatment.initialize();
    this.thrombolysis = Thrombolysis.initialize();
    //print('-----------------------------');
    //print(this.nTreatment.toString());
    //print(this.thrombolysis.toString());
  }

  Examination copyWith({
    required NTreatment nTreatment,
    required Thrombolysis thrombolysis,
  }) {
    return Examination(
      nTreatment: nTreatment,
      thrombolysis: thrombolysis,
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
  late YN aspirin_loading;
  late YN c_p_t_loading;
  late YN lmwh;
  late YN ivbolus;
  late YN inj_eno;
  late Statins statins;
  late String statins_dose;
  late YN beta_blockers;
  late YN nitrates;
  late YN diuretics;
  late YN acei_arb;
  NTreatment({
    required this.aspirin_loading,
    required this.c_p_t_loading,
    required this.lmwh,
    required this.ivbolus,
    required this.inj_eno,
    required this.statins,
    required this.statins_dose,
    required this.beta_blockers,
    required this.nitrates,
    required this.diuretics,
    required this.acei_arb,
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
    required YN aspirin_loading,
    required YN c_p_t_loading,
    required YN lmwh,
    required YN ivbolus,
    required YN inj_eno,
    required Statins statins,
    required String statins_dose,
    required YN beta_blockers,
    required YN nitrates,
    required YN diuretics,
    required YN acei_arb,
  }) {
    return NTreatment(
      aspirin_loading: aspirin_loading,
      c_p_t_loading: c_p_t_loading,
      lmwh: lmwh,
      ivbolus: ivbolus,
      inj_eno: inj_eno,
      statins: statins,
      statins_dose: statins_dose,
      beta_blockers: beta_blockers,
      nitrates: nitrates,
      diuretics: diuretics,
      acei_arb: acei_arb,
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
  late YN thrombolysis;
  late YN tnk_stk_ret;
  late YN discharged;
  late YN death;
  late YN referral;
  late String reason_for_referral;
  Thrombolysis({
    required this.thrombolysis,
    required this.tnk_stk_ret,
    required this.discharged,
    required this.death,
    required this.referral,
    required this.reason_for_referral,
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
    required YN thrombolysis,
    required YN tnk_stk_ret,
    required YN discharged,
    required YN death,
    required YN referral,
    required String reason_for_referral,
  }) {
    return Thrombolysis(
      thrombolysis: thrombolysis,
      tnk_stk_ret: tnk_stk_ret,
      discharged: discharged,
      death: death,
      referral: referral,
      reason_for_referral: reason_for_referral,
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
