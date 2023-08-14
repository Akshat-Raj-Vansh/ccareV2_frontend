import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/pages/spoke_form/components/patient_report_overview.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import '../../utils/size_config.dart';
import 'package:timelines/timelines.dart';

class PatientReportHistoryScreen extends StatefulWidget {
  final MainCubit mainCubit;
  final String patientID;

  const PatientReportHistoryScreen(
      {Key? key, required this.mainCubit, required this.patientID})
      : super(key: key);
  @override
  _PatientReportHistoryScreenState createState() =>
      _PatientReportHistoryScreenState();
}

class _PatientReportHistoryScreenState
    extends State<PatientReportHistoryScreen> {
  List<TreatmentReport> reports = [];
  @override
  void initState() {
    super.initState();
    print('Patient Report History Init State');
    _fetchReport();
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
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Text(
        msg,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white, fontSize: 12.sp),
      ),
    ));
  }

  _fetchReport() async {
    //print("Fetching patient report");
    await widget.mainCubit.fetchPatientReportHistory(widget.patientID);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<MainCubit, MainState>(
      bloc: widget.mainCubit,
      builder: (_, state) {
        if (state is LoadingState) {
          _hideLoader();
        }
        if (state is NoHistoryState) {
          log('DATA > patient_history_screen.dart > FUNCTION_NAME > 77 > state.error: ${state.error}');
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Medical History',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: kPrimaryColor,
            ),
            body: Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  state.error,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),
              ),
            ),
          );
        }
        return buildBody();
      },
      listener: (context, state) {
        if (state is PatientReportHistoryFetched) {
          print("Patient TreatmentReport History Fetched state Called");
          reports = state.reports;
          reports = reports.reversed.toList();
        }
        if (state is NoReportState) {
          //print('No Treatment Report State Called');
          // _hideLoader();
        }
      },
    );
  }

  buildBody() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Medical History',
            style: TextStyle(fontSize: 16.sp, color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            onPressed: () async {
              //print('Refresh button pressed');
              _fetchReport();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: SizeConfig.screenHeight,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                FixedTimeline.tileBuilder(
                  builder: TimelineTileBuilder.connectedFromStyle(
                    contentsAlign: ContentsAlign.basic,
                    oppositeContentsBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(reports[index].report_time))
                              .toString()
                              .split(' ')[0],
                          style: TextStyle(fontSize: 12.sp)),
                    ),
                    contentsBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportOverview(
                                reports[index],
                              ),
                            ));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(reports[index].report_time))
                                .toString()
                                .split(' ')[1],
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                      ),
                    ),
                    connectorStyleBuilder: (context, index) {
                      if (index == 0)
                        return ConnectorStyle.solidLine;
                      else
                        return ConnectorStyle.dashedLine;
                    },
                    indicatorStyleBuilder: (context, index) {
                      if (index == 0)
                        return IndicatorStyle.dot;
                      else
                        return IndicatorStyle.outlined;
                    },
                    itemCount: reports.length,
                  ),
                ),
                // _buildReportDetails(),
                // _buildReport(),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
