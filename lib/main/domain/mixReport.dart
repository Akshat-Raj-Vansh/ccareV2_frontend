import 'package:ccarev2_frontend/main/domain/treatment.dart';

class MixReport{
  final TreatmentReport currentTreatment;
  final TreatmentReport previousTreatment;

  MixReport(this.currentTreatment, this.previousTreatment);
}