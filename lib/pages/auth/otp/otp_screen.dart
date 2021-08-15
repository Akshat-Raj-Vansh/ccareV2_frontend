import '../../../state_management/auth/auth_cubit.dart';
import '../../../utils/size_config.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';
import 'package:auth/auth.dart';

class OtpScreen extends StatelessWidget {
  final AuthCubit cubit;
  final IAuthService authService;
  final String email;
  OtpScreen(this.cubit, this.email, this.authService);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(child: Body(this.cubit, this.email, this.authService)),
    );
  }
}
