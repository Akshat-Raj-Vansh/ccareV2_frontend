//@dart=2.9
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/pages/spoke_form/components/history_details.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../utils/size_config.dart';

class PatientReportHistoryScreen extends StatefulWidget {
  final MainCubit mainCubit;

  const PatientReportHistoryScreen({Key key, this.mainCubit}) : super(key: key);
  @override
  _PatientReportHistoryScreenState createState() =>
      _PatientReportHistoryScreenState();
}

class _PatientReportHistoryScreenState
    extends State<PatientReportHistoryScreen> {
  TreatmentReport report1;
  TreatmentReport report2;

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
        return buildBody();
      },
      listener: (context, state) {
        if (state is PatientReportHistoryFetched) {
          print("Patient TreatmentReport History Fetched state Called");
          report1 = state.report1;
          report2 = state.report2;
          _hideLoader();
        }

        if (state is NoReportState) {
          print('No TreatmentReport State Called');
          _hideLoader();
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
              _buildReportDetails(),
              _buildReport(),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  _buildReportDetails() => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "TreatmentReport's Details",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.red[100],
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
        ),
      ]);

  _buildReport() => Text("Hello World");
}
