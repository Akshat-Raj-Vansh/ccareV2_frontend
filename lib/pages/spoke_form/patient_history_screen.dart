//@dart=2.9
import 'dart:developer';

import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/pages/spoke_form/components/history_details.dart';
import 'package:ccarev2_frontend/pages/spoke_form/components/patient_report_overview.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../utils/size_config.dart';
import 'package:timelines/timelines.dart';

class PatientReportHistoryScreen extends StatefulWidget {
  final MainCubit mainCubit;

  const PatientReportHistoryScreen({Key key, this.mainCubit}) : super(key: key);
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
    await widget.mainCubit.fetchPatientReportHistory();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CubitConsumer<MainCubit, MainState>(
      cubit: widget.mainCubit,
      builder: (_, state) {
        if (state is NoHistoryState) {
          log('DATA > patient_history_screen.dart > FUNCTION_NAME > 77 > state.error: ${state.error}');
          return Scaffold(
            appBar: AppBar(
              title: Text('Medical History'),
              backgroundColor: kPrimaryColor,
            ),
            body: Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  state.error,
                  style: TextStyle(fontSize: 18, color: Colors.black),
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
          // _hideLoader();
        }

        if (state is NoReportState) {
          print('No Treatment Report State Called');
          // _hideLoader();
        }
      },
    );
  }

  buildBody() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Medical History'),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            onPressed: () async {
              print('Refresh button pressed');
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
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              Expanded(
                  child: FixedTimeline.tileBuilder(
                builder: TimelineTileBuilder.connectedFromStyle(
                  contentsAlign: ContentsAlign.basic,
                  oppositeContentsBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Medical History'),
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
                        child: Text(DateTime.fromMillisecondsSinceEpoch(
                                int.parse(reports[index].report_time))
                            .toString()),
                      ),
                    ),
                  ),
                  connectorStyleBuilder: (context, index) =>
                      ConnectorStyle.solidLine,
                  indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
                  itemCount: reports.length,
                ),
              )
                  // ListView.builder(
                  //   itemCount: reports.length,
                  //   itemBuilder: (context, index) {
                  //     return GestureDetector(
                  //       onTap: () {
                  //         //FIXME: Navigate to the current report page
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => ReportOverview(
                  //                 reports[index],
                  //               ),
                  //             ));
                  //       },
                  //       child: Text(
                  //         DateTime.fromMillisecondsSinceEpoch(
                  //                 int.parse(reports[index].report_time))
                  //             .toString(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  ),
              // _buildReportDetails(),
              // _buildReport(),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
