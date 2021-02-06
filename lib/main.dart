import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/user.dart';
import 'screens/app_connection/app_connection.dart';
import 'services/localizations.dart';
import 'screens/home/home.dart';
import 'services/utils.dart' as utils;
import 'styles/styles.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }

}

class _MyAppState extends State<MyApp> {

  String langCode = utils.LANG_CODE;
  UserItem currentUser;

  @override
  void initState() {
    super.initState();
  }

  Future initApp() async {
    await Firebase.initializeApp();
    currentUser = await UserItem.getInstance();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      localizationsDelegates: [
        MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      onGenerateTitle: (BuildContext context) =>
      MyLocalizations.of(context).localization['app_title'],
      locale: Locale(langCode),
      supportedLocales: [Locale('en')],
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: initApp(),
        builder: (context, snapshot) {

          if (currentUser != null && currentUser.userId.length > 0) {
            return HomePage();
          }
          return AppConnection();

        },
      ),
    );
  }
}
