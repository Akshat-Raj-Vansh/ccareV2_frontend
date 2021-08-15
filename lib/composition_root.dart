//@dart=2.9
import 'package:auth/auth.dart';
import '../cache/IlocalStore.dart';
import '../pages/Home/tabPage.dart';
import '../pages/Home/tapPageAdapter.dart';
import '../pages/splash/splash_screen.dart';
import '../state_management/main_app/main_cubit.dart';
import '../state_management/profile/profile_Cubit.dart';
import 'package:common/infra/MHttpClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:profile/profile.dart';
import 'cache/localStore.dart';
import 'pages/auth/authPage.dart';
import 'package:extras/extras.dart';
import 'pages/auth/authPage_adapter.dart';
import 'state_management/auth/auth_cubit.dart';
import 'decorators/secure_client.dart';

class CompositionRoot {
  static SharedPreferences sharedPreferences;
  static ILocalStore localStore;
  static String baseUrl;
  static Client client;
  static SecureClient secureClient;
  static AuthManger _manager;
  static IAuthApi authApi;
  static IMainApi mainApi;
  static IProfileApi profileApi;
  static IAuthPageAdapter pageAdapter;

  static configure() async {
    sharedPreferences = await SharedPreferences.getInstance();
    localStore = LocalStore(sharedPreferences);
    client = Client();
    secureClient = SecureClient(MHttpClient(client), localStore);
    baseUrl = "http://192.168.0.139:3000";
    authApi = AuthApi(client, baseUrl);
    mainApi = MainApi(client, baseUrl);
    profileApi = ProfileApi(client, baseUrl);
    _manager = AuthManger(authApi);
    pageAdapter = AuthPageAdapter(createHomeUI, createAuthUI);
  }

  static Future<Widget> start() async {
    var token = await localStore.fetch();
    var authType = await localStore.fetchAuthType();
    var service = _manager.service(authType);

    return token == null ? splashScreen() : createHomeUI(service);
  }

  static Widget splashScreen() {
    return SplashScreen(pageAdapter);
  }

  static Widget createAuthUI() {
    AuthCubit authCubit = AuthCubit(localStore);

    ISignUpService signUpService = SignUpService(authApi);

    ProfileCubit profileCubit = ProfileCubit(localStore, profileApi);
    return MultiCubitProvider(
      providers: [
        CubitProvider<AuthCubit>(create: (context) => authCubit),
        CubitProvider<ProfileCubit>(create: (context) => profileCubit),
      ],
      child: AuthPage(
        authManger: _manager,
        signUpService: signUpService,
        pageAdatper: pageAdapter,
      ),
    );
  }

  static Widget createHomeUI(IAuthService authService) {
    MainCubit mainCubit = MainCubit(localStore, mainApi);
    ProfileCubit profileCubit = ProfileCubit(localStore, profileApi);
    AuthCubit authCubit = AuthCubit(localStore);
    return MultiCubitProvider(providers: [
      CubitProvider<AuthCubit>(
        create: (context) => authCubit,
      ),
      CubitProvider<MainCubit>(create: (context) => mainCubit),
      CubitProvider<ProfileCubit>(
        create: (context) => profileCubit,
      )
    ], child: TabPage(authService, TabPageAdapter(createAuthUI)));
  }
}
