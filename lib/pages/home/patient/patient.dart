//@dart=2.9
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/question.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/pages/home/components/fullImage.dart';
import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_history_screen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_report_screen.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/pages/questionnare/questionnare_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:location/location.dart' as lloc;
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../home_page_adapter.dart';
import '../../questionnare/questionnare_screen.dart';
import '../../../state_management/main/main_cubit.dart';
import '../../../state_management/main/main_state.dart';
import '../../../state_management/user/user_cubit.dart';
import '../../../utils/size_config.dart';
import '../../../utils/constants.dart';

class PatientHomeUI extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;
  const PatientHomeUI(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  State<PatientHomeUI> createState() => _PatientHomeUIState();
}

class _PatientHomeUIState extends State<PatientHomeUI> {
  bool loader = false;
  EDetails eDetails;
  static bool _emergency = false;
  static bool _doctorAccepted = false;
  static bool _driverAccepted = false;
  static bool _notificationSent = false;
  static bool _assessAgain = false;
  static bool _questionnaire = false;
  static bool _historyFetched = false;
  static TreatmentReport _treatmentReport;
  static List<QuestionTree> _questions;
  static String _currentStatus = "UNKNOWN";
  List<QuestionTree> display = [];
  List<String> answers = [];
  int length = 1;
  TextStyle styles = const TextStyle(color: Colors.white, fontSize: 18);
  EdgeInsets pad = const EdgeInsets.symmetric(vertical: 5, horizontal: 15);
  BoxDecoration decA = const BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)));
  BoxDecoration decC = const BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)));
  BoxDecoration decB = const BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30)));
  dynamic currentState = null;
  @override
  void initState() {
    super.initState();
    CubitProvider.of<MainCubit>(context).fetchEmergencyDetails();
    CubitProvider.of<MainCubit>(context).getQuestions();
    CubitProvider.of<MainCubit>(context).recentHistory();
    NotificationController.configure(
        widget.mainCubit, UserType.PATIENT, context);
    NotificationController.fcmHandler();
  }

  Future<loc.Location> _getLocation() async {
    lloc.LocationData _locationData = await lloc.Location().getLocation();
    print(_locationData.latitude.toString() +
        "," +
        _locationData.longitude.toString());
    loc.Location _location = loc.Location(
        latitude: _locationData.latitude, longitude: _locationData.longitude);
    return _location;
  }

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        msg,
        style: Theme.of(context)
            .textTheme
            .caption
            .copyWith(color: Colors.white, fontSize: 16),
      ),
    ));
  }

  _showLoader() {
    loader = true;
    var alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.green,
      )),
    );
    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader() {
    if (loader) {
      loader = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('CardioCare - Patient'),
        backgroundColor: kPrimaryColor,
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     _showLoader();
          //     loc.Location location = await _getLocation();
          //     _hideLoader();
          //     return widget.homePageAdapter
          //         .loadEmergencyScreen(context, UserType.PATIENT, location);
          //   },
          //   icon: Icon(FontAwesomeIcons.mapMarkedAlt),
          // ),
          IconButton(
            onPressed: () async {
              await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Are you sure?',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      content: const Text(
                        'Do you want to logout?',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(
                            'Cancel',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            widget.homePageAdapter
                                .onLogout(context, widget.userCubit);
                          },
                          child: const Text(
                            'Yes',
                          ),
                        ),
                      ],
                    ),
                  ) ??
                  false;
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: CubitConsumer<MainCubit, MainState>(
        builder: (_, state) {
          if (state is DetailsLoaded) {
            currentState = DetailsLoaded;
            // _hideLoader();
            _notificationSent = true;
            eDetails = state.eDetails;
            _currentStatus = "EMERGENCY";
            _emergency = true;
            if (eDetails.doctorDetails != null) {
              _doctorAccepted = true;
              //    _emergency = true;
            }
            if (eDetails.driverDetails != null) {
              _driverAccepted = true;
              //   _emergency = true;
            }
          }
          if (state is QuestionnaireState) {
            print("Questionnaire State Called");
            _questions = state.questions;

            display.add(
                _questions.firstWhere((element) => element.parent == "root"));
            _questionnaire = true;
          }
          if (state is PreviousHistory) {
            _treatmentReport = state.treatmentReport;
            if (_treatmentReport != null) _historyFetched = true;
          }
          if (state is NormalState) {
            currentState = NormalState;
            if (state.msg == "NOT ASSIGNED") _notificationSent = true;
          }
          if (state is StatusFetched) {
            _hideLoader();
            _currentStatus = state.msg;
          }
          if (currentState == null)
            return Center(child: CircularProgressIndicator());

          return _buildUI(context);
        },
        listener: (context, state) async {
          if (state is LoadingState) {
            print("Loading State Called Patient");
            _showLoader();
          } else if (state is EmergencyState) {
            _hideLoader();
            _notificationSent = true;
            _emergency = true;
            _currentStatus = "EMERGENCY";
            print("Emergency State Called");
            _showMessage("Notifications sent to the Doctor and the Ambulance.");
          } else if (state is DetailsLoaded) {
            _hideLoader();
            //  _currentStatus = EDetails.patientDetails.status;
          } else if (state is NormalState) {
            _hideLoader();
            // _showMessage(state.msg);
          } else if (state is ErrorState) {
            _hideLoader();
          } else if (state is QuestionnaireState) {
            print("Questionnaire State Called");
            _hideLoader();
            _questions = state.questions;

            // display.add(
            //     _questions.firstWhere((element) => element.parent == "root"));
            if (_assessAgain) {
              var cubit = CubitProvider.of<MainCubit>(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SelfAssessment(_questions, cubit, "homescreen"),
                ),
              );
            }
          }
        },
      ),
    );
  }

  _buildUI(BuildContext context) => Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if (!_notificationSent) _buildHeader(),
              if (_questionnaire && !_notificationSent) _buildQuestionnaire(),
              if (_historyFetched && !_notificationSent) _buildReportOverview(),
              if (_notificationSent && (!_doctorAccepted && !_driverAccepted))
                _buildNotificationSend(),
              if (_doctorAccepted || _driverAccepted)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Emergency Information",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              if (_doctorAccepted || _driverAccepted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status:",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        _currentStatus,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              if (_doctorAccepted) _buildDoctorDetails(),
              if (_driverAccepted) _buildDriverDetails(),
              if (_emergency) _buildPatientReportButton(),
              if (!_questionnaire && _notificationSent)
                _buildPatientReportHistoryButton(),
            ],
          ),
        ),
        if (_notificationSent && !(_doctorAccepted || _driverAccepted))
          _buildBottomUI(context)
      ]);

  _buildReportOverview() => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),

            // Patient Medical Report
            // ECG Report
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "ECG Report",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            _buildECGDetails(),

            // Medical History
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Medical History",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            _buildMedHistDetails(),

            // Chest Report
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Chest Report",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            _buildChestDetails(),

            // Symptoms Report
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Symptoms",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            _buildSymptomsDetails(),

            // Examination Report
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Examination",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            _buildExaminationDetails(),
          ],
        ),
      );

  _buildECGDetails() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),
            // ECG Time
            Text('Current Report'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Time: '),
                Text(_treatmentReport.ecg.ecg_time == "nill"
                    ? "nill"
                    : DateTime.fromMillisecondsSinceEpoch(
                            int.parse(_treatmentReport.ecg.ecg_time))
                        .toString()),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // ECG Scan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Scan: '),
                _treatmentReport.ecg.ecg_file_id != "nill"
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return FullScreenImage(
                              imageUrl:
                                  "http://192.168.1.145:3000/treatment/fetchECG?fileID=${_treatmentReport.ecg.ecg_file_id}",
                              tag: "generate_a_unique_tag",
                            );
                          }));
                        },
                        child: Hero(
                          child: Image(
                              image: NetworkImage(
                                  "http://192.168.0.139:3000/treatment/fetchECG?fileID=${_treatmentReport.ecg.ecg_file_id}",
                                  headers: {
                                    "Authorization":
                                        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjFhMWU5ZGNiYWI4MjZkZTk4NjBmNzkzIiwiaWF0IjoxNjM4MjY1MzkxLCJleHAiOjE2Mzg4NzAxOTEsImlzcyI6ImNvbS5jY2FyZW5pdGgifQ.K-_DprXx2ipOwWt17DODlMDqQSgtWdv8aARjlPdEuzA"
                                  }),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover),
                          tag: "generate_a_unique_tag",
                        ),
                      )
                    : Text('No ECG Uploaded'),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // ECG Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Type: '),
                Text(_treatmentReport.ecg.ecg_type.toString().split('.')[1]),
              ],
            ),

            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      );

  _buildMedHistDetails() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),
            // Smoker
            Text('Current Report'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Smoker: '),
                Text(_treatmentReport.medicalHist.smoker
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Diabetic
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Diabetic: '),
                Text(_treatmentReport.medicalHist.diabetic
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hypertensive: '),
                Text(_treatmentReport.medicalHist.hypertensive
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Dyslipidaemia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dyslipidaemia: '),
                Text(_treatmentReport.medicalHist.dyslipidaemia
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Old MI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Old MI: '),
                Text(_treatmentReport.medicalHist.old_mi
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Trop I
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trop I: '),
                Text(_treatmentReport.medicalHist.trop_i),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      );

  _buildChestDetails() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chest Pain: '),
                Text(_treatmentReport.chestReport.chest_pain
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Onset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Site: '),
                Text(
                    _treatmentReport.chestReport.site.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Pain Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Location: '),
                Text(_treatmentReport.chestReport.location
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Intensity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Intensity: '),
              Text(_treatmentReport.chestReport.intensity
                  .toString()
                  .split('.')[1]),
            ]),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Severity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Severity: '),
              Text(_treatmentReport.chestReport.severity
                  .toString()
                  .split('.')[1]),
            ]),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Radiation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Radiation: '),
                Text(_treatmentReport.chestReport.radiation
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration: '),
                Text(_treatmentReport.chestReport.duration),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      );

  _buildSymptomsDetails() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),

            // Blackouts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Postural Black Out: '),
                Text(_treatmentReport.symptoms.postural_black_out
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Palpitations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Light Headedness: '),
                Text(_treatmentReport.symptoms.light_headedness
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            //Sweating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sweating: '),
                Text(_treatmentReport.symptoms.sweating
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Nausea
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nausea/Vomiting: '),
                Text(_treatmentReport.symptoms.nausea.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Shortness of breath
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shortness of breath: '),
                Text(_treatmentReport.symptoms.shortness_of_breath
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Loss of conciousness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loss of Consciousness: '),
                Text(_treatmentReport.symptoms.loss_of_consciousness
                    .toString()
                    .split('.')[1]),
              ],
            ),

            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      );

  _buildExaminationDetails() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),
            // Pulse Rate

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pulse Rate: '),
                Text(_treatmentReport.examination.pulse_rate),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // BP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('BP: '),
                Text(_treatmentReport.examination.bp),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Local Tenderness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Local Tederness: '),
                Text(_treatmentReport.examination.local_tenderness),
              ],
            ),

            SizedBox(height: getProportionateScreenHeight(100)),
          ],
        ),
      );

  _buildQuestionnaire() {
    return Container(
        height: SizeConfig.screenHeight,
        color: Colors.white24,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: pad,
              decoration: decA,
              child: Text(
                "Please enter correct inputs to ensure proper results",
                style: styles,
              ),
            ),
            Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    if (display[index].status) {
                      print("cmp");
                      return Column(children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              decoration: decA,
                              padding: pad,
                              child: Text(
                                display[index].question,
                                style: styles,
                              )),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: display[index].answers.length == 1
                                ? Container(
                                    padding: pad,
                                    decoration: decB,
                                    margin: EdgeInsets.only(right: 10, top: 10),
                                    child: Text(display[index].answers[0],
                                        style: styles))
                                : Wrap(
                                    children: List<Widget>.generate(
                                        answers.length,
                                        (i) => Container(
                                            padding: pad,
                                            margin: const EdgeInsets.only(
                                                right: 10, top: 10),
                                            decoration: decB,
                                            child: Text(
                                                display[index].answers[i],
                                                style: styles)))))
                      ]);
                    }
                    print("here");
                    var check = List<bool>.generate(
                        display[index].options.length, (index) => false);
                    var options =
                        List.generate(display[index].options.length * 2, (i) {
                      if (i % 2 == 0) {
                        return GestureDetector(
                          onTap: () {
                            if (display[index].question_type ==
                                QuestionType.SELECTION) {
                              setState(() {
                                if (display[index].options[i ~/ 2] == "next" &&
                                    answers.isNotEmpty) {
                                  display[index].answer(answers);
                                  var indexes = answers
                                      .map((e) =>
                                          display[index].options.indexOf(e))
                                      .toList();
                                  indexes.sort();
                                  answers = indexes
                                      .map((e) => display[index].options[e])
                                      .toList();
                                  print(answers.join(','));
                                  try {
                                    display.add(_questions.firstWhere(
                                        (element) =>
                                            element.parent ==
                                                display[index].question &&
                                            element.when == answers.join(',')));
                                  } catch (e) {
                                    print(e);
                                  } //think about the when logic incase
                                } else if (display[index].options[i ~/ 2] !=
                                    "next") {
                                  if (!answers.contains(
                                      display[index].options[i ~/ 2])) {
                                    answers.add(display[index].options[i ~/ 2]);
                                  } else {
                                    answers.removeWhere((element) =>
                                        element ==
                                        display[index].options[i ~/ 2]);
                                  }
                                }

                                if (display.last.node_type == "RESULT") {
                                  if (display.last.options[0] == "EMERGENCY") {
                                    _showAmbRequired();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                      content: Text(
                                        "Emergency Notifications Sent",
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 16),
                                      ),
                                    ));
                                  }
                                }
                              });
                            } else {
                              setState(() {
                                display[index]
                                    .answer([display[index].options[i ~/ 2]]);
                                try {
                                  display.add(_questions.firstWhere((element) =>
                                      element.parent ==
                                          display[index].question &&
                                      element.when ==
                                          display[index].options[i ~/ 2]));
                                  print(display.last.question);

                                  if (display.last.node_type ==
                                      NodeType.RESULT) {
                                    print("INSIDE");
                                    if (display.last.options[0] ==
                                        "EMERGENCY") {
                                      print("Inside");
                                      _showAmbRequired();
                                    }
                                  }
                                } catch (e) {
                                  print(e);
                                }
                                print(display.length);
                              });
                            }
                          },
                          child: Container(
                              margin: EdgeInsets.only(right: 10, top: 10),
                              padding: pad,
                              decoration: decC,
                              child: display[index].question_type ==
                                      QuestionType.SELECTION
                                  ? Wrap(children: [
                                      Text(display[index].options[(i ~/ 2)],
                                          style: styles),
                                      display[index].options[i ~/ 2] != "next"
                                          ? Icon(Icons.check,
                                              color: answers.contains(
                                                      display[index]
                                                          .options[i ~/ 2])
                                                  ? Colors.white
                                                  : Colors.grey)
                                          : SizedBox(
                                              width: 1,
                                            )
                                    ])
                                  : Text(display[index].options[(i ~/ 2)],
                                      style: styles)),
                        );
                      } else
                        return SizedBox(height: 10);
                    });
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: pad,
                              decoration: decA,
                              child:
                                  Text(display[index].question, style: styles)),
                          SizedBox(height: 10),
                          Wrap(
                              direction: display[index].question_type ==
                                      QuestionType.SELECTION
                                  ? Axis.horizontal
                                  : Axis.vertical,
                              children: [...options])
                        ]);
                  },
                  itemCount: display.length),
            ),
          ],
        ));
  }

  _buildNotificationSend() => Container(
      color: kPrimaryLightColor,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListTile(
        leading: Icon(CupertinoIcons.exclamationmark_shield,
            color: Colors.white, size: 40),
        title: Text(
          "Emergency Notification Sent!!",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        subtitle: Text(
          "Waiting for the confimation from Doctor's and Ambulance's side ->",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ));

  _buildPatientReportButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientReportScreen(
                    mainCubit: widget.mainCubit, user: UserType.PATIENT),
              ));
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            "View your current Medical Report",
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildPatientReportHistoryButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PatientReportHistoryScreen(mainCubit: widget.mainCubit),
              ));
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: kPrimaryColor)),
          child: Text(
            "View your Medical Report History",
            style: TextStyle(color: kPrimaryColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildDoctorDetails() => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "Doctor's Information",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.red[100], borderRadius: BorderRadius.circular(20)),
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Name: "),
                  Text(eDetails.doctorDetails.name),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hospital: "),
                  Text(eDetails.doctorDetails.hospital),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Location: "),
                  Text(eDetails.doctorDetails.address == null ||
                          eDetails.doctorDetails.address == ""
                      ? "India"
                      : eDetails.doctorDetails.address),
                ],
              ),
            ],
          ),
        ),
      ]);

  _buildBottomUI(BuildContext context) => Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.all(5.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          if (_currentStatus != "ATH")
            RaisedButton.icon(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () async {
                  print(_emergency);
                  if (!_emergency) {
                    _showAmbRequired();
                  } else {
                    // _showLoader();
                    // loc.Location location = await _getLocation();
                    // _hideLoader();
                    // return widget.homePageAdapter
                    //     .loadEmergencyScreen(context, UserType.PATIENT, location);
                    _updateStatus();
                  }
                },
                icon: Icon(
                  !_emergency ? Icons.phone : Icons.access_time,
                  color: Colors.white,
                ),
                label: Text(
                  !_emergency ? "Emergency" : "Change Status",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          RaisedButton.icon(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () async {
                _assessAgain = true;
                CubitProvider.of<MainCubit>(context).getQuestions();
              },
              icon: Icon(
                FontAwesomeIcons.stethoscope,
                color: Colors.white,
              ),
              label: Text("Assess Again",
                  style: TextStyle(color: Colors.white, fontSize: 16)))
        ]),
      ));

  _updateStatus() {
    if (_currentStatus == "EMERGENCY") {
      _currentStatus = "OTW";
      return widget.mainCubit.statusUpdate("OTW");
    }
    _currentStatus = "ATH";
    return widget.mainCubit.statusUpdate("ATH");
  }

  _getNextStatus() {
    if (_currentStatus == "EMERGENCY")
      return "OTW";
    else
      "ATH";
  }

  _showAmbRequired() async {
    var alert = AlertDialog(
      title: Center(
        child: const Text(
          'Emergency',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      content: const Text(
        'Do you need an ambulance?',
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 15,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancel',
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(false);
            _notificationSent = true;
            await widget.mainCubit.notify("EBUTTON", true);
            // await widget.mainCubit.fetchEmergencyDetails();
          },
          child: const Text(
            'Yes',
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(false);
            await widget.mainCubit.notify("QUESTIONNAIRE", false);
            // await widget.mainCubit.fetchEmergencyDetails();
          },
          child: const Text(
            'No',
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  _buildDriverDetails() => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "Ambulance's Information",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(20)),
            width: SizeConfig.screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Name: "),
                  Text(eDetails.driverDetails.name),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Plate Number: "),
                  Text(eDetails.driverDetails.plateNumber),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Contact Number: "),
                  Text(eDetails.driverDetails.contactNumber),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                  text: "Location : ",
                  style: GoogleFonts.montserrat(color: Colors.black),
                  children: [
                    TextSpan(
                        text: eDetails.driverDetails.address,
                        style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
            ])),
      ]);

  _buildEmergencyButton() => InkWell(
        onTap: () async {
          if (!_emergency)
            await widget.mainCubit.notify("EBUTTON", true);
          else {
            _showLoader();
            loc.Location location = await _getLocation();
            _hideLoader();
            return widget.homePageAdapter
                .loadEmergencyScreen(context, UserType.PATIENT, location);
          }
        },
        child: Container(
            color: Colors.red[400],
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ListTile(
              leading: Icon(CupertinoIcons.exclamationmark_bubble,
                  color: Colors.white),
              title: Text(
                "Press here for Emergency Service!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              subtitle: Text(
                "Emergency Situation ->",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )),
      );

  // _buildHeader() => Container(
  //     color: kPrimaryLightColor,
  //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
  //     child: ListTile(
  //       leading: Icon(CupertinoIcons.person, color: Colors.white),
  //       title: Text(
  //         "You are healthy!!",
  //         style: TextStyle(color: Colors.white, fontSize: 20),
  //       ),
  //       subtitle: Text(
  //         "Medications and Ongoing treatment ->",
  //         style: TextStyle(color: Colors.white, fontSize: 12),
  //       ),
  //     ));
}
