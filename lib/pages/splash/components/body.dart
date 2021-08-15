//@dart=2.9
import 'package:flutter/material.dart';

// This is the best practice
import '../components/splash_content.dart';
import '../../../components/default_button.dart';

import '../../../pages/auth/authPage_adapter.dart';
import '../../../utils/constants.dart';
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
    {
      "text":
          "Get your reports analysed by doctors. \n Just stay at home with us",
      "image": "assets/images/sp3.png"
    },
    {
      "text":
          "Deal with emergency situations better. \nLet us take care of calling \nthe ambulances and the hospitals.",
      "image": "assets/images/sp2.png"
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
              child: PageView.builder(
                controller: controller,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 1),
                    DefaultButton(
                      text: currentPage == 2 ? "Continue" : "Next",
                      press: () {
                        if (currentPage == 2)
                          widget.pageAdapter.onSplashScreenComplete(context);
                        else
                          controller.nextPage(
                              duration: Duration(microseconds: 1000),
                              curve: Curves.elasticIn);
                      },
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

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 12,
      width: currentPage == index ? 40 : 12,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
