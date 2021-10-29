//@dart=2.9
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart' as exam;
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../utils/size_config.dart';

class PatientExamScreen extends StatefulWidget {
  final MainCubit mainCubit;
  final UserType user;
  final PatientDetails patientDetails;

  const PatientExamScreen(
      {Key key, this.mainCubit, this.user, this.patientDetails})
      : super(key: key);
  @override
  _PatientExamScreenState createState() => _PatientExamScreenState();
}

class _PatientExamScreenState extends State<PatientExamScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  bool editReport = false;
  final List<Tab> _myTabs = [
    Tab(
      child: Text('Patient Details'),
    ),
    Tab(
      child: Text('Normal Treatment'),
    ),
    Tab(
      child: Text('Thromolysis'),
    ),
  ];
  bool noReport = true;
  int _currentIndex = 0;
  exam.Examination editedReport = exam.Examination.initialize();

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
    print("Fetching patient  exam report");
    await widget.mainCubit.fetchPatientExamReport();
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
        if (state is PatientExamReportFetched) {
          print("Patient Report Fetched state Called");
          editedReport = state.ereport;
          noReport = false;
          _hideLoader();
        }
        if (state is EditPatientExamReport) {
          _hideLoader();
          editReport = true;
        }
        if (state is ViewPatientExamReport) {
          _hideLoader();
          editReport = false;
          //  widget.mainCubit.fetchPatientReport();
        }
        if (state is PatientExamReportSaved) {
          print("Patient Exam Report Saved state Called");
          print(state.msg);
          _hideLoader();
          _showMessage('Report Saved');
          editReport = false;
          //widget.mainCubit.fetchPatientExamReport();
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
        title: Text('Examination Form'),
        actions: [
          if (_currentIndex != 0)
            editReport
                ? TextButton(
                    onPressed: () async {
                      print('before saving');
                      print(editedReport.toString());
                      widget.mainCubit.savePatientExamReport(editedReport);
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
                      widget.mainCubit.editPatientExamReport();
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
              //  _fetchReport();
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
    );
  }

  _buildFormBody() => TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
            child: _buildReportOverview(),
          ),
          Container(
            child:
                editReport ? _buildNTreatmentForm() : _buildNTreatmentDetails(),
          ),
          Container(
            child: editReport
                ? _buildThrombolysisForm()
                : _buildThrombolysisDetails(),
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
            // Normal Treatment
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Normal Treatment Report",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            _buildNTreatmentDetails(),

            // Thrombolysis
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Thrombolysis",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            _buildThrombolysisDetails(),
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

  _buildNTreatmentDetails() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),
            // Aspirin Loading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Aspirin Loading: '),
                Text(editedReport.nTreatment.aspirin_loading
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // SPT Loading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CPT Loading: '),
                Text(editedReport.nTreatment.c_p_t_loading
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // LMWH
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('LMWH: '),
                Text(editedReport.nTreatment.lmwh),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Statins
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Statins: '),
                Text(editedReport.nTreatment.statins),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Beta_Blockers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Beta Blockers: '),
                Text(editedReport.nTreatment.beta_blockers),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Nitrates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nitrates: '),
                Text(editedReport.nTreatment.nitrates),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Deuretics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Deuretics: '),
                Text(editedReport.nTreatment.diuretics),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // ACEI ARD
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ACEI ARD: '),
                Text(editedReport.nTreatment.acei_arb),
              ],
            ),

            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      );
  _buildThrombolysisDetails() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),
            // TNK ALU STK Successful
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TNK ALU STK Successful: '),
                Text(editedReport.thrombolysis.tnk_alu_stk_successful
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Death
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Death: '),
                Text(editedReport.thrombolysis.death.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Referral
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Referral: '),
                Text(editedReport.thrombolysis.referral
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Reason for Referral
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reason for Referral: '),
                Text(editedReport.thrombolysis.reason_for_referral),
              ],
            ),

            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      );

  _buildNTreatmentForm() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            // Aspirin Loading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Aspirin Loading: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.nTreatment.aspirin_loading,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.nTreatment.aspirin_loading = newValue;
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
            // CPT loading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CPT Loading: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.nTreatment.aspirin_loading,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.nTreatment.c_p_t_loading = newValue;
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
            // LMWH
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('LMWH: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: null,
                    initialValue: editedReport.nTreatment.lmwh,
                    onChanged: (newValue) =>
                        editedReport.nTreatment.lmwh = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter LMWH",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Statins
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Statins: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: null,
                    initialValue: editedReport.nTreatment.statins,
                    onChanged: (newValue) =>
                        editedReport.nTreatment.statins = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter Statins",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Beta Blockers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Beta Blockers: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: null,
                    initialValue: editedReport.nTreatment.beta_blockers,
                    onChanged: (newValue) =>
                        editedReport.nTreatment.beta_blockers = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter Beta Blockers",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Nitrates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nitrates: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: null,
                    initialValue: editedReport.nTreatment.nitrates,
                    onChanged: (newValue) =>
                        editedReport.nTreatment.nitrates = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter Nitrates",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Deuretics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('LMWH: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: null,
                    initialValue: editedReport.nTreatment.diuretics,
                    onChanged: (newValue) =>
                        editedReport.nTreatment.diuretics = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter Deuretics",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // ACEI ARB
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ACEI ARD: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: null,
                    initialValue: editedReport.nTreatment.acei_arb,
                    onChanged: (newValue) =>
                        editedReport.nTreatment.acei_arb = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter ACEI ARD",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  _buildThrombolysisForm() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            // TNK ALU STK Successful
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TNK ALU STK Successful: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.thrombolysis.tnk_alu_stk_successful,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.thrombolysis.tnk_alu_stk_successful =
                            newValue;
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
            // Death
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Death: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.thrombolysis.death,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.thrombolysis.death = newValue;
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
            // Referral
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Referral: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.thrombolysis.referral,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.thrombolysis.referral = newValue;
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
            // Reason for Referral
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reason for Referral: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: null,
                    initialValue: editedReport.thrombolysis.reason_for_referral,
                    onChanged: (newValue) => editedReport
                        .thrombolysis.reason_for_referral = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter reason for referral",
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
