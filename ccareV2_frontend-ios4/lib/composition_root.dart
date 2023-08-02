import 'package:ccarev2_frontend/pages/emergency/emergency_screen.dart';
import 'package:ccarev2_frontend/pages/home/hub/doctor_hub.dart';
import 'package:ccarev2_frontend/pages/home/spoke/doctor_spoke.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import '../../main/infra/main_api.dart';
import '../../pages/auth/auth_page.dart';
import '../../pages/home/components/driver.dart';
import 'pages/home/patient/patient.dart';
import '../../pages/home/home_page_adapter.dart';
import '../../pages/profile/profile_page_adapter.dart';
import '../../pages/profile/profile_screen.dart';
import '../../state_management/main/main_cubit.dart';
import '../../state_management/profile/profile_cubit.dart';
import '../../state_management/user/user_cubit.dart';
import '../../user/domain/credential.dart';
import '../cache/ilocal_store.dart';
import '../cache/local_store.dart';
import 'pages/auth/auth_page_adapter.dart';
import '../services/secure_client.dart';
import 'pages/splash/splash_screen.dart';
import '../user/domain/user_service_contract.dart';
import '../user/infra/user_api.dart';

class CompositionRoot {
  late SharedPreferences sharedPreferences;
  late ILocalStore localStore;
  late String baseUrl;
  late Client client;
  late SecureClient secureClient;
  late UserAPI userAPI;
  late MainAPI mainAPI;
  late IAuthPageAdapter authPageAdapter;
  late ProfilePageAdapter profilePageAdapter;
  late HomePageAdapter homePageAdapter;
  late UserService userService;
  late UserCubit userCubit;
  late MainCubit mainCubit;
//90d9f67022627247658ea748f4695546
   configure() async {
    sharedPreferences = await SharedPreferences.getInstance();
    localStore = LocalStore(sharedPreferences);
    client = Client();
    baseUrl = BASEURL;

    // baseUrl = "http://192.168.95.55:3000";
    userAPI = UserAPI(client, baseUrl);
    mainAPI = MainAPI(client, baseUrl);
    mainCubit = MainCubit(localStore, mainAPI);
    userCubit = UserCubit(localStore, userAPI);
    homePageAdapter = HomePageAdapter(
        createPatientHomeUI,
        createSpokeDoctorHomeUI,
        createHubDoctorHomeUI,
        createDriverHomeUI,
        createEmergencyUI,
        splashScreen);
    profilePageAdapter =
        ProfilePageAdapter(homePageAdapter, createProfileScreen);
    authPageAdapter = AuthPageAdapter(profilePageAdapter, createLoginScreen);
  }

  Future<Widget> start() async {
    // var token = await localStore.fetch();
    // var isnewUser = await localStore.fetchNewUser();
    // var userType = await localStore.fetchUserType();
    Details? details = await localStore.fetchDetails();
    //print("COMPOSITION ROOT START");

    if (details == null) return splashScreen();
    //print("user type ${details.user_type}");
    //print('DETAILS:');
    //print(details.toJson());
    // ignore: unnecessary_null_comparison
    return details.user_token == null
        ? splashScreen()
        : details.newUser
            ? createProfileScreen(details.user_type)
            : createHomeUI(details.user_type);
  }

  Widget splashScreen() {
    return SplashScreen(authPageAdapter);
  }

  Widget createLoginScreen() {
    ProfileCubit profileCubit = ProfileCubit(localStore, userAPI);
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(create: (context) => userCubit),
        BlocProvider<ProfileCubit>(create: (context) => profileCubit),
      ],
      child: AuthPage(
        pageAdatper: authPageAdapter,
      ),
      // child: AuthPage(
      //   pageAdatper: authPageAdapter,
      // ),
    );
  }

  Widget createHomeUI(UserType userType) {
    if (userType == UserType.PATIENT)
      return createPatientHomeUI();
    else if (userType == UserType.SPOKE)
      return createSpokeDoctorHomeUI();
    else if (userType == UserType.HUB) return createHubDoctorHomeUI();
    return createDriverHomeUI();
  }

  Widget createProfileScreen(UserType userType) {
    ProfileCubit profileCubit = ProfileCubit(localStore, userAPI);
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(create: (context) => userCubit),
        BlocProvider<ProfileCubit>(create: (context) => profileCubit),
      ],
      child: ProfileScreen(profilePageAdapter, userType, profileCubit),
    );
  }

  Widget createPatientHomeUI() {
    return MultiBlocProvider(providers: [
      BlocProvider<UserCubit>(
        create: (context) => userCubit,
      ),
      BlocProvider<MainCubit>(
        create: (context) => mainCubit,
      ),
    ], child: PatientHomeUI(mainCubit, userCubit, homePageAdapter));
  }

  Widget createSpokeDoctorHomeUI() {
    return MultiBlocProvider(providers: [
      BlocProvider<UserCubit>(
        create: (context) => userCubit,
      ),
      BlocProvider<MainCubit>(
        create: (context) => mainCubit,
      ),
    ], child: HomeScreenSpoke(mainCubit, userCubit, homePageAdapter));
  }

  Widget createHubDoctorHomeUI() {
    return MultiBlocProvider(providers: [
      BlocProvider<UserCubit>(
        create: (context) => userCubit,
      ),
      BlocProvider<MainCubit>(
        create: (context) => mainCubit,
      ),
    ], child: HomeScreenHub(mainCubit, userCubit, homePageAdapter));
  }

  Widget createDriverHomeUI() {
    return MultiBlocProvider(providers: [
      BlocProvider<UserCubit>(
        create: (context) => userCubit,
      ),
      BlocProvider<MainCubit>(
        create: (context) => mainCubit,
      ),
    ], child: DriverHomeUI(homePageAdapter, userCubit));
  }

  Widget createEmergencyUI(UserType userType, Location location) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(create: (context) => userCubit),
        BlocProvider<MainCubit>(create: (context) => mainCubit),
      ],
      child: EmergencyScreen(
        userType: userType,
        location: location, patientID: '',
      ),
    );
  }
}
