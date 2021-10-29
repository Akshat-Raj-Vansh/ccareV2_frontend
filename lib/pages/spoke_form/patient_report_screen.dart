//@dart=2.9
import 'dart:io';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../utils/size_config.dart';

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
  final ImagePicker _imagePicker = ImagePicker();
  final List<Tab> _myTabs = [
    Tab(
      child: Text('Patient Details'),
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
  bool noReport = true;
  int _currentIndex = 0;
  TreatmentReport editedReport = TreatmentReport.initialize();

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
      widget.mainCubit.imageClicked();
    });
  }

  _imgFromGallery() async {
    XFile image = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      widget.mainCubit.imageClicked();
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
            .copyWith(color: Colors.white, fontSize: 16),
      ),
    ));
  }

  _fetchReport() async {
    print("Fetching patient report");
    widget.mainCubit.fetchPatientReport();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CubitConsumer<MainCubit, MainState>(
      cubit: widget.mainCubit,
      builder: (_, state) {
        return buildUI();
      },
      listener: (context, state) {
        if (state is PatientReportFetched) {
          print("Patient Report Fetched state Called");
          editedReport = state.report;
          noReport = false;
          _hideLoader();
        }
        if (state is EditPatientReport) {
          _hideLoader();
          editReport = true;
        }
        if (state is ViewPatientReport) {
          _hideLoader();
          editReport = false;
          //  widget.mainCubit.fetchPatientReport();
        }
        if (state is ImageCaptured) {
          _hideLoader();
          clickImage = true;
          //  widget.mainCubit.fetchPatientReport();
        }
        if (state is PatientReportSaved) {
          print("Patient Report Saved state Called");
          print(state.msg);
          _hideLoader();
          _showMessage('Report Saved');
          editReport = false;
          widget.mainCubit.fetchPatientReport();
        }
        if (state is NoReportState) {
          print('No Report State Called');
          _hideLoader();
          noReport = true;
        }
      },
    );
  }

  buildUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Medical Form'),
        actions: [
          if (_currentIndex != 0)
            editReport
                ? TextButton(
                    onPressed: () async {
                      print(editedReport.toString());
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
                      print('Edit Report Button Pressed');
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
              print('Refresh button pressed');
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
      body: _buildFormBody(),
      floatingActionButton: widget.user == UserType.doctor
          ? SpeedDial(
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
                      label: 'Patient Details',
                      onTap: () {
                        _tabController.animateTo(0);
                      }),
              ],
            )
          : null,
    );
  }

  _buildFormBody() => TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
            child: _buildReportOverview(),
          ),
          Container(
            child: editReport ? _buildECGForm() : _buildECGDetails(),
          ),
          Container(
            child: editReport ? _buildMedHistForm() : _buildMedHistDetails(),
          ),
          Container(
            child: editReport ? _buildChestForm() : _buildChestDetails(),
          ),
          Container(
            child: editReport ? _buildSymptomsForm() : _buildSymptomsDetails(),
          ),
          Container(
            child: editReport
                ? _buildExaminationForm()
                : _buildExaminationDetails(),
          ),
        ],
      );

  _buildReportOverview() => SingleChildScrollView(
        child: Column(
          children: [
            // Patient Arrival Detail and Personal Information
            _buildPatientDetails(),

            // Report Edit details
            _buildEditDetails(),

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
  _buildPatientDetails() => Container(
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(20),
        ),
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Patient Name: "),
                Text(widget.patientDetails.name),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Contact Number: "),
                Text(widget.patientDetails.contactNumber,
                    textAlign: TextAlign.right),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Address: "),
                Text(widget.patientDetails.address, textAlign: TextAlign.right),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Arrived At Hospital: "),
                Text("Date and Time", textAlign: TextAlign.right),
              ],
            ),
          ],
        ),
      );
  _buildEditDetails() => Container(
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(20),
        ),
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Last Edited: "),
                Text("10th Sept, 2021"),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Edited By: "),
                Text("Dr. Doom\nApollo Medical Hospital",
                    textAlign: TextAlign.right),
              ],
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Time: '),
                Text(editedReport.ecg.ecg_time),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // ECG Scan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Scan: '),
                Text(editedReport.ecg.ecg_file_id),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // ECG Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Type: '),
                Text(editedReport.ecg.ecg_type.toString().split('.')[1]),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Smoker: '),
                Text(editedReport.medicalHist.smoker.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Diabetic
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Diabetic: '),
                Text(
                    editedReport.medicalHist.diabetic.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hypertensive: '),
                Text(editedReport.medicalHist.hypertensive
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
                Text(editedReport.medicalHist.dyslipidaemia
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
                Text(editedReport.medicalHist.old_mi.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Trop I
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trop I: '),
                Text(editedReport.medicalHist.trop_i),
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
                Text(editedReport.chestReport.chest_pain
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
                Text(editedReport.chestReport.site.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Pain Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Location: '),
                Text(
                    editedReport.chestReport.location.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Intensity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Intensity: '),
              Text(editedReport.chestReport.intensity.toString().split('.')[1]),
            ]),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Severity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Severity: '),
              Text(editedReport.chestReport.severity.toString().split('.')[1]),
            ]),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Radiation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Radiation: '),
                Text(editedReport.chestReport.radiation
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
                Text(editedReport.chestReport.duration),
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
                Text(editedReport.symptoms.postural_black_out
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
                Text(editedReport.symptoms.light_headedness
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
                Text(editedReport.symptoms.sweating.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Nausea
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nausea/Vomiting: '),
                Text(editedReport.symptoms.nausea.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Shortness of breath
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shortness of breath: '),
                Text(editedReport.symptoms.shortness_of_breath
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
                Text(editedReport.symptoms.loss_of_consciousness
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
                Text(editedReport.examination.pulse_rate),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // BP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('BP: '),
                Text(editedReport.examination.bp),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Local Tenderness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Local Tederness: '),
                Text(editedReport.examination.local_tenderness),
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
            SizedBox(height: getProportionateScreenHeight(20)),
            // ECG Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Time: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    focusNode: null,
                    initialValue: editedReport.ecg.ecg_time,
                    onChanged: (newValue) =>
                        editedReport.ecg.ecg_time = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter ECG Time",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // ECG Scan
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
            SizedBox(height: getProportionateScreenHeight(20)),
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
            SizedBox(height: getProportionateScreenHeight(50)),
            if (clickImage)
              Expanded(
                child: Image.file(
                  File(_image.path),
                  // height: 120,
                  // width: 120,
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
            SizedBox(height: getProportionateScreenHeight(20)),

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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(20)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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

            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(20)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(20)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
            SizedBox(height: getProportionateScreenHeight(10)),
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
