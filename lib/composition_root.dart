//@dart=2.9
import 'package:ccarev2_frontend/pages/auth/auth_page.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:common/infra/MHttpClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import '../cache/ilocal_store.dart';
import '../cache/local_store.dart';
import 'pages/auth/auth_page_adapter.dart';
import '../network_service/secure_client.dart';
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
  static IAuthPageAdapter pageAdapter;
  static UserService userService;

  static configure() async {
    sharedPreferences = await SharedPreferences.getInstance();
    localStore = LocalStore(sharedPreferences);
    client = Client();
    secureClient = SecureClient(MHttpClient(client), localStore);
    baseUrl = "http://192.168.0.139:3000";
    userAPI = UserAPI(client, baseUrl);
    pageAdapter = AuthPageAdapter(createHomeUI, createLoginScreen);
    // pageAdapter = AuthPageAdapter(createHomeUI, createLoginScreen);
  }

  static Future<Widget> start() async {
    var token = await localStore.fetch();
    var userType = await localStore.fetchUserType();

    return token == null ? splashScreen() : createHomeUI();
  }

  static Widget splashScreen() {
    return SplashScreen(pageAdapter);
  }

  static Widget createLoginScreen() {
    UserCubit userCubit = UserCubit(localStore, userAPI);
    ProfileCubit profileCubit = ProfileCubit(localStore, userAPI);

    return MultiCubitProvider(
      providers: [
        CubitProvider<UserCubit>(create: (context) => userCubit),
        CubitProvider<ProfileCubit>(create: (context) => profileCubit),
      ],
      child: AuthPage(
        userService: userService,
        userAPI: userAPI,
        pageAdatper: pageAdapter,
      ),
    );
  }

  static Widget createHomeUI() {
    // MainCubit mainCubit = MainCubit(localStore, mainApi);
    // ProfileCubit profileCubit = ProfileCubit(localStore, profileApi);
    // AuthCubit authCubit = AuthCubit(localStore);
    UserCubit userCubit = UserCubit(localStore, userAPI);
    return MultiCubitProvider(
      providers: [
        CubitProvider<UserCubit>(
          create: (context) => userCubit,
        ),
        // CubitProvider<MainCubit>(create: (context) => mainCubit),
        // CubitProvider<ProfileCubit>(
        //   create: (context) => profileCubit,
        // )
      ],
      child: Text('HOME UI'),
      //  TabPage(
      //   userService,
      //   TabPageAdapter(createLoginScreen),
      // ),
    );
  }
}
