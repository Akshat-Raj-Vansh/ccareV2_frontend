import 'package:ccarev2_frontend/pages/profile/profile_page_adapter.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
  @override
  void initState() {
    //print("PROFILE SCREEN");
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
            _buildUI(context),
            SizedBox(height: SizeConfig.screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  _buildUI(BuildContext context) => CubitConsumer<ProfileCubit, ProfileState>(
      cubit: widget.cubit,
      builder: (_, state) {
        //print("INSIDE BUILDER PROFILE SCREEN");
        //print('STATE:');
        //print(state.toString());
        return Expanded(
          child: widget.pageAdapter
              .loadProfiles(context, widget.userType, widget.cubit),
        );
      },
      listener: (context, state) {
        //print(state);
        if (state is LoadingState) {
          //print("Loading State Called Profile Screen");
          // _showLoader();
        } else if (state is AddProfileState) {
          //print("Add Profile State Called");
          // _hideLoader();
          // _showMessage(state.message);
          widget.pageAdapter.onProfileCompletion(context, widget.userType);
        } else if (state is ErrorState) {
          //print('Error State Called PROFILE SCREEN');
          // _hideLoader();
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
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Text(
        msg,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            .copyWith(color: Colors.white, fontSize: 12.sp),
      ),
    ));
  }

  _showLogo(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Image(
                image: AssetImage("assets/logo.png"),
                width: 55.w,
                height: 180,
                fit: BoxFit.fill),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                  text: "Personal",
                  style: Theme.of(context).textTheme.bodySmall.copyWith(
                      color: Colors.lightGreen[500],
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: " Details",
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    )
                  ]),
            ),
            SizedBox(height: 5.h)
          ],
        ),
      );
}
