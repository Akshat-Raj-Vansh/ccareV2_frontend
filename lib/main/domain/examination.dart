//@dart=2.9
import 'dart:convert';

import 'package:ccarev2_frontend/main/domain/report.dart';

class Examination {
  YN aspirin_loading;
  YN c_p_t_loading;
  String lmwh;
  String statins;
  String beta_blockers;
  String nitrates;
  String diuretics;
  String acei_arb;
  YN tnk_alu_stk_successfull;
  YN death;
  YN referral;
  String reason_for_referral;
  Examination({
    this.aspirin_loading,
    this.c_p_t_loading,
    this.lmwh,
    this.statins,
    this.beta_blockers,
    this.nitrates,
    this.diuretics,
    this.acei_arb,
    this.tnk_alu_stk_successfull,
    this.death,
    this.referral,
    this.reason_for_referral,
  });

  Examination copyWith({
    YN aspirin_loading,
    YN c_p_t_loading,
    String lmwh,
    String statins,
    String beta_blockers,
    String nitrates,
    String diuretics,
    String acei_arb,
    YN tnk_alu_stk_successfull,
    YN death,
    YN referral,
    String reason_for_referral,
  }) {
    return Examination(
      aspirin_loading: aspirin_loading ?? this.aspirin_loading,
      c_p_t_loading: c_p_t_loading ?? this.c_p_t_loading,
      lmwh: lmwh ?? this.lmwh,
      statins: statins ?? this.statins,
      beta_blockers: beta_blockers ?? this.beta_blockers,
      nitrates: nitrates ?? this.nitrates,
      diuretics: diuretics ?? this.diuretics,
      acei_arb: acei_arb ?? this.acei_arb,
      tnk_alu_stk_successfull:
          tnk_alu_stk_successfull ?? this.tnk_alu_stk_successfull,
      death: death ?? this.death,
      referral: referral ?? this.referral,
      reason_for_referral: reason_for_referral ?? this.reason_for_referral,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'aspirin_loading': aspirin_loading.toString() == "YN.nill" ||
              aspirin_loading.toString() == null
          ? null
          : aspirin_loading.toString().split('.')[1] == "yes"
              ? true
              : false,
      'c_p_t_loading': c_p_t_loading.toString() == "YN.nill" ||
              c_p_t_loading.toString() == null
          ? null
          : c_p_t_loading.toString().split('.')[1] == "yes"
              ? true
              : false,
      'lmwh': lmwh,
      'statins': statins,
      'beta_blockers': beta_blockers,
      'nitrates': nitrates,
      'diuretics': diuretics,
      'acei_arb': acei_arb,
      'tnk_alu_stk_successfull':
          tnk_alu_stk_successfull.toString() == "YN.nill" ||
                  tnk_alu_stk_successfull.toString() == null
              ? null
              : tnk_alu_stk_successfull.toString().split('.')[1] == "yes"
                  ? true
                  : false,
      'death': death.toString() == "YN.nill" || death.toString() == null
          ? null
          : death.toString().split('.')[1] == "yes"
              ? true
              : false,
      'referral':
          referral.toString() == "YN.nill" || referral.toString() == null
              ? null
              : referral.toString().split('.')[1] == "yes"
                  ? true
                  : false,
      'reason_for_referral': reason_for_referral,
    };
  }

  factory Examination.fromMap(Map<String, dynamic> map) {
    return Examination(
      aspirin_loading: map["aspirin_loading"] != null
          ? YN.values.firstWhere((element) =>
              element.toString() ==
              "YN." + (map['aspirin_loading'] == true ? "yes" : "no"))
          : YN.nill,
      c_p_t_loading: map["c_p_t_loading"] != null
          ? YN.values.firstWhere((element) =>
              element.toString() ==
              "YN." + (map['c_p_t_loading'] == true ? "yes" : "no"))
          : YN.nill,
      lmwh: map['lmwh'] == "" ? "nill" : map['lmwh'],
      statins: map['statins'] == "" ? "nill" : map['statins'],
      beta_blockers: map['beta_blockers'] == "" ? "nill" : map['beta_blockers'],
      nitrates: map['nitrates'] == "" ? "nill" : map['nitrates'],
      diuretics: map['diuretics'] == "" ? "nill" : map['diuretics'],
      acei_arb: map['acei_arb'] == "" ? "nill" : map['acei_arb'],
      tnk_alu_stk_successfull: map["tnk_alu_stk_successfull"] != null
          ? YN.values.firstWhere((element) =>
              element.toString() ==
              "YN." + (map['tnk_alu_stk_successfull'] == true ? "yes" : "no"))
          : YN.nill,
      death: map["death"] != null
          ? YN.values.firstWhere((element) =>
              element.toString() ==
              "YN." + (map['death'] == true ? "yes" : "no"))
          : YN.nill,
      referral: map["referral"] != null
          ? YN.values.firstWhere((element) =>
              element.toString() ==
              "YN." + (map['referral'] == true ? "yes" : "no"))
          : YN.nill,
      reason_for_referral: map['reason_for_referral'] == ""
          ? "nill"
          : map['reason_for_referral'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Examination.fromJson(String source) =>
      Examination.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Examination(aspirin_loading: $aspirin_loading, c_p_t_loading: $c_p_t_loading, lmwh: $lmwh, statins: $statins, beta_blockers: $beta_blockers, nitrates: $nitrates, diuretics: $diuretics, acei_arb: $acei_arb, tnk_alu_stk_successfull: $tnk_alu_stk_successfull, death: $death, referral: $referral, reason_for_referral: $reason_for_referral)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Examination &&
        other.aspirin_loading == aspirin_loading &&
        other.c_p_t_loading == c_p_t_loading &&
        other.lmwh == lmwh &&
        other.statins == statins &&
        other.beta_blockers == beta_blockers &&
        other.nitrates == nitrates &&
        other.diuretics == diuretics &&
        other.acei_arb == acei_arb &&
        other.tnk_alu_stk_successfull == tnk_alu_stk_successfull &&
        other.death == death &&
        other.referral == referral &&
        other.reason_for_referral == reason_for_referral;
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
        acei_arb.hashCode ^
        tnk_alu_stk_successfull.hashCode ^
        death.hashCode ^
        referral.hashCode ^
        reason_for_referral.hashCode;
  }
}
