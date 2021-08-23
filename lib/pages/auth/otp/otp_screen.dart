import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/user_service_contract.dart';
import 'package:ccarev2_frontend/user/infra/user_api.dart';

import 'package:flutter/material.dart';
import './components/body.dart';
import '../../../utils/size_config.dart';

class OtpScreen extends StatelessWidget {
  final UserCubit cubit;
  final UserService userService;
  final String phone;
  OtpScreen(this.cubit, this.phone, this.userService);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Body(this.cubit, this.phone, this.userService);
  }
}
