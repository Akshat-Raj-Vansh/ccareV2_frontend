import 'package:flutter/material.dart';

import 'components/body.dart';
import '../../pages/auth/authPage_adapter.dart';
import '../../utils/size_config.dart';

class SplashScreen extends StatelessWidget {
  final IAuthPageAdapter pageAdatper;

  const SplashScreen(this.pageAdatper);
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(this.pageAdatper),
    );
  }
}
