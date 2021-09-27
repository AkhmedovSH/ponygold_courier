import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ponygold_courier/pages/login.dart';

void main() async {
  Locale lang = Locale('ru');
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('lang') == null) {
    lang = Locale('ru');
  } else {
    dynamic selectedLang = prefs.getString('lang');
    lang = Locale(selectedLang);
  }

  runApp(GetMaterialApp(
    popGesture: true,
    locale: lang,
    defaultTransition: Transition.native,
    transitionDuration: Duration(milliseconds: 250),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Color(0xFF5986E2), fontFamily: 'ProDisplay'),
    initialRoute: '/login',
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // print(settings.name);
    switch (settings.name) {
      case '/login':
        return GetPageRoute(
          settings: settings,
          page: () => Login(),
          transition: Transition.rightToLeft,
        );
      case '/login':
        return GetPageRoute(
          settings: settings,
          page: () => Login(),
          transition: Transition.rightToLeft,
        );
      default:
        return GetPageRoute(
          settings: settings,
          page: () => Login(),
          transition: Transition.fade,
        );

      // }
    }
  }
}
