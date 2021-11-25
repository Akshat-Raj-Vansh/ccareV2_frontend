//@dart=2.9
import 'package:ccarev2_frontend/pages/profile/profile_page_adapter.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/doc_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../utils/size_config.dart';

class ProfileScreen extends StatefulWidget {
  final ProfileCubit cubit;
  final IProfilePageAdapter pageAdapter;
  final UserType userType;
  const ProfileScreen(this.pageAdapter, this.userType, this.cubit);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Info docInfo;
  @override
  void initState() {
    print("PROFILE SCREEN");
    print("USERTYPE");
    print(widget.userType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(resizeToAvoidBottomInset: false, body: buildbody());
  }

  buildbody() {
    return SizedBox(
      height: SizeConfig.screenHeight,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            _showLogo(context),
            if (widget.userType == UserType.HUB ||
                widget.userType == UserType.SPOKE)
              _showInfo(context),
            _buildUI(context),
            SizedBox(height: SizeConfig.screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  _showInfo(BuildContext context) => Center(
        child: Text('HELLO WORLD'),
      );
  _buildUI(BuildContext context) => CubitConsumer<ProfileCubit, ProfileState>(
      cubit: widget.cubit,
      builder: (_, state) {
        return Expanded(
            child: widget.pageAdapter
                .loadProfiles(context, widget.userType, widget.cubit));
      },
      listener: (context, state) {
        if (state is LoadingState) {
          print("Loading State Called");
          _showLoader();
        } else if (state is DocInfoState) {
          print("Doc Info State Called");
          _hideLoader();
          docInfo = state.docInfo;
        } else if (state is AddProfileState) {
          print("Add Profile State Called");
          _hideLoader();
          // _showMessage(state.message);
          widget.pageAdapter.onProfileCompletion(context, widget.userType);
        } else if (state is ErrorState) {
          print('Error State Called');
          _hideLoader();
          _showMessage(state.error);
        }
      });

  _showLoader() {
    var alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.green,
      )),
    );

    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        msg,
        style: Theme.of(context)
            .textTheme
            .caption
            .copyWith(color: Colors.white, fontSize: 16),
      ),
    ));
  }

  _showLogo(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const Image(
                image: AssetImage("assets/logo.png"),
                width: 192,
                height: 180,
                fit: BoxFit.fill),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                  text: "Personal",
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Colors.lightGreen[500],
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: " Details",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )
                  ]),
            ),
            SizedBox(height: 30)
          ],
        ),
      );
}
