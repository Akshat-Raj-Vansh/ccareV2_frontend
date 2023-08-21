import 'package:flutter/material.dart';

import '../auth/auth_page_adapter.dart';
import 'components/body.dart';
import '../../utils/size_config.dart';

class SplashScreen extends StatelessWidget {
  IAuthPageAdapter pageAdatper;

  SplashScreen(this.pageAdatper);

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);

    return WillPopScope(
      onWillPop: () async {
        return await _onBackPressed(context);
      },
      child: Scaffold(
        body: Body(pageAdatper),
      ),
    );
  }

  _onBackPressed(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Padding(
            padding: EdgeInsets.only(top: 12, left: 6),
            child: Text('Are you sure?'),
          ),
          content: const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Text('Do you want to exit an App'),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text("NO"),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(true),
              child: const Padding(
                padding: EdgeInsets.only(right: 12.0, bottom: 12),
                child: Text("YES"),
              ),
            ),
          ],
        ),
      );
}
