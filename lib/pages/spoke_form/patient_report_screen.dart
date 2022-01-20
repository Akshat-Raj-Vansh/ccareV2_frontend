//@dart=2.9
import 'dart:developer';
import 'dart:io';

import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/home/components/fullImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../utils/size_config.dart';

import 'package:sizer/sizer.dart';

class PatientReportScreen extends StatefulWidget {
  final MainCubit mainCubit;
  final UserType user;
  final PatientDetails patientDetails;

  const PatientReportScreen(
      {Key key, this.mainCubit, this.user, this.patientDetails})
      : super(key: key);
  @override
  _PatientReportScreenState createState() => _PatientReportScreenState();
}

class _PatientReportScreenState extends State<PatientReportScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  bool editReport = false;
  bool clickImage = false;
  String imagePath;
  XFile _image;
  MainState currentState;
  final ImagePicker _imagePicker = ImagePicker();
  final List<Tab> _myTabs = [
    Tab(
      child: Text('Overview'),
    ),
    Tab(
      child: Text('ECG Report'),
    ),
    Tab(
      child: Text('Medical History'),
    ),
    Tab(
      child: Text('Chest Report'),
    ),
    Tab(
      child: Text('Symptoms'),
    ),
    Tab(
      child: Text('Examination'),
    ),
  ];
  bool ecgUploaded = false;
  bool noReport = true;
  int _currentIndex = 0;
  TreatmentReport editedReport = TreatmentReport.initialize();
  TreatmentReport previousReport = TreatmentReport.initialize();
  bool previousReportExists = false;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: _myTabs.length);
    _tabController.addListener(_handleTabSelection);
    _fetchReport();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  _imgFromCamera() async {
    XFile image = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
       clickImage = true;
      print(_image.path);
      // widget.mainCubit.imageClicked(image);
    });
  }

  _imgFromGallery() async {
    XFile image = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
       clickImage = true;
      print(_image.path);
      // widget.mainCubit.imageClicked(image);
    });
  }

  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showLoader() {
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
    Navigator.of(context, rootNavigator: true).pop();
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

  _fetchReport() async {
    //print("Fetching patient report");
    widget.mainCubit.fetchPatientReport();
    // widget.mainCubit.fetchImage(widget.patientDetails.id);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CubitConsumer<MainCubit, MainState>(
      cubit: widget.mainCubit,
      builder: (_, state) {
        if (state is PatientReportFetched) {
          //print("Patient Report Fetched state Called");
          log('LOG > patient_report_screen.dart > 179 > state: ${state.toString()}');
          editedReport = state.mixReport.currentTreatment;
          print('LOG > patient_report_screen.dart > 182 > editedReport: ${editedReport.ecg.ecg_time.toString() == "nill" }');
          if (state.mixReport.previousTreatment != null)
            previousReport = state.mixReport.previousTreatment;
          //print(editedReport.toString());
          if (state.mixReport.previousTreatment != null) {
            previousReport = state.mixReport.previousTreatment;
            previousReportExists = true;
          }
          noReport = false;
          currentState = state;
          if (editedReport.ecg.ecg_file_id != null) {
            ecgUploaded = true;
          }
        }
        if (state is ImageLoaded) {
          log('LOG > patient_report_screen.dart > 195 > state: ${state.toString()}');
          _image = state.image;
        }
        if (state is NoReportState) {
          //print('No Report State Called');
          log('LOG > patient_report_screen.dart > 201 > state: ${state.toString()}');
          currentState = state;
          noReport = true;
          editReport = false;
        }
        if (currentState == null) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return buildUI();
      },
      listener: (context, state) {
        if (state is PatientReportFetched) {
          //print("Patient Report Fetched state Called");
          log('LOG > patient_report_screen.dart > 179 > state: ${state.toString()}');
          editedReport = state.mixReport.currentTreatment;
          log('LOG > patient_report_screen.dart > 182 > editedReport: ${editedReport}');
          if (state.mixReport.previousTreatment != null)
            previousReport = state.mixReport.previousTreatment;
          //print(editedReport.toString());
          if (state.mixReport.previousTreatment != null) {
            previousReport = state.mixReport.previousTreatment;
            previousReportExists = true;
          }
          noReport = false;
          currentState = state;
          if (editedReport.ecg.ecg_file_id != null) {
            ecgUploaded = true;
          }
        }
        if (state is EditPatientReport) {
          // _hideLoader();
          editReport = true;
          log('LOG > patient_report_screen.dart > 222 > state: ${state.toString()}');
        }
        if (state is ViewPatientReport) {
          // _hideLoader();
          editReport = false;
          log('LOG > patient_report_screen.dart > 227 > state: ${state.toString()}');
          //  widget.mainCubit.fetchPatientReport();
        }
        if (state is ImageCaptured) {
          // _hideLoader();
          clickImage = true;
          log('LOG > patient_report_screen.dart > 233 > state: ${state.toString()}');
          //  widget.mainCubit.fetchPatientReport();
        }
        if (state is PatientReportSaved) {
          //print("Patient Report Saved state Called");
          //print(state.msg);
          log('LOG > patient_report_screen.dart > 239 > state: ${state.toString()}');
          // _hideLoader();
          _showMessage('Report Saved');
          editReport = false;
          widget.mainCubit.fetchPatientReport();
        }
      },
    );
  }

  buildUI() {
    //print(widget.user);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Medical Form'),
        backgroundColor: kPrimaryColor,
        actions: [
          if (_currentIndex != 0 && widget.user == UserType.SPOKE)
            editReport
                ? TextButton(
                    onPressed: () async {
                      //print(editedReport.toString());
                      widget.mainCubit.savePatientReport(editedReport);
                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      //print('Edit Report Button Pressed');
                      widget.mainCubit.editPatientReport();
                    },
                    child: Text(
                      'EDIT',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
          IconButton(
            onPressed: () async {
              //print('Refresh button pressed');
              _fetchReport();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
        bottom: TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.white.withOpacity(0.3),
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: _myTabs,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: noReport && widget.user == UserType.PATIENT
          ? Center(child: Text('No Report Found'))
          : _buildFormBody(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          if (_currentIndex != 5)
            SpeedDialChild(
                label: 'Examination Report',
                onTap: () {
                  _tabController.animateTo(5);
                }),
          if (_currentIndex != 4)
            SpeedDialChild(
                label: 'Symptoms',
                onTap: () {
                  _tabController.animateTo(4);
                }),
          if (_currentIndex != 3)
            SpeedDialChild(
                label: 'Chest Report',
                onTap: () {
                  _tabController.animateTo(3);
                }),
          if (_currentIndex != 2)
            SpeedDialChild(
                label: 'Medical History',
                onTap: () {
                  _tabController.animateTo(2);
                }),
          if (_currentIndex != 1)
            SpeedDialChild(
                label: 'ECG Report',
                onTap: () {
                  _tabController.animateTo(1);
                }),
          if (_currentIndex != 0)
            SpeedDialChild(
                label: 'Overview',
                onTap: () {
                  _tabController.animateTo(0);
                }),
        ],
      ),
    );
  }

  _buildDetailsBody(_currentReportDetails, _previousReportDetails) => Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Current Report",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
          ),
          _currentReportDetails,
          SizedBox(
            height: 20,
          ),
          Text(
            "Previous Report",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
          ),
          _previousReportDetails,
        ],
      );

  _buildFormBody() => TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
            child: _buildReportOverview(),
          ),
          Container(
            child: editReport
                ? _buildECGForm()
                : _buildDetailsBody(_buildECGDetails(editedReport),
                    _buildECGDetails(previousReport)),
          ),
          Container(
              child: editReport
                  ? _buildMedHistForm()
                  : _buildDetailsBody(_buildMedHistDetails(editedReport),
                      _buildMedHistDetails(previousReport))
              //   : _buildMedHistDetails(editedReport),
              ),
          Container(
            child: editReport
                ? _buildChestForm()
                : _buildDetailsBody(_buildChestDetails(editedReport),
                    _buildChestDetails(previousReport)),
          ),
          Container(
            child: editReport
                ? _buildSymptomsForm()
                : _buildDetailsBody(_buildSymptomsDetails(editedReport),
                    _buildSymptomsDetails(previousReport)),
          ),
          Container(
            child: editReport
                ? _buildExaminationForm()
                : _buildDetailsBody(_buildExaminationDetails(editedReport),
                    _buildExaminationDetails(previousReport)),
          ),
        ],
      );

  _buildReportOverview() => SingleChildScrollView(
        child: Column(
          children: [
            // Patient Arrival Detail and Personal Information

            SizedBox(height: 2.h),
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Report Edit Details",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
              ),
            ),
            _buildReportDetails(),
            // Report Edit details
            //  _buildEditDetails(),
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
            _buildECGDetails(editedReport),

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
            _buildMedHistDetails(editedReport),

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
            _buildChestDetails(editedReport),

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
            _buildSymptomsDetails(editedReport),

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
            _buildExaminationDetails(editedReport),
          ],
        ),
      );

  _buildReportDetails(){
 
    return Container(
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(20),
        ),
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date: "),
                Text(DateTime.fromMillisecondsSinceEpoch(
                        int.parse(editedReport.report_time==null?DateTime.now().millisecondsSinceEpoch.toString():editedReport.report_time))
                    .toString()
                    .split(' ')[0]),
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Time: "),
                Text(DateTime.fromMillisecondsSinceEpoch(
                        int.parse(editedReport.report_time==null?DateTime.now().millisecondsSinceEpoch.toString():editedReport.report_time))
                    .toString()
                    .split(' ')[1]),
              ],
            ),
          ],
        ),
      );}

  _buildECGDetails(TreatmentReport treatmentReport) => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            // ECG Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Time: '),
                Text(treatmentReport.ecg.ecg_time.toString() == "nill"
                    ?"nill"
                    : DateTime.fromMillisecondsSinceEpoch(
                            int.parse(editedReport.ecg.ecg_time=="nill"? "0":editedReport.ecg.ecg_time))
                        .toString()),
              ],
            ),
            SizedBox(height: 1.h),
            // ECG Scan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Scan: '),
                //  ecgUploaded
                treatmentReport.ecg.ecg_file_id != "nill"
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return FullScreenImage(
                              imageUrl:
                                  "$BASEURL/treatment/fetchECG?fileID=${treatmentReport.ecg.ecg_file_id}",
                              tag: "generate_a_unique_tag",
                            );
                          }));
                        },
                        child: Hero(
                          child: Image(
                              image: NetworkImage(
                                  "$BASEURL/treatment/fetchECG?fileID=${treatmentReport.ecg.ecg_file_id}",
                                  headers: {
                                    "Authorization":
                                        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjFiOWNmNGNjNzUxNjMwZWFjOTI2MmY4IiwiaWF0IjoxNjM5NTY3MTgxLCJleHAiOjE2NDAxNzE5ODEsImlzcyI6ImNvbS5jY2FyZW5pdGgifQ.-LlsoqD5xKwUlm16-PBZzdO-kKBC9VK-otDoKwdWL00"
                                  }),
                              width: 30.w,
                              height: 15.h,
                              fit: BoxFit.cover),
                          tag: "generate_a_unique_tag",
                        ),
                      )
                    : SizedBox()
              ],
            ),
            SizedBox(height: 1.h),
            // ECG Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Type: '),
                Text(treatmentReport.ecg.ecg_type.toString().split('.')[1]),
              ],
            ),

            SizedBox(height: 3.h),
          ],
        ),
      );
  _buildMedHistDetails(TreatmentReport treatmentReport) => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            // Smoker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Smoker: '),
                Text(treatmentReport.medicalHist.smoker
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
                Text(treatmentReport.medicalHist.diabetic
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
                Text(treatmentReport.medicalHist.hypertensive
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
                Text(treatmentReport.medicalHist.dyslipidaemia
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
                Text(treatmentReport.medicalHist.old_mi
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
                Text(treatmentReport.medicalHist.trop_i),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      );
  _buildChestDetails(TreatmentReport treatmentReport) => Container(
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
                Text(treatmentReport.chestReport.chest_pain
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
                Text(treatmentReport.chestReport.site.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Pain Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Location: '),
                Text(treatmentReport.chestReport.location
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Intensity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Intensity: '),
              Text(treatmentReport.chestReport.intensity
                  .toString()
                  .split('.')[1]),
            ]),
            SizedBox(height: 1.h),
            // Severity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Severity: '),
              Text(treatmentReport.chestReport.severity
                  .toString()
                  .split('.')[1]),
            ]),
            SizedBox(height: 1.h),
            // Radiation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Radiation: '),
                Text(treatmentReport.chestReport.radiation
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
                Text(treatmentReport.chestReport.duration),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      );
  _buildSymptomsDetails(TreatmentReport treatmentReport) => Container(
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
                Text(treatmentReport.symptoms.postural_black_out
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Palpitations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Light Headedness: '),
                Text(treatmentReport.symptoms.light_headedness
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            //Sweating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sweating: '),
                Text(
                    treatmentReport.symptoms.sweating.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Nausea
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nausea/Vomiting: '),
                Text(treatmentReport.symptoms.nausea.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Shortness of breath
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shortness of breath: '),
                Text(treatmentReport.symptoms.shortness_of_breath
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Loss of conciousness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loss of Consciousness: '),
                Text(treatmentReport.symptoms.loss_of_consciousness
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      );
  _buildExaminationDetails(TreatmentReport treatmentReport) => Container(
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
                Text(treatmentReport.examination.pulse_rate),
              ],
            ),
            SizedBox(height: 1.h),
            // BP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('BP: '),
                Text(treatmentReport.examination.bp),
              ],
            ),
            SizedBox(height: 1.h),
            // Local Tenderness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Local Tederness: '),
                Text(treatmentReport.examination.local_tenderness),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(100)),
          ],
        ),
      );

  _buildECGForm() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            // // ECG Time
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('ECG Time: '),
            //     Container(
            //       width: SizeConfig.screenWidth * 0.4,
            //       child: TextFormField(
            //         keyboardType: TextInputType.text,
            //         focusNode: null,
            //         initialValue: editedReport.ecg.ecg_time,
            //         onChanged: (newValue) =>
            //             editedReport.ecg.ecg_time = newValue,
            //         decoration: const InputDecoration(
            //           hintText: "Enter ECG Time",
            //           floatingLabelBehavior: FloatingLabelBehavior.always,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height : 2.h),
            // // ECG Scan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Scan: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: InkWell(
                    child: Text(
                      'Upload ECG Scan',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                    onTap: () {
                      _showPicker(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // ECG Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Type: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<ECGType>(
                    value: editedReport.ecg.ecg_type,
                    isDense: false,
                    onChanged: (ECGType newValue) {
                      setState(() {
                        editedReport.ecg.ecg_type = newValue;
                      });
                    },
                    items: ECGType.values.map((ECGType value) {
                      return DropdownMenuItem<ECGType>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            InkWell(
                onTap: () async {
                  widget.mainCubit.imageClicked(_image,
                      editedReport.ecg.ecg_type.toString().split(".")[1]);
                },
                child: Container(
                  width: SizeConfig.screenWidth,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Upload ECG",
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    textAlign: TextAlign.center,
                  ),
                )),

            SizedBox(height: getProportionateScreenHeight(50)),
            if (clickImage)
              Expanded(
                child: Image.file(
                  File(_image.path),
                  // height : 15.h,
                  // width : 33.w,
                ),
              ),

            SizedBox(height: getProportionateScreenHeight(50)),
          ],
        ),
      );
  _buildMedHistForm() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),

            // Smoker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Smoker: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.medicalHist.smoker,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.medicalHist.smoker = newValue;
                      });
                    },
                    items: YN.values.map((YN value) {
                      return DropdownMenuItem<YN>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Diabetic
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Diabetic: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.medicalHist.diabetic,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.medicalHist.diabetic = newValue;
                      });
                    },
                    items: YN.values.map((YN value) {
                      return DropdownMenuItem<YN>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hypertensive: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.medicalHist.hypertensive,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.medicalHist.hypertensive = newValue;
                      });
                    },
                    items: YN.values.map((YN value) {
                      return DropdownMenuItem<YN>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Dyslipidaemia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dyslipidaemia: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.medicalHist.dyslipidaemia,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.medicalHist.dyslipidaemia = newValue;
                      });
                    },
                    items: YN.values.map((YN value) {
                      return DropdownMenuItem<YN>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Old MI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Old MI: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.medicalHist.old_mi,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.medicalHist.old_mi = newValue;
                      });
                    },
                    items: YN.values.map((YN value) {
                      return DropdownMenuItem<YN>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Trop I
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trop I: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: null,
                    initialValue: editedReport.medicalHist.trop_i,
                    onChanged: (newValue) =>
                        editedReport.medicalHist.trop_i = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter Trop I",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  _buildChestForm() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            // Chest Pain
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chest Pain: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.chestReport.chest_pain,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.chestReport.chest_pain = newValue;
                      });
                    },
                    items: YN.values.map((YN value) {
                      return DropdownMenuItem<YN>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Site
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Site: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<Site>(
                    value: editedReport.chestReport.site,
                    isDense: false,
                    onChanged: (Site newValue) {
                      setState(() {
                        editedReport.chestReport.site = newValue;
                      });
                    },
                    items: Site.values.map((Site value) {
                      return DropdownMenuItem<Site>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Location: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<Location>(
                    value: editedReport.chestReport.location,
                    isDense: false,
                    onChanged: (Location newValue) {
                      setState(() {
                        editedReport.chestReport.location = newValue;
                      });
                    },
                    items: Location.values.map((Location value) {
                      return DropdownMenuItem<Location>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Intensity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Intensity: '),
              Container(
                width: SizeConfig.screenWidth * 0.4,
                child: DropdownButton<Intensity>(
                  value: editedReport.chestReport.intensity,
                  isDense: false,
                  onChanged: (Intensity newValue) {
                    setState(() {
                      editedReport.chestReport.intensity = newValue;
                    });
                  },
                  items: Intensity.values.map((Intensity value) {
                    return DropdownMenuItem<Intensity>(
                      value: value,
                      child: Text(value.toString().split('.')[1]),
                    );
                  }).toList(),
                ),
              ),
            ]),

            SizedBox(height: 1.h),
            // Severity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Severity: '),
              Container(
                width: SizeConfig.screenWidth * 0.4,
                child: DropdownButton<Severity>(
                  value: editedReport.chestReport.severity,
                  isDense: false,
                  onChanged: (Severity newValue) {
                    setState(() {
                      editedReport.chestReport.severity = newValue;
                    });
                  },
                  items: Severity.values.map((Severity value) {
                    return DropdownMenuItem<Severity>(
                      value: value,
                      child: Text(value.toString().split('.')[1]),
                    );
                  }).toList(),
                ),
              ),
            ]),
            SizedBox(height: 1.h),
            // Radiation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Radiation: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<Radiation>(
                    value: editedReport.chestReport.radiation,
                    isDense: false,
                    onChanged: (Radiation newValue) {
                      setState(() {
                        editedReport.chestReport.radiation = newValue;
                      });
                    },
                    items: Radiation.values.map((Radiation value) {
                      return DropdownMenuItem<Radiation>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration (in mins): '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    focusNode: null,
                    initialValue: editedReport.chestReport.duration,
                    onChanged: (newValue) =>
                        editedReport.chestReport.duration = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter duration",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  _buildSymptomsForm() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            // Postural Blackout
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Postural Black Out: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.symptoms.postural_black_out,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.symptoms.postural_black_out = newValue;
                      });
                    },
                    items: YN.values.map((YN value) {
                      return DropdownMenuItem<YN>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Light Headedness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Light Headedness: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.symptoms.light_headedness,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.symptoms.light_headedness = newValue;
                      });
                    },
                    items: YN.values.map((YN value) {
                      return DropdownMenuItem<YN>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Sweating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sweating: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.symptoms.sweating,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.symptoms.sweating = newValue;
                      });
                    },
                    items: YN.values.map((YN value) {
                      return DropdownMenuItem<YN>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Nausea
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nausea/Vomiting: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.symptoms.nausea,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.symptoms.nausea = newValue;
                      });
                    },
                    items: YN.values.map((YN value) {
                      return DropdownMenuItem<YN>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Shortness of breath
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shortness of breath: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.symptoms.shortness_of_breath,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.symptoms.shortness_of_breath = newValue;
                      });
                    },
                    items: YN.values.map((YN value) {
                      return DropdownMenuItem<YN>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Loss of conciousness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loss of Conciousness: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.symptoms.loss_of_consciousness,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.symptoms.loss_of_consciousness = newValue;
                      });
                    },
                    items: YN.values.map((YN value) {
                      return DropdownMenuItem<YN>(
                        value: value,
                        child: Text(value.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  _buildExaminationForm() => Container(
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
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: null,
                    initialValue: editedReport.examination.pulse_rate,
                    onChanged: (newValue) =>
                        editedReport.examination.pulse_rate = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter Pulse Rate",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // BP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('BP: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: null,
                    onChanged: (newValue) =>
                        editedReport.examination.bp = newValue,
                    initialValue: editedReport.examination.bp,
                    decoration: const InputDecoration(
                      hintText: "Enter BP",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Local Tenderness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Local Tenderness: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: null,
                    onChanged: (newValue) =>
                        editedReport.examination.local_tenderness = newValue,
                    initialValue: editedReport.examination.local_tenderness,
                    decoration: const InputDecoration(
                      hintText: "Enter local tenderness",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
