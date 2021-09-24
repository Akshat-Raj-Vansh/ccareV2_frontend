import 'dart:convert';

class Report {
  final String ecgTime;
  final String ecg_stemi;
  final String trop_i;
  final String bp;
  final String cvs_mr;
  final String onset;
  final Severity severity;
  final PainLocation pain_location;
  final String duration;
  final String radiation;
  final YN smoker;
  final YN diabetic;
  final YN hypertensive;
  final YN dyslipidaemia;
  final YN old_mi;
  final YN chest_pain;
  final YN sweating;
  final YN nausea;
  final YN shortness_of_breath;
  final YN loss_of_conciousness;
  final YN palpitations;
  final YN concious;
  final YN chest_crepts;
  final int pulse_rate;
  Report({
    required this.ecgTime,
    required this.ecg_stemi,
    required this.trop_i,
    required this.bp,
    required this.cvs_mr,
    required this.onset,
    required this.severity,
    required this.pain_location,
    required this.duration,
    required this.radiation,
    required this.smoker,
    required this.diabetic,
    required this.hypertensive,
    required this.dyslipidaemia,
    required this.old_mi,
    required this.chest_pain,
    required this.sweating,
    required this.nausea,
    required this.shortness_of_breath,
    required this.loss_of_conciousness,
    required this.palpitations,
    required this.concious,
    required this.chest_crepts,
    required this.pulse_rate,
  });

  Report copyWith({
    String? ecgTime,
    String? ecg_stemi,
    String? trop_i,
    String? bp,
    String? cvs_mr,
    String? onset,
    Severity? severity,
    PainLocation? pain_location,
    String? duration,
    String? radiation,
    YN? smoker,
    YN? diabetic,
    YN? hypertensive,
    YN? dyslipidaemia,
    YN? old_mi,
    YN? chest_pain,
    YN? sweating,
    YN? nausea,
    YN? shortness_of_breath,
    YN? loss_of_conciousness,
    YN? palpitations,
    YN? concious,
    YN? chest_crepts,
    int? pulse_rate,
  }) {
    return Report(
      ecgTime: ecgTime ?? this.ecgTime,
      ecg_stemi: ecg_stemi ?? this.ecg_stemi,
      trop_i: trop_i ?? this.trop_i,
      bp: bp ?? this.bp,
      cvs_mr: cvs_mr ?? this.cvs_mr,
      onset: onset ?? this.onset,
      severity: severity ?? this.severity,
      pain_location: pain_location ?? this.pain_location,
      duration: duration ?? this.duration,
      radiation: radiation ?? this.radiation,
      smoker: smoker ?? this.smoker,
      diabetic: diabetic ?? this.diabetic,
      hypertensive: hypertensive ?? this.hypertensive,
      dyslipidaemia: dyslipidaemia ?? this.dyslipidaemia,
      old_mi: old_mi ?? this.old_mi,
      chest_pain: chest_pain ?? this.chest_pain,
      sweating: sweating ?? this.sweating,
      nausea: nausea ?? this.nausea,
      shortness_of_breath: shortness_of_breath ?? this.shortness_of_breath,
      loss_of_conciousness: loss_of_conciousness ?? this.loss_of_conciousness,
      palpitations: palpitations ?? this.palpitations,
      concious: concious ?? this.concious,
      chest_crepts: chest_crepts ?? this.chest_crepts,
      pulse_rate: pulse_rate ?? this.pulse_rate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ecgTime': ecgTime,
      'ecg_stemi': ecg_stemi,
      'trop_i': trop_i,
      'bp': bp,
      'cvs_mr': cvs_mr,
      'onset': onset,
      'severity': severity.toString(),
      'pain_location': pain_location.toString(),
      'duration': duration,
      'radiation': radiation,
      'smoker': smoker.toString(),
      'diabetic': diabetic.toString(),
      'hypertensive': hypertensive.toString(),
      'dyslipidaemia': dyslipidaemia.toString(),
      'old_mi': old_mi.toString(),
      'chest_pain': chest_pain.toString(),
      'sweating': sweating.toString(),
      'nausea': nausea.toString(),
      'shortness_of_breath': shortness_of_breath.toString(),
      'loss_of_conciousness': loss_of_conciousness.toString(),
      'palpitations': palpitations.toString(),
      'concious': concious.toString(),
      'chest_crepts': chest_crepts.toString(),
      'pulse_rate': pulse_rate,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      ecgTime: map['ecgTime'],
      ecg_stemi: map['ecg_stemi'],
      trop_i: map['trop_i'],
      bp: map['bp'],
      cvs_mr: map['cvs_mr'],
      onset: map['onset'],
      severity: Severity.values.firstWhere(
          (element) => element.toString() == "Severity." + map["severity"]),
      pain_location: PainLocation.values.firstWhere((element) =>
          element.toString() == "PainLocation." + map["pain_location"]),
      duration: map['duration'],
      radiation: map['radiation'],
      smoker: YN.values
          .firstWhere((element) => element.toString() == "YN." + map['smoker']),
      diabetic: YN.values.firstWhere(
          (element) => element.toString() == "YN." + map['diabetic']),
      hypertensive: YN.values.firstWhere(
          (element) => element.toString() == "YN." + map['hypertensive']),
      dyslipidaemia: YN.values.firstWhere(
          (element) => element.toString() == "YN." + map['dyslipidaemia']),
      old_mi: YN.values
          .firstWhere((element) => element.toString() == "YN." + map['old_mi']),
      chest_pain: YN.values.firstWhere(
          (element) => element.toString() == "YN." + map['chest_pain']),
      sweating: YN.values.firstWhere(
          (element) => element.toString() == "YN." + map['sweating']),
      nausea: YN.values
          .firstWhere((element) => element.toString() == "YN." + map['nausea']),
      shortness_of_breath: YN.values.firstWhere((element) =>
          element.toString() == "YN." + map['shortness_of_breath']),
      loss_of_conciousness: YN.values.firstWhere((element) =>
          element.toString() == "YN." + map['loss_of_conciousness']),
      palpitations: YN.values.firstWhere(
          (element) => element.toString() == "YN." + map['palpitations']),
      concious: YN.values.firstWhere(
          (element) => element.toString() == "YN." + map['concious']),
      chest_crepts: YN.values.firstWhere(
          (element) => element.toString() == "YN." + map['chest_crepts']),
      pulse_rate: map['pulse_rate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) => Report.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Report(ecgTime: $ecgTime, ecg_stemi: $ecg_stemi, trop_i: $trop_i, bp: $bp, cvs_mr: $cvs_mr, onset: $onset, severity: $severity, pain_location: $pain_location, duration: $duration, radiation: $radiation, smoker: $smoker, diabetic:$diabetic, hypertensive: $hypertensive, dyslipidaemia: $dyslipidaemia, old_mi: $old_mi, chest_pain: $chest_pain, sweating: $sweating, nausea: $nausea, shortness_of_breath: $shortness_of_breath, loss_of_conciousness: $loss_of_conciousness, palpitations: $palpitations, concious: $concious, chest_crepts: $chest_crepts, pulse_rate: $pulse_rate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Report &&
        other.ecgTime == ecgTime &&
        other.ecg_stemi == ecg_stemi &&
        other.trop_i == trop_i &&
        other.bp == bp &&
        other.cvs_mr == cvs_mr &&
        other.onset == onset &&
        other.severity == severity &&
        other.pain_location == pain_location &&
        other.duration == duration &&
        other.radiation == radiation &&
        other.smoker == smoker &&
        other.diabetic == diabetic &&
        other.hypertensive == hypertensive &&
        other.dyslipidaemia == dyslipidaemia &&
        other.old_mi == old_mi &&
        other.chest_pain == chest_pain &&
        other.sweating == sweating &&
        other.nausea == nausea &&
        other.shortness_of_breath == shortness_of_breath &&
        other.loss_of_conciousness == loss_of_conciousness &&
        other.palpitations == palpitations &&
        other.concious == concious &&
        other.chest_crepts == chest_crepts &&
        other.pulse_rate == pulse_rate;
  }

  @override
  int get hashCode {
    return ecgTime.hashCode ^
        ecg_stemi.hashCode ^
        trop_i.hashCode ^
        bp.hashCode ^
        cvs_mr.hashCode ^
        onset.hashCode ^
        severity.hashCode ^
        pain_location.hashCode ^
        duration.hashCode ^
        radiation.hashCode ^
        smoker.hashCode ^
        diabetic.hashCode ^
        hypertensive.hashCode ^
        dyslipidaemia.hashCode ^
        old_mi.hashCode ^
        chest_pain.hashCode ^
        sweating.hashCode ^
        nausea.hashCode ^
        shortness_of_breath.hashCode ^
        loss_of_conciousness.hashCode ^
        palpitations.hashCode ^
        concious.hashCode ^
        chest_crepts.hashCode ^
        pulse_rate.hashCode;
  }
}

enum Severity { nill, normal, medium, severe }
enum PainLocation { nill, chest, shoulders, right_arm, left_arm }
enum YN { nill, yes, no }
