//@dart=2.9
import 'dart:developer';

import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart' as exam;
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
  // ScrollController scrollView;
  // ScrollView scrollView;
  FocusNode focusNode;
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
    focusNode = FocusNode();
    // scrollView=ScrollController();
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
            .copyWith(color: Colors.white, fontSize: 12.sp),
      ),
    ));
  }

  _fetchReport() async {
    print("Fetching patient exam report");
    print(widget.patientDetails == null ? '' : widget.patientDetails.id);
    await widget.mainCubit.fetchPatientExamReport(
        widget.patientDetails == null ? '' : widget.patientDetails.id);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CubitConsumer<MainCubit, MainState>(
      cubit: widget.mainCubit,
      builder: (_, state) {
        print("PatientExamScreen builder state: $state");
        if (state is PatientExamReportFetched) {
          log('LOG > patient_exam_screen.dart > 112 > state: ${state.toString()}');
          editedReport = state.ereport;
          //print('DATA > patient_exam_screen.dart > 113 > state: ${state}');
          //print(editedReport);
          log('LOG > patient_exam_screen.dart > 116 > editedReport: ${editedReport}');
          noReport = false;
          //print(widget.patientDetails.toString());
          //  // _hideLoader();
        }
        if (state is NoReportState) {
          noReport = true;
          log('DATA > patient_exam_screen.dart > FUNCTION_NAME > 122 > state.msg: ${state.msg}');
        }
        return buildUI();
      },
      listener: (context, state) {
        print(
            "PatientExamScreen > build > listener > state: ${state.toString()}");
        if (state is PatientExamReportFetched) {
          log('LOG > patient_exam_screen.dart > 112 > state: ${state.toString()}');
          editedReport = state.ereport;
          log('LOG > patient_exam_screen.dart > 116 > editedReport: ${editedReport}');
          noReport = false;
          //print(widget.patientDetails.toString());
          //  // _hideLoader();
        }
        if (state is EditPatientExamReport) {
          log('LOG > patient_exam_screen.dart > 121 > state: ${state.toString()}');
          //   // _hideLoader();
          editReport = true;
        }
        if (state is ViewPatientExamReport) {
          log('LOG > patient_exam_screen.dart > 126 > state: ${state.toString()}');
          //     // _hideLoader();
          editReport = false;
          //  widget.mainCubit.fetchPatientReport();
        }
        if (state is PatientExamReportSaved) {
          log('LOG > patient_exam_screen.dart > 131 > state: ${state.toString()}');
          //print(state.msg);
          //     // _hideLoader();
          _showMessage('Report Saved');
          editReport = false;
          //widget.mainCubit.fetchPatientExamReport();
        }
        if (state is NoReportState) {
          log('LOG > patient_exam_screen.dart > 140 > state: ${state.toString()}');
          //print('No Report State Called');
//// _hideLoader();
          noReport = true;
        }
      },
    );
  }

  buildUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Examination Form'),
        backgroundColor: kPrimaryColor,
        actions: [
          if (_currentIndex != 0 && !noReport && widget.user == UserType.SPOKE)
            editReport
                ? TextButton(
                    onPressed: () async {
                      print('before saving');
                      print(editedReport.toString());
                      widget.mainCubit.savePatientExamReport(
                          editedReport, widget.patientDetails.id);
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
      body: noReport && widget.user == UserType.PATIENT
          ? Center(child: Text('No Report Found'))
          : _buildFormBody(),
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
            //  _buildPatientDetails(),

            // Report Edit details
            // _buildEditDetails(),

            SizedBox(height: 2.h),

            // Patient Medical Report
            // Normal Treatment
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Normal Treatment Report",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
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
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
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
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Contact Number: "),
                Text(widget.patientDetails.contactNumber,
                    textAlign: TextAlign.right),
              ],
            ),
            // SizedBox(
            //   height: 1.h,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text("Address: "),
            //     Text(widget.patientDetails.address, textAlign: TextAlign.right),
            //   ],
            // ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Arrived At Hospital: "),
                Text(DateTime.now().toString(), textAlign: TextAlign.right),
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
                Text(DateTime.now().toString()),
              ],
            ),
            SizedBox(
              height: 1.h,
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
            SizedBox(height: 2.h),
            // Aspirin–Loading dose (300 mg)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Aspirin–Loading dose (300 mg) : '),
                Text(editedReport.nTreatment.aspirin_loading
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // SPT Loading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Clopidogrel Loading(300 mg) : '),
                Text(editedReport.nTreatment.c_p_t_loading
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            //  LMWH(Enoxaparin)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('LMWH(Enoxaparin): '),
                Text(editedReport.nTreatment.lmwh.toString().split('.')[1]),
              ],
            ),
            editedReport.nTreatment.lmwh == YN.yes
                ? Container(
                    margin: EdgeInsets.only(top: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('IV bolus of 30mg given: '),
                        Text(editedReport.nTreatment.ivbolus
                            .toString()
                            .split('.')[1]),
                      ],
                    ),
                  )
                : SizedBox(),
            editedReport.nTreatment.lmwh == YN.yes
                ? Container(
                    margin: EdgeInsets.only(top: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'InJ.Enoxaparin(1mg/kg)\nscub cutaneously given:',
                        ),
                        Text(editedReport.nTreatment.ivbolus
                            .toString()
                            .split('.')[1]),
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 1.h),
            // Statins
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Statins: '),
                Text(editedReport.nTreatment.statins.toString().split('.')[1]),
              ],
            ),
            (editedReport.nTreatment.statins != Statins.NotGiven &&
                    editedReport.nTreatment.statins != Statins.nill)
                ?
                // Statins
                Container(
                    margin: EdgeInsets.only(top: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Statins Dose: '),
                        Text(editedReport.nTreatment.statins_dose),
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 1.h),
            // Beta_Blockers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Beta Blockers: '),
                Text(editedReport.nTreatment.beta_blockers
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Nitrates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nitrates: '),
                Text(editedReport.nTreatment.nitrates.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Deuretics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Deuretics: '),
                Text(
                    editedReport.nTreatment.diuretics.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // ACEI ARD
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ACEI/ARB: '),
                Text(editedReport.nTreatment.acei_arb.toString().split('.')[1]),
              ],
            ),

            SizedBox(height: 3.h),
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
            SizedBox(height: 2.h),
            // TNK ALU STK Successful
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Thrombolysis '),
                Text(editedReport.thrombolysis.thrombolysis
                    .toString()
                    .split('.')[1]),
              ],
            ),
            editedReport.thrombolysis.thrombolysis == YN.yes
                ? Container(
                    margin: EdgeInsets.only(top: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TNK/STK/Retiplase '),
                        Text(editedReport.thrombolysis.tnk_stk_ret
                            .toString()
                            .split('.')[1]),
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 1.h),
            // Death
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Death: '),
                Text(editedReport.thrombolysis.death.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
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
            editedReport.thrombolysis.referral == YN.yes
                ? Container(
                    margin: EdgeInsets.only(top: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Reason for Referral: '),
                        Text(editedReport.thrombolysis.reason_for_referral),
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 1.h),
            // Reason for Referral
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discharged: '),
                Text(editedReport.thrombolysis.discharged
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      );

  _buildNTreatmentForm() => SingleChildScrollView(
        child: Container(
          width: SizeConfig.screenWidth,
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 0,
            // bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              // Aspirin–Loading dose (300 mg)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Aspirin–Loading : \ndose (300 mg) '),
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
              SizedBox(height: 1.h),
              // Clopidogrel Loading(300 mg)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Clopidogrel Loading:\n(300 mg)  '),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: editedReport.nTreatment.c_p_t_loading,
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
              SizedBox(height: 1.h),
              // LMWH(Enoxaparin)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('LMWH(Enoxaparin): '),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: editedReport.nTreatment.lmwh,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          editedReport.nTreatment.lmwh = newValue;
                        });
                      },
                      items: YN.values.map((YN value) {
                        return DropdownMenuItem<YN>(
                          value: value,
                          child: Text(value.toString().split('.')[1]),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              editedReport.nTreatment.lmwh == YN.yes
                  ? Container(
                      margin: EdgeInsets.only(top: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('IVBolus :\n30mg given '),
                          Container(
                            width: SizeConfig.screenWidth * 0.4,
                            child: DropdownButton<YN>(
                              value: editedReport.nTreatment.ivbolus,
                              isDense: false,
                              onChanged: (YN newValue) {
                                setState(() {
                                  editedReport.nTreatment.ivbolus = newValue;
                                });
                              },
                              items: YN.values.map((YN value) {
                                return DropdownMenuItem<YN>(
                                  value: value,
                                  child: Text(value.toString().split('.')[1]),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    )
                  : SizedBox(),
              // Statins
              editedReport.nTreatment.lmwh == YN.yes
                  ? Container(
                      margin: EdgeInsets.only(top: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'InJ. Enoxaparin (1mg/kg) \nscub cutaneously given:',
                            style: TextStyle(fontSize: 10.sp),
                          ),
                          Container(
                            width: SizeConfig.screenWidth * 0.4,
                            child: DropdownButton<YN>(
                              value: editedReport.nTreatment.inj_eno,
                              isDense: false,
                              onChanged: (YN newValue) {
                                setState(() {
                                  editedReport.nTreatment.inj_eno = newValue;
                                });
                              },
                              items: YN.values.map((YN value) {
                                return DropdownMenuItem<YN>(
                                  value: value,
                                  child: Text(value.toString().split('.')[1]),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Statins: '),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<Statins>(
                      value: editedReport.nTreatment.statins,
                      isDense: false,
                      onChanged: (Statins newValue) {
                        setState(() {
                          editedReport.nTreatment.statins = newValue;
                        });
                      },
                      items: Statins.values.map((Statins value) {
                        return DropdownMenuItem<Statins>(
                          value: value,
                          child: Text(value.toString().split('.')[1]),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),

              (editedReport.nTreatment.statins != Statins.NotGiven &&
                      editedReport.nTreatment.statins != Statins.nill)
                  ? Container(
                      margin: EdgeInsets.only(top: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Statins Dose: '),
                          Container(
                            width: SizeConfig.screenWidth * 0.4,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              focusNode: focusNode,
                              onSaved: (newValue) => focusNode.unfocus(),
                              initialValue:
                                  editedReport.nTreatment.statins_dose,
                              onChanged: (newValue) => editedReport.nTreatment
                                  .statins_dose = newValue.toString(),
                              decoration: const InputDecoration(
                                hintText: "Enter Statins Dose",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 1.h),
              // Beta Blockers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Beta Blockers: '),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: editedReport.nTreatment.beta_blockers,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          editedReport.nTreatment.beta_blockers = newValue;
                        });
                      },
                      items: YN.values.map((YN value) {
                        return DropdownMenuItem<YN>(
                          value: value,
                          child: Text(value.toString().split('.')[1]),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h),
              // Nitrates
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nitrates: '),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: editedReport.nTreatment.nitrates,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          editedReport.nTreatment.nitrates = newValue;
                        });
                      },
                      items: YN.values.map((YN value) {
                        return DropdownMenuItem<YN>(
                          value: value,
                          child: Text(value.toString().split('.')[1]),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h),
              // Deuretics
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Diuretics: '),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: editedReport.nTreatment.diuretics,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          editedReport.nTreatment.diuretics = newValue;
                        });
                      },
                      items: YN.values.map((YN value) {
                        return DropdownMenuItem<YN>(
                          value: value,
                          child: Text(value.toString().split('.')[1]),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h),
              // ACEI ARB
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ACEI/ARB: '),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: editedReport.nTreatment.acei_arb,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          editedReport.nTreatment.acei_arb = newValue;
                        });
                      },
                      items: YN.values.map((YN value) {
                        return DropdownMenuItem<YN>(
                          value: value,
                          child: Text(value.toString().split('.')[1]),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );

  _buildThrombolysisForm() => Container(
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 0,
          // bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            // TNK ALU STK Successful
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Thrombolysis: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.thrombolysis.thrombolysis,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.thrombolysis.thrombolysis = newValue;
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
            editedReport.thrombolysis.thrombolysis == YN.yes
                ? Container(
                    margin: EdgeInsets.only(top: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TNK/STL/Retiplase: '),
                        Container(
                          width: SizeConfig.screenWidth * 0.4,
                          child: DropdownButton<YN>(
                            value: editedReport.thrombolysis.tnk_stk_ret,
                            isDense: false,
                            onChanged: (YN newValue) {
                              setState(() {
                                editedReport.thrombolysis.tnk_stk_ret =
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
                  )
                : SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
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

            editedReport.thrombolysis.referral == YN.yes
                ? Container(
                    margin: EdgeInsets.only(top: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Reason for Referral: '),
                        Container(
                          width: SizeConfig.screenWidth * 0.4,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            focusNode: null,
                            initialValue:
                                editedReport.thrombolysis.reason_for_referral,
                            onChanged: (newValue) => editedReport
                                .thrombolysis.reason_for_referral = newValue,
                            decoration: const InputDecoration(
                              hintText: "Enter reason for referral",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 1.h),
            // Referral
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discharged: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DropdownButton<YN>(
                    value: editedReport.thrombolysis.discharged,
                    isDense: false,
                    onChanged: (YN newValue) {
                      setState(() {
                        editedReport.thrombolysis.discharged = newValue;
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
}
