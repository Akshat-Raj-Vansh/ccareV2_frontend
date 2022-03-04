//@dart=2.9
import 'dart:developer';

import 'package:ccarev2_frontend/main/domain/hubResponse.dart';
import 'package:ccarev2_frontend/main/domain/spokeResponse.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

import 'package:sizer/sizer.dart';

class ResponseScreen extends StatefulWidget {
  final MainCubit mainCubit;
  final UserType user;
  final PatientDetails patientDetails;

  const ResponseScreen(
      {Key key, this.mainCubit, this.user, this.patientDetails})
      : super(key: key);
  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  bool editReport = false;
  bool clickImage = false;
  String imagePath;
  MainState currentState;
  final List<Tab> _myTabs = [
    Tab(
      child: Text('Overview'),
    ),
    Tab(
      child: Text('ECG'),
    ),
    Tab(
      child: Text('Response'),
    ),
    Tab(
      child: Text('Response from Spoke'),
    ),
  ];
  bool noReport = true;
  int _currentIndex = 0;
  HubResponse hubResponse = HubResponse.initialize();
  SpokeResponse spokeResponse = SpokeResponse.initialize();
  bool previousReportExists = false;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: _myTabs.length);
    _tabController.addListener(_handleTabSelection);
    _fetchResponse();
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

  _fetchResponse() async {
    //print("Fetching patient report");
    widget.mainCubit.fetchResponse(widget.patientDetails.id);
    // widget.mainCubit.fetchImage(widget.patientDetails.id);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CubitConsumer<MainCubit, MainState>(
      cubit: widget.mainCubit,
      builder: (_, state) {
        print(state);
        if (state is ResponsesLoaded) {
          currentState = state;
          hubResponse = state.hubResponse;
          spokeResponse = state.spokeResponse;
          currentState = state;
        }

        if (state is NoResponseState) {
          print('No Response State Called');
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
        if (state is ResponsesLoaded) {
          hubResponse = state.hubResponse;
          spokeResponse = state.spokeResponse;
        }

        if (state is ResponseEdit) {
          editReport = true;
          log('LOG > patient_report_screen.dart > 222 > state: ${state.toString()}');
        }

        if (state is ResponseSaved) {
          log('LOG > patient_report_screen.dart > 239 > state: ${state.toString()}');
          _showMessage('Report Saved');
          editReport = false;
          widget.mainCubit.fetchResponse(widget.patientDetails.id);
        }
        if (state is HubResponseUpdated) {
          log('LOG > patient_report_screen.dart > 239 > state: ${state.toString()}');
          _showMessage('Report Saved');
          editReport = false;
          widget.mainCubit.fetchResponse(widget.patientDetails.id);
        }
        if (state is SpokeResponseUpdated) {
          log('LOG > patient_report_screen.dart > 239 > state: ${state.toString()}');
          _showMessage('Report Saved');
          editReport = false;
          widget.mainCubit.fetchResponse(widget.patientDetails.id);
        }
      },
    );
  }

  buildUI() {
    //print(widget.user);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Spoke & Hub'),
        backgroundColor: kPrimaryColor,
        actions: [
          if (_currentIndex != 0)
            editReport
                ? TextButton(
                    onPressed: () async {
                      widget.user == UserType.HUB
                          ? widget.mainCubit.updateHubResponse(
                              widget.patientDetails.id, hubResponse)
                          : widget.mainCubit.updateSpokeResponse(
                              widget.patientDetails.id, spokeResponse);
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
                      widget.mainCubit.editResponse();
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
              _fetchResponse();
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
      resizeToAvoidBottomInset: true,
      body:
          // noReport
          //     ? Center(child: Text('No Response Found'))
          //     :
          _buildFormBody(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          if (_currentIndex != 3)
            SpeedDialChild(
                label: 'Spoke Response',
                onTap: () {
                  _tabController.animateTo(3);
                }),
          if (_currentIndex != 2)
            SpeedDialChild(
                label: 'Advice',
                onTap: () {
                  _tabController.animateTo(2);
                }),
          if (_currentIndex != 1)
            SpeedDialChild(
                label: 'ECG',
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

  _buildDetailsBody(_currentReportDetails) => Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Current",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
          ),
          _currentReportDetails,
        ],
      );

  _buildFormBody() => TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
            child: _buildResponseOverview(),
          ),
          Container(
            child: editReport && widget.user == UserType.HUB
                ? _buildECGResponseForm()
                : _buildDetailsBody(
                    _buildECGResponseDetails(hubResponse.ecg),
                  ),
          ),
          Container(
            child: editReport && widget.user == UserType.HUB
                ? _buildAdviceForm()
                : _buildDetailsBody(
                    _buildAdviceDetails(hubResponse.advice),
                  ),
          ),
          Container(
            child: editReport && widget.user == UserType.SPOKE
                ? _buildSpokeRespForm()
                : _buildDetailsBody(
                    _buildSpokeRespDetails(spokeResponse),
                  ),
          ),
        ],
      );

  _buildResponseOverview() => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.h),
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "ECG",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
              ),
            ),
            _buildECGResponseDetails(hubResponse.ecg),

            // Medical History
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Advice",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
              ),
            ),
            _buildAdviceDetails(hubResponse.advice),

            // Chest Report
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Spoke Response",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
              ),
            ),
            _buildSpokeRespDetails(spokeResponse),
          ],
        ),
      );

  _buildECGResponseDetails(EcgInterperation ecgInterperation) => Container(
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
                Text('Rhythm'),
                Text(hubResponse.ecg.rythm.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 3.h),
            // Diabetic
            Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  'ST Segment Elevation',
                  style: TextStyle(color: kPrimaryColor, fontSize: 10.sp),
                ),
              ),
            ),

            SizedBox(height: 1.h),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Anterior Lead'),
                Text(
                  (hubResponse.ecg.st_elevation.anterior
                      .toString()
                      .split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Dyslipidaemia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lateral Lead'),
                Text(
                  (hubResponse.ecg.st_elevation.lateral
                      .toString()
                      .split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Dyslipidaemia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Inferior Lead'),
                Text(
                  (hubResponse.ecg.st_elevation.inferior
                      .toString()
                      .split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Dyslipidaemia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RV'),
                Text(
                  (hubResponse.ecg.st_elevation.rv.toString().split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Dyslipidaemia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Posterior'),
                Text(
                  (hubResponse.ecg.st_elevation.posterior
                      .toString()
                      .split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            // Diabetic
            Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  'ST Segment Depression',
                  style: TextStyle(color: kPrimaryColor, fontSize: 10.sp),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Inferior Lead'),
                Text(hubResponse.ecg.st_depression.inferior_lead
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lateral Lead'),
                Text(
                  (hubResponse.ecg.st_depression.lateral_lead
                      .toString()
                      .split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Dyslipidaemia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Anterior Lead'),
                Text(
                  (hubResponse.ecg.st_depression.anterior_lead
                      .toString()
                      .split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            // Diabetic
            Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  'T Wave Inversion',
                  style: TextStyle(color: kPrimaryColor, fontSize: 10.sp),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Inferior Leads'),
                Text(hubResponse.ecg.t_wave_inversion.inferior_lead
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lateral Leads'),
                Text(
                  (hubResponse.ecg.t_wave_inversion.lateral_lead
                      .toString()
                      .split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Dyslipidaemia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Anterior Leads'),
                Text(
                  (hubResponse.ecg.t_wave_inversion.anterior_lead
                      .toString()
                      .split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            // Diabetic
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bundle Branch Block'),
                Text(hubResponse.ecg.bbblock.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('LVH'),
                Text(
                  (hubResponse.ecg.lvh.toString().split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RVH'),
                Text(
                  (hubResponse.ecg.rvh.toString().split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RAE'),
                Text(
                  (hubResponse.ecg.rae.toString().split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('LAE'),
                Text(
                  (hubResponse.ecg.lae.toString().split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Diagnosis'),
                Text(
                  (hubResponse.ecg.diagnosis.toString().split('.')[1]),
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      );

  _buildAdviceDetails(Advice advice) => Container(
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
                Text('Repeat ECG After(mins)'),
                Text(advice.ecg_repeat),
              ],
            ),
            SizedBox(height: 1.h),
            // Diabetic
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Do Trop T/I Test'),
                Text(advice.trop_i_repeat.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 3.h),
            // Hypertensive
            Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  'Medicines',
                  style: TextStyle(color: kPrimaryColor, fontSize: 10.sp),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child:
                        Text('Thrombolyse after ruling out contraindications')),
                Text(advice.medicines.med1['value'].toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child:
                        Text('Give loading dose of Clopedogrel and Aspirin')),
                Text(advice.medicines.med2['value'].toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                      'Give Injection Enoxaparin 30 mg IV after 15 minutes of Thrombolytic therapy'),
                ),
                Text(advice.medicines.med3['value'].toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Metoprolol'),
                Text(advice.medicines.med4['value'].toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ramipril'),
                Text(advice.medicines.med5['value'].toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Dyslipidaemia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Telmisartan'),
                Text(advice.medicines.med6['value'].toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Dyslipidaemia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Atorvastatin'),
                Text(advice.medicines.med7['value'].toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 4.h),
            // Old MI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Oxygen inhalation'),
                Text(advice.oxygen_inhalation.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nebulization'),
                Text(advice.nebulization.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 3.h),
            // Hypertensive
            Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  'Do Blood biochemistry',
                  style: TextStyle(color: kPrimaryColor, fontSize: 10.sp),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sugar'),
                Text(advice.bioChemistry.sugar.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('BU/Creatinine'),
                Text(
                    advice.bioChemistry.bu_creatinine.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Electrolytes'),
                Text(advice.bioChemistry.electrolytes.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hemogram'),
                Text(advice.bioChemistry.hemogram.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      );

  _buildSpokeRespDetails(SpokeResponse spokeResponse) => Container(
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
                Text('Chest Pain'),
                Text(spokeResponse.chest_pain.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Onset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                        'ECG Changes of ST Segment elevation from baseline')),
                Text(spokeResponse.getSteString()),
              ],
            ),
            SizedBox(height: 1.h),
            // Onset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text('Other Remarks')),
                Text(spokeResponse.note == "" ? "None" : spokeResponse.note),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      );

  _buildECGResponseForm() => SingleChildScrollView(
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

              // Smoker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rhythm'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<Rythm>(
                      value: hubResponse.ecg.rythm,
                      isDense: false,
                      onChanged: (Rythm newValue) {
                        setState(() {
                          hubResponse.ecg.rythm = newValue;
                        });
                      },
                      items: Rythm.values.map((Rythm value) {
                        return DropdownMenuItem<Rythm>(
                          value: value,
                          child: Text(value.toString().split('.')[1]),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              // Diabetic
              Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'ST Segment Elevation',
                    style: TextStyle(color: kPrimaryColor, fontSize: 10.sp),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Anterior'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.st_elevation.anterior,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.st_elevation.anterior = newValue;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lateral'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.st_elevation.lateral,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.st_elevation.lateral = newValue;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Inferior'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.st_elevation.inferior,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.st_elevation.inferior = newValue;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('RV'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.st_elevation.rv,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.st_elevation.rv = newValue;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Posterior'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.st_elevation.posterior,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.st_elevation.posterior = newValue;
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
              SizedBox(height: 3.h),
              // Diabetic

              SizedBox(height: 3.h),
              // Diabetic

              Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'ST Segment Depression',
                    style: TextStyle(color: kPrimaryColor, fontSize: 10.sp),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lateral Leads'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.st_depression.lateral_lead,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.st_depression.lateral_lead = newValue;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Inferior Leads'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.st_depression.inferior_lead,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.st_depression.inferior_lead =
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
              ), // Hypertensive
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Anterior Leads'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.st_depression.anterior_lead,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.st_depression.anterior_lead =
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
              SizedBox(height: 3.h),
              // Diabetic

              Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'T Wave Inversion',
                    style: TextStyle(color: kPrimaryColor, fontSize: 10.sp),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lateral Leads'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.t_wave_inversion.lateral_lead,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.t_wave_inversion.lateral_lead =
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
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Inferior Leads'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.t_wave_inversion.inferior_lead,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.t_wave_inversion.inferior_lead =
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
              ), // Hypertensive
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Anterior Leads'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.t_wave_inversion.anterior_lead,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.t_wave_inversion.anterior_lead =
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
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bundle Branch Blocks'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<BBBlock>(
                      value: hubResponse.ecg.bbblock,
                      isDense: false,
                      onChanged: (BBBlock newValue) {
                        setState(() {
                          hubResponse.ecg.bbblock = newValue;
                        });
                      },
                      items: BBBlock.values.map((BBBlock value) {
                        return DropdownMenuItem<BBBlock>(
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
                  Text('LVH'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.lvh,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.lvh = newValue;
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
                  Text('RVH'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.rvh,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.rvh = newValue;
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
                  Text('RAE'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.rae,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.rae = newValue;
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
                  Text('LAE'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.ecg.lae,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.ecg.lae = newValue;
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
                  Text('Diagnosis'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<Diagonis>(
                      value: hubResponse.ecg.diagnosis,
                      isDense: false,
                      onChanged: (Diagonis newValue) {
                        setState(() {
                          hubResponse.ecg.diagnosis = newValue;
                        });
                      },
                      items: Diagonis.values.map((Diagonis value) {
                        return DropdownMenuItem<Diagonis>(
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
        ),
      );

  _buildAdviceForm() => SingleChildScrollView(
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

              // Smoker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Repeat ECG after (mins)'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      focusNode: null,
                      initialValue: hubResponse.advice.ecg_repeat,
                      onChanged: (newValue) =>
                          hubResponse.advice.ecg_repeat = newValue,
                      decoration: const InputDecoration(
                        hintText: "Enter duration in mins",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              // Diabetic
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Do Trop T/I test'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.advice.trop_i_repeat,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.advice.trop_i_repeat = newValue;
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
              SizedBox(height: 3.h),
              // Hypertensive

              Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Medicines',
                    style: TextStyle(color: kPrimaryColor, fontSize: 10.sp),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(
                          'Thrombolyse after ruling out contraindications')),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.advice.medicines.med1['value'] == 'yes'
                          ? YN.yes
                          : hubResponse.advice.medicines.med1['value'] == 'nill'
                              ? YN.nill
                              : YN.no,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.advice.medicines.med1['value'] =
                              newValue.toString().split('.')[1];
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
                  Flexible(
                      child:
                          Text('Give Loading dose of Clopedogrel and Aspirin')),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.advice.medicines.med2['value'] == 'yes'
                          ? YN.yes
                          : hubResponse.advice.medicines.med2['value'] == 'nill'
                              ? YN.nill
                              : YN.no,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.advice.medicines.med2['value'] =
                              newValue.toString().split('.')[1];
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                        'Give Injection Enoxaparin 30 mg IV after 15 minutes of Thrombolytic therapy'),
                  ),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.advice.medicines.med3['value'] == 'yes'
                          ? YN.yes
                          : hubResponse.advice.medicines.med3['value'] == 'nill'
                              ? YN.nill
                              : YN.no,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.advice.medicines.med3['value'] =
                              newValue.toString().split('.')[1];
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Metoprolol'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<MED4>(
                      value:
                          hubResponse.advice.medicines.med4Enum() ?? MED4.nill,
                      isDense: false,
                      onChanged: (MED4 newValue) {
                        setState(() {
                          hubResponse.advice.medicines.med4['value'] =
                              newValue.toString().split('.')[1];
                        });
                      },
                      items: MED4.values.map((MED4 value) {
                        return DropdownMenuItem<MED4>(
                          value: value,
                          child: Text(
                            MedicineAdvice.med4Map[value] ?? "nill",
                            style: TextStyle(fontSize: 8.sp),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ramipril'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<MED5>(
                      value:
                          hubResponse.advice.medicines.med5Enum() ?? MED5.nill,
                      isDense: false,
                      onChanged: (MED5 newValue) {
                        setState(() {
                          hubResponse.advice.medicines.med5['value'] =
                              newValue.toString().split('.')[1];
                        });
                      },
                      items: MED5.values.map((MED5 value) {
                        return DropdownMenuItem<MED5>(
                          value: value,
                          child: Text(
                            MedicineAdvice.med5Map[value] ?? "nill",
                            style: TextStyle(fontSize: 8.sp),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Telmisartan'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<MED6>(
                      value:
                          hubResponse.advice.medicines.med6Enum() ?? MED6.nill,
                      isDense: false,
                      onChanged: (MED6 newValue) {
                        setState(() {
                          hubResponse.advice.medicines.med6['value'] =
                              newValue.toString().split('.')[1];
                        });
                      },
                      items: MED6.values.map((MED6 value) {
                        return DropdownMenuItem<MED6>(
                          value: value,
                          child: Text(
                            MedicineAdvice.med6Map[value] ?? "nill",
                            style: TextStyle(fontSize: 8.sp),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Atorvastatin'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<MED7>(
                      value:
                          hubResponse.advice.medicines.med7Enum() ?? MED7.nill,
                      isDense: false,
                      onChanged: (MED7 newValue) {
                        setState(() {
                          hubResponse.advice.medicines.med7['value'] =
                              newValue.toString().split('.')[1];
                        });
                      },
                      items: MED7.values.map((MED7 value) {
                        return DropdownMenuItem<MED7>(
                          value: value,
                          child: Text(
                            MedicineAdvice.med7Map[value] ?? "nill",
                            style: TextStyle(fontSize: 8.sp),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Oxygen Inhalation'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.advice.oxygen_inhalation,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.advice.oxygen_inhalation = newValue;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nebulization'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.advice.nebulization,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.advice.nebulization = newValue;
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

              SizedBox(height: 3.h),
              // Hypertensive

              Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Do Blood biochemistry',
                    style: TextStyle(color: kPrimaryColor, fontSize: 10.sp),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sugar'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.advice.bioChemistry.sugar,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.advice.bioChemistry.sugar = newValue;
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
                  Text('BU/Creatinine'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.advice.bioChemistry.bu_creatinine,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.advice.bioChemistry.bu_creatinine =
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
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Electrolytes'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.advice.bioChemistry.electrolytes,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.advice.bioChemistry.electrolytes =
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
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hemogram'),
                  Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: DropdownButton<YN>(
                      value: hubResponse.advice.bioChemistry.hemogram,
                      isDense: false,
                      onChanged: (YN newValue) {
                        setState(() {
                          hubResponse.advice.bioChemistry.hemogram = newValue;
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
            ],
          ),
        ),
      );

  _buildSpokeRespForm() => SingleChildScrollView(
        child: Container(
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
              // Chest Pain
              Text('Chest Pain'),

              SizedBox(height: 1.h),
              Container(
                child: DropdownButton<ChestP>(
                  value: spokeResponse.chest_pain,
                  isDense: false,
                  onChanged: (ChestP newValue) {
                    setState(() {
                      spokeResponse.chest_pain = newValue;
                    });
                  },
                  items: ChestP.values.map((ChestP value) {
                    return DropdownMenuItem<ChestP>(
                      value: value,
                      child: Text(
                        SpokeResponse.chestMapping[value],
                        // style: TextStyle(fontSize: 8.sp),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 1.h),
              // Site
              Text('ECG Changes of ST Segment elevation from baseline'),

              SizedBox(height: 1.h),
              Container(
                child: DropdownButton<STE>(
                  value: spokeResponse.st_elevation,
                  isDense: false,
                  onChanged: (STE newValue) {
                    setState(() {
                      spokeResponse.st_elevation = newValue;
                    });
                  },
                  items: STE.values.map((STE value) {
                    return DropdownMenuItem<STE>(
                      value: value,
                      child: Text(
                        SpokeResponse.steMapping[value],
                        // style: TextStyle(fontSize: 8.sp),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 1.h),
              // Location
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('Repeat ECG after: '),
              //     Container(R
              //       width: SizeConfig.screenWidth * 0.4,
              //       child: TextFormField(
              //         keyboardType: TextInputType.number,
              //         focusNode: null,
              //         initialValue: hubResponse.advice.ecg_repeat,
              //         onChanged: (newValue) =>
              //             hubResponse.advice.ecg_repeat = newValue,
              //         decoration: const InputDecoration(
              //           hintText: "Enter duration in mins",
              //           floatingLabelBehavior: FloatingLabelBehavior.always,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      );
}
