import '../../../state_management/auth/auth_cubit.dart';
import '../../../utils/size_config.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';
import 'package:auth/auth.dart';

class OtpScreen extends StatelessWidget {
  final AuthCubit cubit;
  final PhoneAuth authService;
  final String phone;
  OtpScreen(this.cubit, this.phone, this.authService);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Body(this.cubit, this.phone, this.authService);
  }
}
