//@dart=2.9
import 'package:ccarev2_frontend/pages/emergency/emergency_screen.dart';
import 'package:ccarev2_frontend/pages/home/components/doctor_hub.dart';
import 'package:ccarev2_frontend/pages/home/components/doctor_spoke.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
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
//90d9f67022627247658ea748f4695546
  static configure() async {
    sharedPreferences = await SharedPreferences.getInstance();
    localStore = LocalStore(sharedPreferences);
    client = Client();
    // secureClient = SecureClient(MHttpClient(client), localStore);
    baseUrl = "http://192.168.0.139:3000";
    // baseUrl = "https://cardiocarenith.herokuapp.com";
    //baseUrl = "http://192.168.80.55:3000";

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

  static Future<Widget> start() async {
    // var token = await localStore.fetch();
    // var isnewUser = await localStore.fetchNewUser();
    // var userType = await localStore.fetchUserType();
    Details details = await localStore.fetchDetails();
    print("COMPOSITION ROOT START");

    if (details == null) return splashScreen();
    print("user type ${details.user_type}");
    print('DETAILS:');
    print(details.toJson());
    return details.user_token == null
        ? splashScreen()
        : details.newUser
            ? createProfileScreen(details)
            : createHomeUI(details);
  }

  static Widget splashScreen() {
    return SplashScreen(authPageAdapter);
  }

  static Widget createLoginScreen(UserType userType) {
    ProfileCubit profileCubit = ProfileCubit(localStore, userAPI);
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

  static Widget createHomeUI(Details details) {
    UserType userType = details.user_type;
    if (userType == UserType.PATIENT)
      return createPatientHomeUI();
    else if (userType == UserType.SPOKE)
      return createSpokeDoctorHomeUI();
    else if (userType == UserType.HUB) return createHubDoctorHomeUI();
    return createDriverHomeUI();
  }

  static Widget createProfileScreen(Details details) {
    ProfileCubit profileCubit = ProfileCubit(localStore, userAPI);
    return MultiCubitProvider(
      providers: [
        CubitProvider<UserCubit>(create: (context) => userCubit),
        CubitProvider<ProfileCubit>(create: (context) => profileCubit),
      ],
      child: ProfileScreen(profilePageAdapter, details, profileCubit),
    );
  }

  static Widget createPatientHomeUI() {
    return MultiCubitProvider(providers: [
      CubitProvider<UserCubit>(
        create: (context) => userCubit,
      ),
      CubitProvider<MainCubit>(
        create: (context) => mainCubit,
      ),
    ], child: PatientHomeUI(mainCubit, userCubit, homePageAdapter));
  }

  static Widget createSpokeDoctorHomeUI() {
    return MultiCubitProvider(providers: [
      CubitProvider<UserCubit>(
        create: (context) => userCubit,
      ),
      CubitProvider<MainCubit>(
        create: (context) => mainCubit,
      ),
    ], child: HomeScreenSpoke(mainCubit, userCubit, homePageAdapter));
  }

  static Widget createHubDoctorHomeUI() {
    return MultiCubitProvider(providers: [
      CubitProvider<UserCubit>(
        create: (context) => userCubit,
      ),
      CubitProvider<MainCubit>(
        create: (context) => mainCubit,
      ),
    ], child: HomeScreenHub(mainCubit, userCubit, homePageAdapter));
  }

  static Widget createDriverHomeUI() {
    return MultiCubitProvider(providers: [
      CubitProvider<UserCubit>(
        create: (context) => userCubit,
      ),
      CubitProvider<MainCubit>(
        create: (context) => mainCubit,
      ),
    ], child: DriverHomeUI(homePageAdapter));
  }

  static Widget createEmergencyUI(UserType userType, Location location) {
    return MultiCubitProvider(
      providers: [
        CubitProvider<UserCubit>(create: (context) => userCubit),
        CubitProvider<MainCubit>(create: (context) => mainCubit),
      ],
      child: EmergencyScreen(
        userType: userType,
        location: location,
      ),
    );
  }
}
