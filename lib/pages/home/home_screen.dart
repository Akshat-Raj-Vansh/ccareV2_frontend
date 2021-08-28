//@dart=2.9s
import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final HomePageAdapter homePageAdapter;
  HomeScreen(this.homePageAdapter);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            widget.homePageAdapter.onLogout(context);
          },
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
        title: const Text('Cardio Care'),
      ),
      body: widget.homePageAdapter.onLoginSuccess(context),
    );
  }
}
