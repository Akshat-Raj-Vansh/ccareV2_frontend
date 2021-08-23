import 'package:flutter/material.dart';

import '../auth/auth_page_adapter.dart';
import '../../pages/splash/components/body.dart';
import '../../utils/size_config.dart';

class SplashScreen extends StatelessWidget {
  final IAuthPageAdapter pageAdatper;

  const SplashScreen(this.pageAdatper);
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(pageAdatper),
    );
  }
}
