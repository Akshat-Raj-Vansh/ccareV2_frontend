//@dart=2.9
import 'package:ccarev2_frontend/pages/emergency/emergency_screen.dart';
import 'package:ccarev2_frontend/state_management/emergency/emergency_cubit.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:common/infra/MHttpClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import '../../main/infra/main_api.dart';
import '../../pages/auth/auth_page.dart';
import '../../pages/home/components/doctor.dart';
import '../../pages/home/components/driver.dart';
import '../../pages/home/components/patient.dart';
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
import '../pages/splash/splash_screen.dart';
import '../user/domain/user_service_contract.dart';
import '../user/infra/user_api.dart';

class CompositionRoot {
  static SharedPreferences sharedPreferences;
  static ILocalStore localStore;
  static String baseUrl;
  static Client client;
  static SecureClient secureClient;
  static UserAPI userAPI;
  static MainAPI mainAPI;
  static IAuthPageAdapter authPageAdapter;
  static IProfilePageAdapter profilePageAdapter;
  static IHomePageAdapter homePageAdapter;
  static UserService userService;
  static UserCubit userCubit;
  static MainCubit mainCubit;
  static ProfileCubit profileCubit;
  static EmergencyCubit emergencyCubit;

  static configure() async {
    sharedPreferences = await SharedPreferences.getInstance();
    localStore = LocalStore(sharedPreferences);
    client = Client();
    secureClient = SecureClient(MHttpClient(client), localStore);
    // baseUrl = "http://192.168.1.151:3000";
    baseUrl = "https://cardiocarenith.herokuapp.com";
    userAPI = UserAPI(client, baseUrl);
    mainAPI = MainAPI(client, baseUrl);
    homePageAdapter = HomePageAdapter(createPatientHomeUI, createDoctorHomeUI,
        createDriverHomeUI, createEmergencyUI, splashScreen);
    profilePageAdapter =
        ProfilePageAdapter(homePageAdapter, createProfileScreen);
    authPageAdapter = AuthPageAdapter(profilePageAdapter, createLoginScreen);
    userCubit = UserCubit(localStore, userAPI);
    mainCubit = MainCubit(localStore, mainAPI);
    profileCubit = ProfileCubit(localStore, userAPI);
    emergencyCubit = EmergencyCubit(localStore, mainAPI);
  }

  static Future<Widget> start() async {
    var token = await localStore.fetch();
    var isnewUser = await localStore.fetchNewUser();
    var userType = await localStore.fetchUserType();
    print("user type ${userType}");
    return token == null
        ? splashScreen()
        : isnewUser
            ? createProfileScreen(userType)
            : createHomeUI(userType);
  }

  static Widget splashScreen() {
    return SplashScreen(authPageAdapter);
  }

  static Widget createLoginScreen(UserType userType) {
    return MultiCubitProvider(
      providers: [
        CubitProvider<UserCubit>(create: (context) => userCubit),
        CubitProvider<ProfileCubit>(create: (context) => profileCubit),
      ],
      child: AuthPage(
        userType: userType,
        pageAdatper: authPageAdapter,
      ),
    );
  }

  static Widget createHomeUI(UserType userType) {
    if (userType == UserType.patient)
      return createPatientHomeUI();
    else if (userType == UserType.doctor)
      return createDoctorHomeUI();
    else
      return createDriverHomeUI();
  }

  static Widget createProfileScreen(UserType userType) {
    return MultiCubitProvider(
      providers: [
        CubitProvider<UserCubit>(create: (context) => userCubit),
        CubitProvider<ProfileCubit>(create: (context) => profileCubit),
      ],
      child: ProfileScreen(profilePageAdapter, userType, profileCubit),
    );
  }

  static Widget createPatientHomeUI() {
    return MultiCubitProvider(
        providers: [
          CubitProvider<UserCubit>(
            create: (context) => userCubit,
          ),
          CubitProvider<MainCubit>(
            create: (context) => mainCubit,
          ),
          CubitProvider<EmergencyCubit>(create: (context) => emergencyCubit),
        ],
        child: PatientHomeUI(
            mainCubit, userCubit, emergencyCubit, homePageAdapter));
  }

  static Widget createDoctorHomeUI() {
    return MultiCubitProvider(
        providers: [
          CubitProvider<UserCubit>(
            create: (context) => userCubit,
          ),
          CubitProvider<MainCubit>(
            create: (context) => mainCubit,
          ),
          CubitProvider<EmergencyCubit>(create: (context) => emergencyCubit),
        ],
        child: DoctorHomeUI(
            mainCubit, userCubit, emergencyCubit, homePageAdapter));
  }

  static Widget createDriverHomeUI() {
    return MultiCubitProvider(
        providers: [
          CubitProvider<UserCubit>(
            create: (context) => userCubit,
          ),
          CubitProvider<MainCubit>(
            create: (context) => mainCubit,
          ),
          CubitProvider<EmergencyCubit>(create: (context) => emergencyCubit),
        ],
        child: DriverHomeUI(
            mainCubit, userCubit, emergencyCubit, homePageAdapter));
  }

  static Widget createEmergencyUI(UserType userType, Location location) {
    return MultiCubitProvider(
      providers: [
        CubitProvider<UserCubit>(create: (context) => userCubit),
        CubitProvider<MainCubit>(create: (context) => mainCubit),
        CubitProvider<EmergencyCubit>(create: (context) => emergencyCubit),
      ],
      child: EmergencyScreen(
        userCubit: userCubit,
        mainCubit: mainCubit,
        emergencyCubit: emergencyCubit,
        userType: userType,
        location: location,
      ),
    );
  }
}
