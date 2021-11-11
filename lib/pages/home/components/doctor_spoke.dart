import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:flutter/material.dart';

class HomeScreenSpoke extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;

  const HomeScreenSpoke(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  _HomeScreenSpokeState createState() => _HomeScreenSpokeState();
}

class _HomeScreenSpokeState extends State<HomeScreenSpoke> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Spoke Home Screen'));
  }
}
