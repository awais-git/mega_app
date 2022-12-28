import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'generated/l10n.dart';
import 'route_generator.dart';
import 'src/helpers/app_config.dart' as config;
import 'src/helpers/custom_trace.dart';
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/user_repository.dart' as userRepo;
import 'package:google_map_location_picker/generated/l10n.dart'
    as location_picker;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GlobalConfiguration().loadFromAsset("configurations");
  print(CustomTrace(StackTrace.current,
      message: "base_url: ${GlobalConfiguration().getValue('base_url')}"));
  print(CustomTrace(StackTrace.current,
      message:
          "api_base_url: ${GlobalConfiguration().getValue('api_base_url')}"));
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  // This widget is the root of your application.
//  /// Supply 'the Controller' for this application.
//  MyApp({Key key}) : super(con: Controller(), key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    settingRepo.initSettings();
    settingRepo.getCurrentLocation();
    userRepo.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print("gesture");
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        child: ValueListenableBuilder(
            valueListenable: settingRepo.setting,
            builder: (context, Setting _setting, _) {
              return MaterialApp(
                  navigatorKey: settingRepo.navigatorKey,
                  title: _setting.appName,
                  initialRoute: '/Splash',
                  //initialRoute: '/Languages',
                  onGenerateRoute: RouteGenerator.generateRoute,
                  debugShowCheckedModeBanner: false,
                  locale: _setting.mobileLanguage.value,
                  localizationsDelegates: [
                    S.delegate,
                    location_picker.S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  theme: _setting.brightness.value == Brightness.light
                      ? ThemeData(
                          progressIndicatorTheme: ProgressIndicatorThemeData(
                            color: config.Colors().mainColor(1),
                          ),
                          fontFamily: 'ProductSans',
                          primaryColor: Colors.white,
                          floatingActionButtonTheme:
                              FloatingActionButtonThemeData(
                                  elevation: 0, foregroundColor: Colors.white),
                          colorScheme: ColorScheme.fromSwatch().copyWith(
                            secondary: config.Colors().mainColor(1),
                            brightness: Brightness.light,
                            
                          ),
                           iconTheme: IconThemeData(color: Colors.black),
                          dividerColor: config.Colors().accentColor(0.1),
                          focusColor: config.Colors().accentColor(1),
                          hintColor: config.Colors().secondColor(1),
                          textTheme: TextTheme(
                            headline5: TextStyle(
                                fontSize: 22.0,
                                color: config.Colors().secondColor(1),
                                height: 1.3),
                            headline4: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                                color: config.Colors().secondColor(1),
                                height: 1.3),
                            headline3: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w700,
                                color: config.Colors().secondColor(1),
                                height: 1.3),
                            headline2: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                                color: config.Colors().mainColor(1),
                                height: 1.4),
                            headline1: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.w300,
                                color: config.Colors().secondColor(1),
                                height: 1.4),
                            subtitle1: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: config.Colors().secondColor(1),
                                height: 1.3),
                            headline6: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w700,
                                color: config.Colors().mainColor(1),
                                height: 1.3),
                            bodyText2: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: config.Colors().secondColor(1),
                                height: 1.2),
                            bodyText1: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: config.Colors().secondColor(1),
                                height: 1.3),
                            caption: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                                color: config.Colors().accentColor(1),
                                height: 1.2),
                          ),
                        )
                      : ThemeData(
                          fontFamily: 'ProductSans',
                          primaryColor: Color(0xFF252525),
                          scaffoldBackgroundColor: Color(0xFF2C2C2C),
                          colorScheme: ColorScheme.fromSwatch().copyWith(
                            secondary: config.Colors().mainDarkColor(1),
                            brightness: Brightness.dark,
                          ),
                           iconTheme: IconThemeData(color: Colors.white),
                          dividerColor: config.Colors().accentColor(0.1),
                          hintColor: config.Colors().secondDarkColor(1),
                          focusColor: config.Colors().accentDarkColor(1),
                          textTheme: TextTheme(
                            headline5: TextStyle(
                                fontSize: 22.0,
                                color: config.Colors().secondDarkColor(1),
                                height: 1.3),
                            headline4: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                                color: config.Colors().secondDarkColor(1),
                                height: 1.3),
                            headline3: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w700,
                                color: config.Colors().secondDarkColor(1),
                                height: 1.3),
                            headline2: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                                color: config.Colors().mainDarkColor(1),
                                height: 1.4),
                            headline1: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.w300,
                                color: config.Colors().secondDarkColor(1),
                                height: 1.4),
                            subtitle1: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: config.Colors().secondDarkColor(1),
                                height: 1.3),
                            headline6: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w700,
                                color: config.Colors().mainDarkColor(1),
                                height: 1.3),
                            bodyText2: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: config.Colors().secondDarkColor(1),
                                height: 1.2),
                            bodyText1: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: config.Colors().secondDarkColor(1),
                                height: 1.3),
                            caption: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                                color: config.Colors().secondDarkColor(0.6),
                                height: 1.2),
                          ),
                        ));
            }));
  }
}
