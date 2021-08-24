//@dart=2.9
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter/material.dart';

// This is the best practice
import '../components/splash_content.dart';
import '../../../components/default_button.dart';

import '../../auth/auth_page_adapter.dart';
import '../../../utils/size_config.dart';

class Body extends StatefulWidget {
  final IAuthPageAdapter pageAdapter;

  const Body(this.pageAdapter);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  PageController controller = PageController();
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to CardioCare,\n Let’s take care of your heart!",
      "image": "assets/images/sp1.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: SplashContent(
                image: splashData[0]["image"],
                text: splashData[0]['text'],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(flex: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DefaultButton(
                          text: "I'm a Patient",
                          press: () => widget.pageAdapter
                              .onSplashScreenComplete(
                                  context, UserType.patient),
                        ),
                        DefaultButton(
                          text: "I'm a Doctor",
                          press: () => widget.pageAdapter
                              .onSplashScreenComplete(context, UserType.doctor),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
