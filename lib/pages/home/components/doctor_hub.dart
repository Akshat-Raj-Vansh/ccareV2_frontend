import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:flutter/material.dart';

class HomeScreenHub extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;

  const HomeScreenHub(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  _HomeScreenHubState createState() => _HomeScreenHubState();
}

class _HomeScreenHubState extends State<HomeScreenHub> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Hub Home Screen'));
  }
}
