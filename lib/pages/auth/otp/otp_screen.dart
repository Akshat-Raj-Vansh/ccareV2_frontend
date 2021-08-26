import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/user_service_contract.dart';
import 'package:ccarev2_frontend/user/infra/user_api.dart';

import 'package:flutter/material.dart';
import './components/body.dart';
import '../../../utils/size_config.dart';

class OtpScreen extends StatelessWidget {
  final UserCubit cubit;
  final UserAPI userAPI;
  final Credential credential;
  OtpScreen(this.cubit, this.credential, this.userAPI);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Body(this.cubit, this.credential, this.userAPI);
  }
}
