import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

class DriverHomeUI extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;
  const DriverHomeUI(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  State<DriverHomeUI> createState() => _DriverHomeUIState();
}

class _DriverHomeUIState extends State<DriverHomeUI> {
  @override
  Widget build(BuildContext context) {
    return CubitConsumer<MainCubit, MainState>(builder: (_, state) {
      return _buildUI(context, widget.mainCubit);
    }, listener: (context, state) {
      if (state is LoadingState) {
        print("Loading State Called");
        _showLoader();
      } else if (state is AcceptState) {
        print("Accept State Called");
        _hideLoader();
      }
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

  _buildUI(BuildContext context, MainCubit mainCubit) => Scaffold(
        appBar: AppBar(
          title: Text('Driver Home UI'),
          leading: IconButton(
            onPressed: () =>
                widget.homePageAdapter.onLogout(context, widget.userCubit),
            icon: Icon(Icons.logout),
          ),
        ),
        body: Center(
          child: RaisedButton(
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).accentColor,
                content: Text(
                  'This button is used for accepting patients',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white, fontSize: 16),
                ),
              ));
            },
            child: const Text('Alert Button'),
          ),
        ),
      );
}
