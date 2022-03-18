//@dart=2.9
import 'dart:convert';

class TreatmentReport {
  String report_time;
  District district;
  ECG ecg;
  MedicalHist medicalHist;
  ChestReport chestReport;
  Symptoms symptoms;
  Examination examination;
  TreatmentReport({
    this.report_time,
    this.district,
    this.ecg,
    this.medicalHist,
    this.chestReport,
    this.symptoms,
    this.examination,
  });

  TreatmentReport.initialize() {
    this.district = District.nill;
    this.ecg = ECG.initialize();
    this.medicalHist = MedicalHist.initialize();
    this.chestReport = ChestReport.initialize();
    this.symptoms = Symptoms.initialize();
    this.examination = Examination.initialize();
  }

  set report_time_(String report_time) => this.report_time = report_time;
  set ecg_(ECG value) => this.ecg = value;
  set medicalHist_(MedicalHist value) => this.medicalHist = value;
  set chestReport_(ChestReport value) => this.chestReport = value;
  set symptoms_(Symptoms value) => this.symptoms = value;
  set examination_(Examination value) => this.examination = value;

  TreatmentReport copyWith({
    String report_time,
    District district,
    ECG ecg,
    MedicalHist medicalHist,
    ChestReport chestReport,
    Symptoms symptoms,
    Examination examination,
  }) {
    return TreatmentReport(
      report_time: report_time ?? this.report_time,
      district: district ?? this.district,
      ecg: ecg ?? this.ecg,
      medicalHist: medicalHist ?? this.medicalHist,
      chestReport: chestReport ?? this.chestReport,
      symptoms: symptoms ?? this.symptoms,
      examination: examination ?? this.examination,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'report_time': report_time,
      'district': district.toString().split(".")[1],
      'ecg': ecg.toMap(),
      'medical_hist': medicalHist.toMap(),
      'chest_report': chestReport.toMap(),
      'symptoms': symptoms.toMap(),
      'examination': examination.toMap(),
    };
  }

  factory TreatmentReport.fromMap(Map<String, dynamic> map) {
    return TreatmentReport(
      report_time: map['report_time'].toString(),
      district: District.values.firstWhere((element) =>
          element.toString() == "District." + map['district'].toString()),
      ecg: ECG.fromMap(map['ecg']),
      medicalHist: MedicalHist.fromMap(map['medical_hist']),
      chestReport: ChestReport.fromMap(map['chest_report']),
      symptoms: Symptoms.fromMap(map['symptoms']),
      examination: Examination.fromMap(map['examination']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TreatmentReport.fromJson(String source) =>
      TreatmentReport.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TreatmentReport(report_time: $report_time ecg: $ecg, medicalHist: $medicalHist, chestReport: $chestReport, symptoms: $symptoms, examination: $examination)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TreatmentReport &&
        other.report_time == report_time &&
        other.district == district &&
        other.ecg == ecg &&
        other.medicalHist == medicalHist &&
        other.chestReport == chestReport &&
        other.symptoms == symptoms &&
        other.examination == examination;
  }

  @override
  int get hashCode {
    return report_time.hashCode ^
        ecg.hashCode ^
        medicalHist.hashCode ^
        chestReport.hashCode ^
        symptoms.hashCode ^
        examination.hashCode;
  }
}

class ECGFile {
  String file_id;
  String seq_no;
  ECGFile({
    this.file_id,
    this.seq_no,
  });

  ECGFile copyWith({
    String file_id,
    String seq_no,
  }) {
    return ECGFile(
      file_id: file_id ?? this.file_id,
      seq_no: seq_no ?? this.seq_no,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'file_id': file_id,
      'seq_no': seq_no,
    };
  }

  factory ECGFile.fromMap(Map<String, dynamic> map) {
    return ECGFile(
      file_id: map['file_id'] ?? '',
      seq_no: map['seq_no'].toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ECGFile.fromJson(String source) =>
      ECGFile.fromMap(json.decode(source));

  @override
  String toString() => 'ECGFile(file_id: $file_id, seq_no: $seq_no)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ECGFile &&
        other.file_id == file_id &&
        other.seq_no == seq_no;
  }

  @override
  int get hashCode => file_id.hashCode ^ seq_no.hashCode;
}

class ECG {
  String ecg_time;
  ECGType ecg_type;
  List<ECGFile> ecg_file_id;
  ECG({
    this.ecg_time,
    this.ecg_type,
    this.ecg_file_id,
  });
  ECG.initialize() {
    this.ecg_time = "nill";
    this.ecg_type = ECGType.nill;
    this.ecg_file_id = [];
  }
  set ecg_time_(String value) => this.ecg_time = value;
  set ecg_type_(ECGType value) => this.ecg_type = value;
  set ecg_file_ids_(List<ECGFile> value) => this.ecg_file_id = value;

  ECG copyWith({
    String ecg_time,
    ECGType ecg_type,
    List<ECGFile> ecg_file_id,
  }) {
    return ECG(
      ecg_time: ecg_time ?? this.ecg_time,
      ecg_type: ecg_type ?? this.ecg_type,
      ecg_file_id: ecg_file_id ?? this.ecg_file_id,
    );
  }

  Map<String, dynamic> toMap() {
    //print(ecg_type.toString().split('.')[1]);
    return {
      'ecg_time': ecg_time == "" ? "nill" : ecg_time,
      'ecg_type': ecg_type.toString().split('.')[1],
      'ecg_file_id': ecg_file_id.map((x) => x.toMap()).toList(),
    };
  }

  factory ECG.fromMap(Map<String, dynamic> map) {
    return ECG(
      ecg_time: map['ecg_time'],
      ecg_type: ECGType.values.firstWhere(
          (element) => element.toString() == "ECGType." + map['ecg_type']),
      ecg_file_id:
          List<ECGFile>.from(map['ecg_file_id'].map((x) => ECGFile.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ECG.fromJson(String source) => ECG.fromMap(json.decode(source));

  @override
  String toString() =>
      'ECG(ecg_time: $ecg_time, ecg_type: $ecg_type, ecg_file_id: ${ecg_file_id.toString()})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ECG &&
        other.ecg_time == ecg_time &&
        other.ecg_type == ecg_type &&
        other.ecg_file_id == ecg_file_id;
  }
}

class MedicalHist {
  YN smoker;
  YN diabetic;
  YN hypertensive;
  YN dyslipidaemia;
  YN old_mi;
  PN trop_i;
  MedicalHist({
    this.smoker,
    this.diabetic,
    this.hypertensive,
    this.dyslipidaemia,
    this.old_mi,
    this.trop_i,
  });
  MedicalHist.initialize() {
    this.smoker = YN.nill;
    this.diabetic = YN.nill;
    this.hypertensive = YN.nill;
    this.dyslipidaemia = YN.nill;
    this.old_mi = YN.nill;
    this.trop_i = PN.nill;
  }

  set trop_i_(PN value) => this.trop_i = value;
  set smoker_(YN value) => this.smoker = value;
  set diabetic_(YN value) => this.diabetic = value;
  set hypertensive_(YN value) => this.hypertensive = value;
  set old_mi_(YN value) => this.old_mi = value;

  MedicalHist copyWith({
    YN smoker,
    YN diabetic,
    YN hypertensive,
    YN dyslipidaemia,
    YN old_mi,
    PN trop_i,
  }) {
    return MedicalHist(
      smoker: smoker ?? this.smoker,
      diabetic: diabetic ?? this.diabetic,
      hypertensive: hypertensive ?? this.hypertensive,
      dyslipidaemia: dyslipidaemia ?? this.dyslipidaemia,
      old_mi: old_mi ?? this.old_mi,
      trop_i: trop_i ?? this.trop_i,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'smoker': smoker.toString().split('.')[1],
      'diabetic': diabetic.toString().split('.')[1],
      'hypertensive': hypertensive.toString().split('.')[1],
      'dyslipidaemia': dyslipidaemia.toString().split('.')[1],
      'old_mi': old_mi.toString().split('.')[1],
      'trop_i': trop_i.toString().split(".")[1]
    };
  }

  factory MedicalHist.fromMap(Map<String, dynamic> map) {
    YN ynCheck(String value) {
      if (value == "no")
        return YN.no;
      else if (value == "yes") return YN.yes;
      return YN.nill;
    }

    PN pnCheck(String value) {
      if (value == "negative")
        return PN.negative;
      else if (value == "positive") return PN.positive;
      return PN.nill;
    }

    return MedicalHist(
      smoker: ynCheck(map['smoker']),
      diabetic: ynCheck(map['diabetic']),
      hypertensive: ynCheck(map['hypertensive']),
      dyslipidaemia: ynCheck(map['dyslipidaemia']),
      old_mi: ynCheck(map['old_mi']),
      trop_i: pnCheck(map['trop_i']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicalHist.fromJson(String source) =>
      MedicalHist.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MedicalHist(smoker: $smoker, diabetic: $diabetic, hypertensive: $hypertensive, dyslipidaemia: $dyslipidaemia, old_mi: $old_mi, trop_i:$trop_i)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicalHist &&
        other.smoker == smoker &&
        other.diabetic == diabetic &&
        other.hypertensive == hypertensive &&
        other.dyslipidaemia == dyslipidaemia &&
        other.old_mi == old_mi &&
        other.trop_i == trop_i;
  }

  @override
  int get hashCode {
    return smoker.hashCode ^
        diabetic.hashCode ^
        hypertensive.hashCode ^
        dyslipidaemia.hashCode ^
        old_mi.hashCode ^
        trop_i.hashCode;
  }
}

class ChestReport {
  YN chest_pain;
  Site site;
  Location location;
  // Intensity intensity;
  Severity severity;
  Radiation radiation;
  String duration;
  ChestReport({
    this.chest_pain,
    this.site,
    this.location,
    // this.intensity,
    this.severity,
    this.radiation,
    this.duration,
  });

  ChestReport.initialize() {
    this.chest_pain = YN.nill;
    this.site = Site.nill;
    this.location = Location.nill;
    // this.intensity = Intensity.nill;
    this.severity = Severity.nill;
    this.radiation = Radiation.nill;
    this.duration = "nill";
  }

  set chest_pain_(YN value) => this.chest_pain = value;
  set site_(Site value) => this.site = value;
  set location_(Location value) => this.location = value;
  // set intensity_(Intensity value) => this.intensity = value;
  set severity_(Severity value) => this.severity = value;
  set radiation_(Radiation value) => this.radiation = value;
  set duration_(String value) => this.duration = value;

  ChestReport copyWith({
    YN chest_pain,
    Site site,
    Location location,
    // Intensity intensity,
    Severity severity,
    Radiation radiation,
    String duration,
  }) {
    return ChestReport(
      chest_pain: chest_pain ?? this.chest_pain,
      site: site ?? this.site,
      location: location ?? this.location,
      // intensity: intensity ?? this.intensity,
      severity: severity ?? this.severity,
      radiation: radiation ?? this.radiation,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chest_pain': chest_pain.toString().split('.')[1],
      'site': site.toString().split('.')[1],
      'location': location.toString().split('.')[1],
      // 'intensity': intensity.toString().split('.')[1],
      'severity': severity.toString().split('.')[1],
      'radiation': radiation.toString().split('.')[1],
      'duration': duration == "" ? "nill" : duration,
    };
  }

  factory ChestReport.fromMap(Map<String, dynamic> map) {
    return ChestReport(
      chest_pain: YN.values.firstWhere(
          (element) => element.toString() == "YN." + map['chest_pain']),
      site: Site.values
          .firstWhere((element) => element.toString() == "Site." + map['site']),
      location: Location.values.firstWhere(
          (element) => element.toString() == "Location." + map['location']),
      // intensity: Intensity.values.firstWhere(
      // (element) => element.toString() == "Intensity." + map['intensity']),
      severity: Severity.values.firstWhere(
          (element) => element.toString() == "Severity." + map['severity']),
      radiation: Radiation.values.firstWhere(
          (element) => element.toString() == "Radiation." + map['radiation']),
      duration: map['duration'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChestReport.fromJson(String source) =>
      ChestReport.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChestReport(chest_pain: $chest_pain, site: $site, location: $location, severity: $severity, radiation: $radiation, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChestReport &&
        other.chest_pain == chest_pain &&
        other.site == site &&
        other.location == location &&
        // other.intensity == intensity &&
        other.severity == severity &&
        other.radiation == radiation &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return chest_pain.hashCode ^
        site.hashCode ^
        location.hashCode ^
        // intensity.hashCode ^
        severity.hashCode ^
        radiation.hashCode ^
        duration.hashCode;
  }
}

class Symptoms {
  YN postural_black_out;
  // YN light_headedness;
  YN sweating;
  YN nausea;
  YN shortness_of_breath;
  // YN loss_of_consciousness;
  Symptoms({
    this.postural_black_out,
    // this.light_headedness,
    this.sweating,
    this.nausea,
    this.shortness_of_breath,
    // this.loss_of_consciousness,
  });
  Symptoms.initialize() {
    this.postural_black_out = YN.nill;
    // this.light_headedness = YN.nill;
    this.sweating = YN.nill;
    this.nausea = YN.nill;
    this.shortness_of_breath = YN.nill;
    // this.loss_of_consciousness = YN.nill;
  }

  set postural_black_out_(YN value) => this.postural_black_out = value;
  // set light_headedness_(YN value) => this.light_headedness = value;
  set sweating_(YN value) => this.sweating = value;
  set nausea_(YN value) => this.nausea = value;
  set shortness_of_breath_(YN value) => this.shortness_of_breath = value;
  // set loss_of_consciousness_(YN value) => this.loss_of_consciousness = value;

  Symptoms copyWith({
    YN postural_black_out,
    // YN light_headedness,
    YN sweating,
    YN nausea,
    YN shortness_of_breath,
    // YN loss_of_consciousness,
  }) {
    return Symptoms(
      postural_black_out: postural_black_out ?? this.postural_black_out,
      // light_headedness: light_headedness ?? this.light_headedness,
      sweating: sweating ?? this.sweating,
      nausea: nausea ?? this.nausea,
      shortness_of_breath: shortness_of_breath ?? this.shortness_of_breath,
      // loss_of_consciousness:
      // loss_of_consciousness ?? this.loss_of_consciousness,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postural_black_out': postural_black_out.toString().split('.')[1],
      // 'light_headedness': light_headedness.toString().split('.')[1],
      'sweating': sweating.toString().split('.')[1],
      'nausea': nausea.toString().split('.')[1],
      'shortness_of_breath': shortness_of_breath.toString().split('.')[1],
      // 'loss_of_consciousness': loss_of_consciousness.toString().split('.')[1],
    };
  }

  factory Symptoms.fromMap(Map<String, dynamic> map) {
    YN ynCheck(String value) {
      if (value == "no")
        return YN.no;
      else if (value == "yes") return YN.yes;
      return YN.nill;
    }

    return Symptoms(
      postural_black_out: ynCheck(map['postural_black_out']),
      // light_headedness: ynCheck(map['light_headedness']),
      sweating: ynCheck(map['sweating']),
      nausea: ynCheck(map['nausea']),
      shortness_of_breath: ynCheck(map['shortness_of_breath']),
      // loss_of_consciousness: ynCheck(map['loss_of_consciousness']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Symptoms.fromJson(String source) =>
      Symptoms.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Symptoms(postural_black_out: $postural_black_out,  sweating: $sweating, nausea: $nausea, shortness_of_breath: $shortness_of_breath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Symptoms &&
        other.postural_black_out == postural_black_out &&
        // other.light_headedness == light_headedness &&
        other.sweating == sweating &&
        other.nausea == nausea &&
        other.shortness_of_breath == shortness_of_breath;
    // other.loss_of_consciousness == loss_of_consciousness;
  }

  @override
  int get hashCode {
    return postural_black_out.hashCode ^
        // light_headedness.hashCode ^
        sweating.hashCode ^
        nausea.hashCode ^
        shortness_of_breath.hashCode;
    // loss_of_consciousness.hashCode;
  }
}

class Examination {
  String pulse_rate;
  String dbp;
  String sbp;
  String spo2;
  YN local_tenderness;
  Examination({
    this.pulse_rate,
    this.dbp,
    this.sbp,
    this.spo2,
    this.local_tenderness,
  });
  Examination.initialize() {
    this.pulse_rate = "nill";
    this.dbp = "nill";
    this.sbp = "nill";
    this.spo2 = "nill";
    this.local_tenderness = YN.nill;
  }
  set pulse_rate_(String value) => this.pulse_rate = value;
  set dbp_(String value) => this.dbp = value;
  set sbp_(String value) => this.sbp = value;
  // set local_tenderness_(String value) => this.local_tenderness = value;

  Examination copyWith({
    String pulse_rate,
    String dbp,
    String sbp,
    String spo2,
    YN local_tenderness,
  }) {
    return Examination(
      pulse_rate: pulse_rate ?? this.pulse_rate,
      dbp: dbp ?? this.dbp,
      sbp: sbp ?? this.sbp,
      spo2: spo2 ?? this.spo2,
      local_tenderness: local_tenderness ?? this.local_tenderness,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pulse_rate': pulse_rate == "" ? "nill" : pulse_rate,
      'dbp': dbp == "" ? "nill" : dbp,
      'sbp': sbp == "" ? "nill" : sbp,
      'spo2': spo2 == "" ? "nill" : spo2,
      'local_tenderness': local_tenderness.toString().split(".")[1],
    };
  }

  factory Examination.fromMap(Map<String, dynamic> map) {
    YN ynCheck(String value) {
      if (value == "no")
        return YN.no;
      else if (value == "yes") return YN.yes;
      return YN.nill;
    }

    return Examination(
      pulse_rate: map['pulse_rate'],
      dbp: map['dbp'],
      sbp: map['sbp'],
      spo2: map['spo2'],
      local_tenderness: ynCheck(map['local_tenderness']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Examination.fromJson(String source) =>
      Examination.fromMap(json.decode(source));

  @override
  String toString() =>
      'Examination(pulse_rate: $pulse_rate, dbp: $dbp, sbp: $sbp local_tenderness: $local_tenderness)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Examination &&
        other.pulse_rate == pulse_rate &&
        other.dbp == dbp &&
        other.sbp == sbp &&
        other.local_tenderness == local_tenderness;
  }

  @override
  int get hashCode =>
      pulse_rate.hashCode ^
      dbp.hashCode ^
      sbp.hashCode ^
      local_tenderness.hashCode;
}

enum ECGType { nill, STEMI, NSTEMI }
enum YN { nill, yes, no }
enum Site { nill, Left_Precordium, Right_Precordium, Epigastric_region }
enum Location { nill, Localized, Diffuse }
enum Intensity { nill, Mild, Severe }
enum Severity { nill, Mild, Moderate, Severe }
enum Radiation { nill, Shoulder, back, Arm, Jaw, Neck }
enum PN { nill, positive, negative }
enum Statins { nill, Atorbastatin, Rozuastatin, NotGiven }
enum District {
  nill,
  Chamba,
  Solan,
  Shimla,
  LahulSpiti,
  Hamirpur,
  Kangra,
  Kullu,
  Mandi,
  Kinnaur,
  Sirmaur,
  Bilaspur,
  Una
}
