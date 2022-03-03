// //@dart=2.9
// import 'dart:developer';
// import 'dart:io';

// import 'package:ccarev2_frontend/main/domain/hubResponse.dart';
// import 'package:ccarev2_frontend/main/domain/spokeResponse.dart';
// import 'package:ccarev2_frontend/utils/constants.dart';
// import 'package:ccarev2_frontend/main/domain/edetails.dart';
// import 'package:ccarev2_frontend/pages/home/components/fullImage.dart';
// import 'package:ccarev2_frontend/utils/size_config.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ccarev2_frontend/main/domain/treatment.dart';
// import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
// import 'package:ccarev2_frontend/state_management/main/main_state.dart';
// import 'package:ccarev2_frontend/user/domain/credential.dart';
// import 'package:ccarev2_frontend/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:flutter_cubit/flutter_cubit.dart';

// import 'package:sizer/sizer.dart';

// class ResponseScreen extends StatefulWidget {
//   final MainCubit mainCubit;
//   final UserType user;
//   final PatientDetails patientDetails;

//   const ResponseScreen(
//       {Key key, this.mainCubit, this.user, this.patientDetails})
//       : super(key: key);
//   @override
//   _ResponseScreenState createState() => _ResponseScreenState();
// }

// class _ResponseScreenState extends State<ResponseScreen>
//     with TickerProviderStateMixin {
//   TabController _tabController;
//   bool editReport = false;
//   bool clickImage = false;
//   String imagePath;
//   MainState currentState;
//   final List<Tab> _myTabs = [
//     Tab(
//       child: Text('Overview'),
//     ),
//     Tab(
//       child: Text('ECG'),
//     ),
//     Tab(
//       child: Text('Response'),
//     ),
//     Tab(
//       child: Text('Advice from Spoke'),
//     ),
//   ];
//   bool noReport = true;
//   int _currentIndex = 0;
//   HubResponse hubResponse = HubResponse.initialize();
//   SpokeResponse spokeResponse = SpokeResponse.initialize();
//   bool previousReportExists = false;
//   @override
//   void initState() {
//     super.initState();
//     _tabController = new TabController(vsync: this, length: _myTabs.length);
//     _tabController.addListener(_handleTabSelection);
//     _fetchResponse();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   _handleTabSelection() {
//     setState(() {
//       _currentIndex = _tabController.index;
//     });
//   }

//   _showLoader() {
//     var alert = const AlertDialog(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       content: Center(
//           child: CircularProgressIndicator(
//         backgroundColor: Colors.green,
//       )),
//     );

//     showDialog(
//         context: context, barrierDismissible: true, builder: (_) => alert);
//   }

//   _hideLoader() {
//     Navigator.of(context, rootNavigator: true).pop();
//   }

//   _showMessage(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       backgroundColor: Theme.of(context).accentColor,
//       content: Text(
//         msg,
//         style: Theme.of(context)
//             .textTheme
//             .caption
//             .copyWith(color: Colors.white, fontSize: 12.sp),
//       ),
//     ));
//   }

//   _fetchResponse() async {
//     //print("Fetching patient report");
//     widget.mainCubit.fetchPatientReport(
//         widget.patientDetails == null ? '' : widget.patientDetails.id);
//     // widget.mainCubit.fetchImage(widget.patientDetails.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return CubitConsumer<MainCubit, MainState>(
//       cubit: widget.mainCubit,
//       builder: (_, state) {
//         if (state is ResponsesLoaded) {
//           hubResponse = state.hubResponse;
//           spokeResponse = state.spokeResponse;
//         }

//         if (state is NoReportState) {
//           //print('No Report State Called');
//           log('LOG > patient_report_screen.dart > 201 > state: ${state.toString()}');
//           currentState = state;
//           noReport = true;
//           editReport = false;
//         }
//         if (currentState == null) {
//           return Container(
//             width: double.infinity,
//             height: double.infinity,
//             color: Colors.white,
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }

//         return buildUI();
//       },
//       listener: (context, state) {
//         if (state is HubResponseUpdated) {
//           // hub response updated
//         }

//         if (state is EditPatientReport) {
//           // _hideLoader();
//           editReport = true;
//           log('LOG > patient_report_screen.dart > 222 > state: ${state.toString()}');
//         }
//         if (state is ViewPatientReport) {
//           // _hideLoader();
//           editReport = false;
//           log('LOG > patient_report_screen.dart > 227 > state: ${state.toString()}');
//           //  widget.mainCubit.fetchPatientReport();
//         }
//         if (state is PatientReportSaved) {
//           //print("Patient Report Saved state Called");
//           //print(state.msg);
//           log('LOG > patient_report_screen.dart > 239 > state: ${state.toString()}');
//           // _hideLoader();
//           _showMessage('Report Saved');
//           editReport = false;
//           widget.mainCubit.fetchPatientReport(widget.patientDetails.id);
//         }
//       },
//     );
//   }

//   buildUI() {
//     //print(widget.user);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('Spoke & Hub Consultation'),
//         backgroundColor: kPrimaryColor,
//         actions: [
//           if (_currentIndex != 0 && widget.user == UserType.HUB)
//             editReport
//                 ? TextButton(
//                     onPressed: () async {
//                       widget.mainCubit.updateHubResponse(
//                           widget.patientDetails.id, hubResponse);
//                     },
//                     child: Text(
//                       'SAVE',
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                   )
//                 : TextButton(
//                     onPressed: () async {
//                       //print('Edit Report Button Pressed');
//                       // widget.mainCubit.editPatientReport();
//                     },
//                     child: Text(
//                       'EDIT',
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//           IconButton(
//             onPressed: () async {
//               //print('Refresh button pressed');
//               _fetchResponse();
//             },
//             icon: Icon(Icons.refresh),
//           ),
//         ],
//         bottom: TabBar(
//           isScrollable: true,
//           unselectedLabelColor: Colors.white.withOpacity(0.3),
//           indicatorColor: Colors.white,
//           controller: _tabController,
//           tabs: _myTabs,
//         ),
//       ),
//       resizeToAvoidBottomInset: true,
//       body: noReport && widget.user == UserType.PATIENT
//           ? Center(child: Text('No Response Found'))
//           : _buildFormBody(),
//       floatingActionButton: SpeedDial(
//         animatedIcon: AnimatedIcons.menu_close,
//         children: [
//           if (_currentIndex != 3)
//             SpeedDialChild(
//                 label: 'Spoke Response',
//                 onTap: () {
//                   _tabController.animateTo(3);
//                 }),
//           if (_currentIndex != 2)
//             SpeedDialChild(
//                 label: 'Advice',
//                 onTap: () {
//                   _tabController.animateTo(2);
//                 }),
//           if (_currentIndex != 1)
//             SpeedDialChild(
//                 label: 'ECG',
//                 onTap: () {
//                   _tabController.animateTo(1);
//                 }),
//           if (_currentIndex != 0)
//             SpeedDialChild(
//                 label: 'Overview',
//                 onTap: () {
//                   _tabController.animateTo(0);
//                 }),
//         ],
//       ),
//     );
//   }

//   _buildDetailsBody(_currentReportDetails) => Column(
//         children: [
//           SizedBox(
//             height: 20,
//           ),
//           Text(
//             "Current Report",
//             textAlign: TextAlign.left,
//             style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
//           ),
//           _currentReportDetails,
//         ],
//       );

//   _buildFormBody() => TabBarView(
//         controller: _tabController,
//         children: <Widget>[
//           Container(
//             child: _buildResponseOverview(),
//           ),
//           Container(
//             child: editReport
//                 ? _buildECGResponseForm()
//                 : _buildDetailsBody(
//                     _buildECGResponseDetails(hubResponse.ecg),
//                   ),
//           ),
//           Container(
//             child: editReport
//                 ? _buildAdviceForm()
//                 : _buildDetailsBody(
//                     _buildAdviceDetails(hubResponse.advice),
//                   ),
//           ),
//           Container(
//             child: editReport
//                 ? _buildSpokeRespForm()
//                 : _buildDetailsBody(
//                     _buildSpokeRespDetails(spokeResponse),
//                   ),
//           ),
//         ],
//       );

//   _buildResponseOverview() => SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 2.h),
//             Container(
//               width: SizeConfig.screenWidth,
//               margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//               child: Text(
//                 "ECG",
//                 textAlign: TextAlign.left,
//                 style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
//               ),
//             ),
//             _buildECGResponseDetails(hubResponse.ecg),

//             // Medical History
//             Container(
//               width: SizeConfig.screenWidth,
//               margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//               child: Text(
//                 "Advice",
//                 textAlign: TextAlign.left,
//                 style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
//               ),
//             ),
//             _buildAdviceDetails(hubResponse.advice),

//             // Chest Report
//             Container(
//               width: SizeConfig.screenWidth,
//               margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//               child: Text(
//                 "Spoke Response",
//                 textAlign: TextAlign.left,
//                 style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
//               ),
//             ),
//             _buildSpokeRespDetails(spokeResponse),
//           ],
//         ),
//       );

//   _buildECGResponseDetails(EcgInterperation ecgInterperation) => Container(
//         width: SizeConfig.screenWidth,
//         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 2.h),
//             // Smoker
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Rhythm: '),
//                 Text(hubResponse.ecg.rythm.toString().split('.')[1]),
//               ],
//             ),
//             SizedBox(height: 2.h),
//             // Diabetic
//             Text('ST Segment Elevation: '),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Inferior Lead: '),
//                 Text(hubResponse.ecg.st_elevation.inferior
//                     .toString()
//                     .split('.')[1]),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Hypertensive
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Anterior: '),
//                 Text(
//                   (hubResponse.ecg.st_elevation.anterior
//                       .toString()
//                       .split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Dyslipidaemia
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Lateral: '),
//                 Text(
//                   (hubResponse.ecg.st_elevation.lateral
//                       .toString()
//                       .split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Dyslipidaemia
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Inferior: '),
//                 Text(
//                   (hubResponse.ecg.st_elevation.inferior
//                       .toString()
//                       .split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Dyslipidaemia
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('RV: '),
//                 Text(
//                   (hubResponse.ecg.st_elevation.rv.toString().split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Dyslipidaemia
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Posterior: '),
//                 Text(
//                   (hubResponse.ecg.st_elevation.posterior
//                       .toString()
//                       .split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 2.h),
//             // Diabetic
//             Text('ST Segment Depression: '),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Inferior Lead: '),
//                 Text(hubResponse.ecg.st_depression.inferior_lead
//                     .toString()
//                     .split('.')[1]),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Hypertensive
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Lateral Lead: '),
//                 Text(
//                   (hubResponse.ecg.st_depression.lateral_lead
//                       .toString()
//                       .split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Dyslipidaemia
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Anterior Lead: '),
//                 Text(
//                   (hubResponse.ecg.st_depression.anterior_lead
//                       .toString()
//                       .split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 2.h),
//             // Diabetic
//             Text('T Wave Inversion: '),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Inferior Leads: '),
//                 Text(hubResponse.ecg.t_wave_inversion.inferior_lead
//                     .toString()
//                     .split('.')[1]),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Hypertensive
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Lateral Leads: '),
//                 Text(
//                   (hubResponse.ecg.t_wave_inversion.lateral_lead
//                       .toString()
//                       .split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Dyslipidaemia
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Anterior Leads: '),
//                 Text(
//                   (hubResponse.ecg.t_wave_inversion.anterior_lead
//                       .toString()
//                       .split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 2.h),
//             // Diabetic
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Bundle Branch Block: '),
//                 Text(hubResponse.ecg.bbBlock.toString().split('.')[1]),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Hypertensive
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('LVH: '),
//                 Text(
//                   (hubResponse.ecg.lvh.toString().split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Hypertensive
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('RVH: '),
//                 Text(
//                   (hubResponse.ecg.rvh.toString().split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Hypertensive
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('RAE: '),
//                 Text(
//                   (hubResponse.ecg.rae.toString().split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Hypertensive
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('LAE: '),
//                 Text(
//                   (hubResponse.ecg.lae.toString().split('.')[1]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 3.h),
//           ],
//         ),
//       );

//   _buildAdviceDetails(Advice advice) => Container(
//         width: SizeConfig.screenWidth,
//         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 2.h),
//             // Smoker
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Repeat ECG After : '),
//                 Text(advice.ecg_repeat),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Diabetic
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Do Trop T/I Test: '),
//                 Text(advice.trop_i_repeat.toString().split('.')[1]),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Hypertensive
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Medicines: '),
//                 Text("treatmentR)[1]"),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Dyslipidaemia
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Oxygen Inhalation: '),
//                 Text(advice.oxygen_inhalation.toString().split('.')[1]),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Old MI
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Nebulization: '),
//                 Text(advice.nebulization.toString().split('.')[1]),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Trop I
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Do Blood BioChemistry: '),
//                 Text("healthR)[1]"),
//               ],
//             ),
//             SizedBox(height: 3.h),
//           ],
//         ),
//       );

//   _buildSpokeRespDetails(SpokeResponse spokeResponse) => Container(
//         width: SizeConfig.screenWidth,
//         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 2.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Chest Pain: '),
//                 Text(treatmentReport.chestReport.chest_pain
//                     .toString()
//                     .split('.')[1]),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Onset
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Site: '),
//                 Text(treatmentReport.chestReport.site.toString().split('.')[1]),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Pain Location
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Location: '),
//                 Text(treatmentReport.chestReport.location
//                     .toString()
//                     .split('.')[1]),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Intensity
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//               Text('Intensity: '),
//               Text(treatmentReport.chestReport.intensity
//                   .toString()
//                   .split('.')[1]),
//             ]),
//             SizedBox(height: 1.h),
//             // Severity
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//               Text('Severity: '),
//               Text(treatmentReport.chestReport.severity
//                   .toString()
//                   .split('.')[1]),
//             ]),
//             SizedBox(height: 1.h),
//             // Radiation
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Radiation: '),
//                 Text(treatmentReport.chestReport.radiation
//                     .toString()
//                     .split('.')[1]),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Duration
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Duration: '),
//                 Text(treatmentReport.chestReport.duration),
//               ],
//             ),
//             SizedBox(height: 3.h),
//           ],
//         ),
//       );

//   _buildECGResponseForm() => Container(
//         width: SizeConfig.screenWidth,
//         margin: EdgeInsets.only(
//           left: 20,
//           right: 20,
//           top: 0,
//           // bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 2.h),

//             // Smoker
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Smoker: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<YN>(
//                     value: editedReport.medicalHist.smoker,
//                     isDense: false,
//                     onChanged: (YN newValue) {
//                       setState(() {
//                         editedReport.medicalHist.smoker = newValue;
//                       });
//                     },
//                     items: YN.values.map((YN value) {
//                       return DropdownMenuItem<YN>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Diabetic
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Diabetic: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<YN>(
//                     value: editedReport.medicalHist.diabetic,
//                     isDense: false,
//                     onChanged: (YN newValue) {
//                       setState(() {
//                         editedReport.medicalHist.diabetic = newValue;
//                       });
//                     },
//                     items: YN.values.map((YN value) {
//                       return DropdownMenuItem<YN>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Hypertensive
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Hypertensive: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<YN>(
//                     value: editedReport.medicalHist.hypertensive,
//                     isDense: false,
//                     onChanged: (YN newValue) {
//                       setState(() {
//                         editedReport.medicalHist.hypertensive = newValue;
//                       });
//                     },
//                     items: YN.values.map((YN value) {
//                       return DropdownMenuItem<YN>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Dyslipidaemia
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Dyslipidaemia: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<YN>(
//                     value: editedReport.medicalHist.dyslipidaemia,
//                     isDense: false,
//                     onChanged: (YN newValue) {
//                       setState(() {
//                         editedReport.medicalHist.dyslipidaemia = newValue;
//                       });
//                     },
//                     items: YN.values.map((YN value) {
//                       return DropdownMenuItem<YN>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Old MI
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Old MI: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<YN>(
//                     value: editedReport.medicalHist.old_mi,
//                     isDense: false,
//                     onChanged: (YN newValue) {
//                       setState(() {
//                         editedReport.medicalHist.old_mi = newValue;
//                       });
//                     },
//                     items: YN.values.map((YN value) {
//                       return DropdownMenuItem<YN>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Trop I
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Trop I: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<PN>(
//                     value: editedReport.medicalHist.trop_i,
//                     isDense: false,
//                     onChanged: (PN newValue) {
//                       setState(() {
//                         editedReport.medicalHist.trop_i = newValue;
//                       });
//                     },
//                     items: PN.values.map((PN value) {
//                       return DropdownMenuItem<PN>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );

//   _buildAdviceForm() => Container(
//         width: SizeConfig.screenWidth,
//         margin: EdgeInsets.only(
//           left: 20,
//           right: 20,
//           top: 0,
//           // bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 2.h),

//             // Smoker
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Smoker: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<YN>(
//                     value: editedReport.medicalHist.smoker,
//                     isDense: false,
//                     onChanged: (YN newValue) {
//                       setState(() {
//                         editedReport.medicalHist.smoker = newValue;
//                       });
//                     },
//                     items: YN.values.map((YN value) {
//                       return DropdownMenuItem<YN>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Diabetic
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Diabetic: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<YN>(
//                     value: editedReport.medicalHist.diabetic,
//                     isDense: false,
//                     onChanged: (YN newValue) {
//                       setState(() {
//                         editedReport.medicalHist.diabetic = newValue;
//                       });
//                     },
//                     items: YN.values.map((YN value) {
//                       return DropdownMenuItem<YN>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Hypertensive
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Hypertensive: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<YN>(
//                     value: editedReport.medicalHist.hypertensive,
//                     isDense: false,
//                     onChanged: (YN newValue) {
//                       setState(() {
//                         editedReport.medicalHist.hypertensive = newValue;
//                       });
//                     },
//                     items: YN.values.map((YN value) {
//                       return DropdownMenuItem<YN>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Dyslipidaemia
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Dyslipidaemia: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<YN>(
//                     value: editedReport.medicalHist.dyslipidaemia,
//                     isDense: false,
//                     onChanged: (YN newValue) {
//                       setState(() {
//                         editedReport.medicalHist.dyslipidaemia = newValue;
//                       });
//                     },
//                     items: YN.values.map((YN value) {
//                       return DropdownMenuItem<YN>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Old MI
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Old MI: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<YN>(
//                     value: editedReport.medicalHist.old_mi,
//                     isDense: false,
//                     onChanged: (YN newValue) {
//                       setState(() {
//                         editedReport.medicalHist.old_mi = newValue;
//                       });
//                     },
//                     items: YN.values.map((YN value) {
//                       return DropdownMenuItem<YN>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 1.h),
//             // Trop I
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Trop I: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<PN>(
//                     value: editedReport.medicalHist.trop_i,
//                     isDense: false,
//                     onChanged: (PN newValue) {
//                       setState(() {
//                         editedReport.medicalHist.trop_i = newValue;
//                       });
//                     },
//                     items: PN.values.map((PN value) {
//                       return DropdownMenuItem<PN>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//   _buildSpokeRespForm() => SingleChildScrollView(
//         child: Container(
//           width: SizeConfig.screenWidth,
//           margin: EdgeInsets.only(
//             left: 20,
//             right: 20,
//             top: 0,
//             // bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 2.h),
//               // Chest Pain
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Chest Pain: '),
//                   Container(
//                     width: SizeConfig.screenWidth * 0.4,
//                     child: DropdownButton<YN>(
//                       value: editedReport.chestReport.chest_pain,
//                       isDense: false,
//                       onChanged: (YN newValue) {
//                         setState(() {
//                           editedReport.chestReport.chest_pain = newValue;
//                         });
//                       },
//                       items: YN.values.map((YN value) {
//                         return DropdownMenuItem<YN>(
//                           value: value,
//                           child: Text(value.toString().split('.')[1]),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 1.h),
//               // Site
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Site: '),
//                   Container(
//                     width: SizeConfig.screenWidth * 0.4,
//                     child: DropdownButton<Site>(
//                       value: editedReport.chestReport.site,
//                       isDense: false,
//                       onChanged: (Site newValue) {
//                         setState(() {
//                           editedReport.chestReport.site = newValue;
//                         });
//                       },
//                       items: Site.values.map((Site value) {
//                         return DropdownMenuItem<Site>(
//                           value: value,
//                           child: Text(value.toString().split('.')[1]),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 1.h),
//               // Location
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Location: '),
//                   Container(
//                     width: SizeConfig.screenWidth * 0.4,
//                     child: DropdownButton<Location>(
//                       value: editedReport.chestReport.location,
//                       isDense: false,
//                       onChanged: (Location newValue) {
//                         setState(() {
//                           editedReport.chestReport.location = newValue;
//                         });
//                       },
//                       items: Location.values.map((Location value) {
//                         return DropdownMenuItem<Location>(
//                           value: value,
//                           child: Text(value.toString().split('.')[1]),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 1.h),
//               // Intensity
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                 Text('Intensity: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<Intensity>(
//                     value: editedReport.chestReport.intensity,
//                     isDense: false,
//                     onChanged: (Intensity newValue) {
//                       setState(() {
//                         editedReport.chestReport.intensity = newValue;
//                       });
//                     },
//                     items: Intensity.values.map((Intensity value) {
//                       return DropdownMenuItem<Intensity>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ]),

//               SizedBox(height: 1.h),
//               // Severity
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                 Text('Severity: '),
//                 Container(
//                   width: SizeConfig.screenWidth * 0.4,
//                   child: DropdownButton<Severity>(
//                     value: editedReport.chestReport.severity,
//                     isDense: false,
//                     onChanged: (Severity newValue) {
//                       setState(() {
//                         editedReport.chestReport.severity = newValue;
//                       });
//                     },
//                     items: Severity.values.map((Severity value) {
//                       return DropdownMenuItem<Severity>(
//                         value: value,
//                         child: Text(value.toString().split('.')[1]),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ]),
//               SizedBox(height: 1.h),
//               // Radiation
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Radiation: '),
//                   Container(
//                     width: SizeConfig.screenWidth * 0.4,
//                     child: DropdownButton<Radiation>(
//                       value: editedReport.chestReport.radiation,
//                       isDense: false,
//                       onChanged: (Radiation newValue) {
//                         setState(() {
//                           editedReport.chestReport.radiation = newValue;
//                         });
//                       },
//                       items: Radiation.values.map((Radiation value) {
//                         return DropdownMenuItem<Radiation>(
//                           value: value,
//                           child: Text(value.toString().split('.')[1]),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 1.h),
//               // Duration
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Duration (in mins): '),
//                   Container(
//                     width: SizeConfig.screenWidth * 0.4,
//                     child: TextFormField(
//                       keyboardType: TextInputType.text,
//                       focusNode: null,
//                       initialValue: editedReport.chestReport.duration,
//                       onChanged: (newValue) =>
//                           editedReport.chestReport.duration = newValue,
//                       decoration: const InputDecoration(
//                         hintText: "Enter duration",
//                         floatingLabelBehavior: FloatingLabelBehavior.always,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
// }
