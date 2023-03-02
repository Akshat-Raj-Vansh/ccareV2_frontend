//@dart=2.9
import 'dart:developer';

import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/question.dart';
import 'package:sizer/sizer.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/pages/home/components/fullImage.dart';
import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_exam_screen.dart';
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
  static String _currentStatus = "EMERGENCY";
  List<QuestionTree> display = [];
  List<String> answers = [];
  int length = 1;
  TextStyle styles = TextStyle(color: Colors.white, fontSize: 14.sp);
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
    print('DATA > patient.dart > 87 > Inside initState');
    CubitProvider.of<MainCubit>(context).fetchEmergencyDetails();
    CubitProvider.of<MainCubit>(context).getStatus();
    // CubitProvider.of<MainCubit>(context).recentHistory();
    //CubitProvider.of<MainCubit>(context).getQuestions();
    NotificationController.configure(
        CubitProvider.of<MainCubit>(context), UserType.PATIENT, context);
    NotificationController.fcmHandler();
  }

  Future<loc.Location> _getLocation() async {
    lloc.LocationData _locationData = await lloc.Location().getLocation();
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
            .copyWith(color: Colors.white, fontSize: 12.sp),
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
        title: Text(
          'CardioCare - Patient',
          style: TextStyle(fontSize: 16.sp),
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          if (!_emergency && currentState == QuestionnaireState)
            IconButton(
              onPressed: () async {
                setState(() {
                  display.forEach((element) {
                    element.answers = [];
                    element.status = false;
                  });
                  display = [];
                  answers = [];
                  display.add(_questions
                      .firstWhere((element) => element.parent == "root"));
                });
              },
              icon: Icon(FontAwesomeIcons.recycle),
            ),
          IconButton(
            onPressed: () async {
              await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Are you sure?',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      content: Text(
                        'Do you want to logout?',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12.sp,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            'Cancel',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            widget.homePageAdapter
                                .onLogout(context, widget.userCubit);
                          },
                          child: Text(
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
          if (state is NewErrorState) {
            // if (state.prevState == "QuestionnaireState") {
            //   _hideLoader();
            //   CubitProvider.of<MainCubit>(context).recentHistory();
            // }
            if (state.prevState == "DetailsLoaded") {
              if (state.error != "Doesn't Exist") _notificationSent = true;
              _hideLoader();
              CubitProvider.of<MainCubit>(context).recentHistory();
            }
            if (state.prevState == "PreviousHistory") {
              _hideLoader();
              CubitProvider.of<MainCubit>(context).getQuestions();
            }
          }
          if (state is DetailsLoaded) {
            print('DATA > patient.dart > 222 > Inside DetailsLoaded State}');
            print('STATE: DetailsLoaded Builder');
            currentState = DetailsLoaded;

            // // _hideLoader();
            _notificationSent = true;
            eDetails = state.eDetails;
            // _currentStatus = "EMERGENCY";
            _emergency = true;
            if (eDetails.doctorDetails != null) {
              _doctorAccepted = true;
              //    _emergency = true;
            }
            if (eDetails.driverDetails != null) {
              _driverAccepted = true;
              //   _emergency = true;
            }
            //  setState(() {});
          }
          if (state is QuestionnaireState && display.length == 0) {
            //print("Questionnaire State Called X");
            //_currentStatus = "SELFANANLYSIS";
            currentState = QuestionnaireState;
            // display.forEach((element) {
            //   element.answers = [];
            //   element.status = false;
            // });
            // display = [];
            // answers = [];

            _questions = state.questions;
            display.add(
                _questions.firstWhere((element) => element.parent == "root"));

            //print(display[0].status);
            _questionnaire = true;
          }
          if (state is PreviousHistory) {
            _treatmentReport = state.treatmentReport;
            //  _currentStatus = "HISTORY";
            currentState = PreviousHistory;
            if (_treatmentReport != null) _historyFetched = true;
          }
          if (state is NormalState) {
            //  currentState = NormalState;
            if (state.msg == "NOT ASSIGNED") _notificationSent = true;
          }
          if (state is StatusFetched) {
            // _hideLoader();

            log('DATA > patient.dart > FUNCTION_NAME > 237 > state.msg: ${state.msg}');
            _currentStatus = state.msg;
          }
          if (currentState == null)
            return Center(child: CircularProgressIndicator());

          // //print('currentState ' + currentState.toString());
          // //print('notificationSent ' + _notificationSent.toString());
          // //print('historyFetched ' + _historyFetched.toString());
          // //print('_questionnaire ' + _questionnaire.toString());
          return _buildUI(context);
        },
        listener: (context, state) async {
          if (state is LoadingState) {
            //print("Loading State Called Patient");
            _showLoader();
          } else if (state is StatusFetched) {
            _hideLoader();
            print(
                'DATA > patient.dart > FUNCTION_NAME > 237 > state.msg: ${state.msg}');
            _currentStatus = state.msg;
          } else if (state is EmergencyState) {
            _hideLoader();
            _notificationSent = true;
            _emergency = true;
            _currentStatus = "EMERGENCY";
            //print("Emergency State Called");
            // _showMessage("Notifications sent to the Doctor and the Ambulance.");
          } else if (state is DetailsLoaded) {
            _hideLoader();
            //print('details loaded');
            setState(() {});
            //  _currentStatus = EDetails.patientDetails.status;
          } else if (state is NormalState) {
            _hideLoader();
            _showMessage(state.msg);
          } else if (state is ErrorState) {
            _hideLoader();
            //print('Error State ' + state.error);
          } else if (state is QuestionnaireState) {
            //print("Questionnaire State Called");
            _hideLoader();
            // _questions = state.questions;

            //  display = [];
            //  answers = [];
            // display.add(
            //     _questions.firstWhere((element) => element.parent == "root"));
            //   //print(display[0].status);
            if (_assessAgain) {
              _hideLoader();
              CubitProvider.of<MainCubit>(context).selfAssessment();
            }
          } else if (state is SelfAssessmentState) {
            var cubit = CubitProvider.of<MainCubit>(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SelfAssessment(state.questions, cubit, "homescreen"),
              ),
            );
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

              if (_historyFetched && !_notificationSent)
                _buildSelfAnalysisButton(),
              if (!_historyFetched && _questionnaire && !_notificationSent)
                _buildQuestionnaire(),
              if (_historyFetched && !_notificationSent) _buildReportOverview(),

              if (_notificationSent && (!_doctorAccepted && !_driverAccepted))
                _buildNotificationSend(),
              if (_doctorAccepted || _driverAccepted)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Emergency Information",
                    style: TextStyle(fontSize: 18.sp),
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
                        style: TextStyle(fontSize: 14.sp),
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
              if (_currentStatus == "UGT" &&
                  currentState != PreviousHistory &&
                  currentState != QuestionnaireState)
                _buildPatientReportButton(),
              if (!_questionnaire || _notificationSent)
                _buildPatientReportHistoryButton(),
              if (_currentStatus == "UGT" &&
                  currentState != PreviousHistory &&
                  currentState != QuestionnaireState)
                _buildPatientTreatmentReportButton(),
            ],
          ),
        ),
        if ((_questionnaire || _historyFetched) && !_notificationSent)
          _buildPatienEmergencyButton(),
        if (_notificationSent || _doctorAccepted || _driverAccepted)
          _buildBottomUI(context)
      ]);

  _buildPatienEmergencyButton() => Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () async {
            _showAmbRequired("EBUTTON");
            setState(() {});
          },
          child: Container(
            width: SizeConfig.screenWidth,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.red)),
            child: Text(
              "Press here if you require Emergency AID",
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

  _buildSelfAnalysisButton() => InkWell(
        onTap: () async {
          _assessAgain = true;
          CubitProvider.of<MainCubit>(context).getQuestions();
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.green)),
          child: Text(
            "Press here to proceed to Questionnaire",
            style: TextStyle(color: Colors.green, fontSize: 14),
            textAlign: TextAlign.center,
          ),
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
              padding: const EdgeInsets.all(10),
              child: Text(
                'Self Analysis',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: pad,
              decoration: decA,
              child: Text(
                "Please enter correct inputs to ensure proper results",
                style: styles,
              ),
            ),
            SingleChildScrollView(
              child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    if (display[index].status) {
                      //print("cmp");
                      // //print(display);
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
                    //print("here");
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
                                  //print(answers.join(','));
                                  try {
                                    // display.add(_questions.firstWhere(
                                    //     (element) =>
                                    //         element.parent ==
                                    //             display[index].question &&
                                    //         element.when == answers.join(',')));
                                    print('3333333333333333');
                                    print(display);
                                    _showAmbRequired("QUESTIONNAIRE");
                                  } catch (e) {
                                    //print(e);
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

                                if (display.last.node_type == NodeType.RESULT) {
                                  if (display.last.options[0] == "EMERGENCY") {
                                    _showAmbRequired("QUESTIONNAIRE");
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
                                  //print(display.last.question);

                                  if (display.last.node_type ==
                                      NodeType.RESULT) {
                                    //print("INSIDE");
                                    if (display.last.options[0] ==
                                        "EMERGENCY") {
                                      //print("Inside");
                                      _showAmbRequired("QUESTIONNAIRE");
                                    }
                                  }
                                } catch (e) {
                                  //print(e);
                                }
                                //print(display.length);
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
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        subtitle: Text(
          "Waiting for the confimation from Doctor's and Ambulance's side ->",
          style: TextStyle(color: Colors.white, fontSize: 8.sp),
        ),
      ));

  _buildPatientReportButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientReportScreen(
                  mainCubit: widget.mainCubit,
                  user: UserType.PATIENT,
                ),
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
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildPatientReportHistoryButton() => InkWell(
        onTap: () async {
          print('Patient Report History');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => CubitProvider<MainCubit>(
                create: (_) => CubitProvider.of<MainCubit>(context),
                child: PatientReportHistoryScreen(mainCubit: widget.mainCubit),
              ),
            ),
          );
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
            style: TextStyle(color: kPrimaryColor, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
  _buildPatientTreatmentReportButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientExamScreen(
                  mainCubit: widget.mainCubit,
                  user: UserType.PATIENT,
                ),
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
            "View your Treatment Report",
            style: TextStyle(color: kPrimaryColor, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _makingPhoneCall() async {
    String url = eDetails.doctorDetails.contactNumber;
    await launch("tel:$url");
  }

  _buildDoctorDetails() => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "Doctor's Information",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14.sp),
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
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hospital: "),
                  Text(eDetails.doctorDetails.hospital),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                      onPressed: _makingPhoneCall,
                      icon: Icon(Icons.phone),
                      label: Text("CALL")),
                  TextButton.icon(
                      onPressed: () => {}, //print("CANCEL"),
                      icon: Icon(Icons.info),
                      label: Text("Spoke Doctor"))
                ],
              ),
              SizedBox(
                height: 1.h,
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
        height: 10.h,
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.all(5.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          if (_currentStatus != "ATH" &&
              _currentStatus != "UGT" &&
              _doctorAccepted)
            ElevatedButton.icon(
                // color: Theme.of(context).primaryColor,
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20)),
                onPressed: () async {
                  //print(_emergency);
                  if (!_emergency) {
                    _showAmbRequired("EBUTTON");
                  } else {
                    // _showLoader();
                    // loc.Location location = await _getLocation();
                    // // _hideLoader();
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
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                )),
          // ElevatedButton.icon(
          //     color: Theme.of(context).primaryColor,
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(20)),
          //     onPressed: () async {
          //       _assessAgain = true;
          //       CubitProvider.of<MainCubit>(context).getQuestions();
          //     },
          //     icon: Icon(
          //       FontAwesomeIcons.stethoscope,
          //       color: Colors.white,
          //     ),
          //     label: Text("Assess Again",
          //         style: TextStyle(color: Colors.white, fontSize: 12.sp)))
        ]),
      ));

  _updateStatus() {
    if (_currentStatus == "EMERGENCY") {
      _currentStatus = "OTW";
      return widget.mainCubit.statusUpdate("OTW", patientID: "");
    }
    _currentStatus = "ATH";
    return widget.mainCubit.statusUpdate("ATH", patientID: "");
  }

  _showAmbRequired(String action) async {
    var alert = AlertDialog(
      title: Center(
        child: Text(
          'Emergency',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
      content: Text(
        //    'Do you need an ambulance?',
        'Do you need an emergency service?',
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 12.sp,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(false);
            loc.Location location = await _getLocation();
            _notificationSent = true;

            await widget.mainCubit.notify(action, false, location,
                assessment: action == "QUESTIONNAIRE" ? display : null);
            // await widget.mainCubit.fetchEmergencyDetails();\
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).accentColor,
                content: Text(
                  "Emergency Notifications Sent to Doctor",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Colors.white, fontSize: 12.sp),
                ),
              ),
            );
          },
          child: Text(
            'Yes',
          ),
        ),
        // TextButton(
        //   onPressed: () async {
        //     // print(display);
        //     loc.Location location = await _getLocation();
        //     Navigator.of(context).pop(false);
        //     await widget.mainCubit.notify(action, false, location,
        //         assessment: action == "QUESTIONNAIRE" ? display : null);
        //     // await widget.mainCubit.fetchEmergencyDetails();
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       backgroundColor: Theme.of(context).accentColor,
        //       content: Text(
        //         "Emergency Notifications Sent to Doctor",
        //         style: Theme.of(context)
        //             .textTheme
        //             .caption
        //             .copyWith(color: Colors.white, fontSize: 12.sp),
        //       ),
        //     ));
        //   },
        //   child: Text(
        //     'No',
        //   ),
        // ),
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
            style: TextStyle(fontSize: 14.sp),
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
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Plate Number: "),
                  Text(eDetails.driverDetails.plateNumber),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Contact Number: "),
                  Text(eDetails.driverDetails.contactNumber),
                ],
              ),
              SizedBox(
                height: 1.h,
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

  _buildReportOverview() => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Patient Medical Report
            // ECG Report
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "ECG Report",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
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
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
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
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
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
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
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
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
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
            SizedBox(height: 2.h),
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
            SizedBox(height: 1.h),
            //  ECG Scan
            // #FIXME add multiple scans
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Scan: '),
                _treatmentReport.ecg.ecg_file_id.length > 0
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return FullScreenImage(
                              imageUrl:
                                  "$BASEURL/treatment/fetchECG?fileID=${_treatmentReport.ecg.ecg_file_id[0].file_id}",
                              tag: "generate_a_unique_tag",
                            );
                          }));
                        },
                        child: Hero(
                          child: Image(
                              image: NetworkImage(
                                  "$BASEURL/treatment/fetchECG?fileID=${_treatmentReport.ecg.ecg_file_id[0].file_id}",
                                  headers: {
                                    "Authorization":
                                        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjFhMWU5ZGNiYWI4MjZkZTk4NjBmNzkzIiwiaWF0IjoxNjM4MjY1MzkxLCJleHAiOjE2Mzg4NzAxOTEsImlzcyI6ImNvbS5jY2FyZW5pdGgifQ.K-_DprXx2ipOwWt17DODlMDqQSgtWdv8aARjlPdEuzA"
                                  }),
                              width: 30.w,
                              height: 15.h,
                              fit: BoxFit.cover),
                          tag: "generate_a_unique_tag",
                        ),
                      )
                    : Text('No ECG Uploaded'),
              ],
            ),
            SizedBox(height: 1.h),
            // ECG Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Type: '),
                Text(_treatmentReport.ecg.ecg_type.toString().split('.')[1]),
              ],
            ),

            SizedBox(height: 3.h),
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
            SizedBox(height: 2.h),
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
            SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
            // Trop I
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trop I: '),
                Text(_treatmentReport.medicalHist.trop_i
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 3.h),
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
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chest Pain: '),
                Text(_treatmentReport.chestReport.chest_pain
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Onset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Site: '),
                Text(
                    _treatmentReport.chestReport.site.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
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
            // SizedBox(height: 1.h),
            // // Intensity
            // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            //   Text('Intensity: '),
            //   Text(_treatmentReport.chestReport.intensity
            //       .toString()
            //       .split('.')[1]),
            // ]),
            SizedBox(height: 1.h),
            // Severity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Severity: '),
              Text(_treatmentReport.chestReport.severity
                  .toString()
                  .split('.')[1]),
            ]),
            SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
            // Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration: '),
                Text(_treatmentReport.chestReport.duration),
              ],
            ),
            SizedBox(height: 3.h),
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
            SizedBox(height: 2.h),

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
            // SizedBox(height: 1.h),
            // // Palpitations
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('Light Headedness: '),
            //     Text(_treatmentReport.symptoms.light_headedness
            //         .toString()
            //         .split('.')[1]),
            //   ],
            // ),
            SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
            // Nausea
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nausea/Vomiting: '),
                Text(_treatmentReport.symptoms.nausea.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
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
            // SizedBox(height: 1.h),
            // // Loss of conciousness
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('Loss of Consciousness: '),
            //     Text(_treatmentReport.symptoms.loss_of_consciousness
            //         .toString()
            //         .split('.')[1]),
            //   ],
            // ),

            SizedBox(height: 3.h),
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
            SizedBox(height: 2.h),
            // Pulse Rate

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pulse Rate: '),
                Text(_treatmentReport.examination.pulse_rate),
              ],
            ),
            SizedBox(height: 1.h),
            // DBP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DBP: '),
                Text(_treatmentReport.examination.dbp),
              ],
            ),
            SizedBox(height: 1.h),
            // SBP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SBP: '),
                Text(_treatmentReport.examination.sbp),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SpO2: '),
                Text(_treatmentReport.examination.spo2),
              ],
            ),
            SizedBox(height: 1.h),
            // Local Tenderness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Local Tederness: '),
                Text(_treatmentReport.examination.local_tenderness
                    .toString()
                    .split(".")[1]),
              ],
            ),

            SizedBox(height: getProportionateScreenHeight(100)),
          ],
        ),
      );
}
