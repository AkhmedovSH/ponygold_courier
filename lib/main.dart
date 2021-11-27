import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Pages

import 'package:ponygold_courier/pages/login.dart';
import 'package:ponygold_courier/pages/index.dart';
import 'package:ponygold_courier/pages/detailOrder.dart';
import 'package:ponygold_courier/pages/profile.dart';
import 'package:ponygold_courier/pages/currentOrders.dart';

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
  String initialRoute = '';
  if (prefs.getString('user') == null) {
    initialRoute = '/login';
  } else {
    initialRoute = '/';
  }

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    popGesture: true,
    locale: lang,
    defaultTransition: Transition.leftToRight,
    transitionDuration: Duration(milliseconds: 250),
    theme: ThemeData(primaryColor: Color(0xFF5986E2), fontFamily: 'ProDisplay'),
    initialRoute: initialRoute,
    getPages: [
      GetPage(name: '/', page: () => Index()),
      GetPage(name: '/login', page: () => Login()),
      GetPage(name: '/profile', page: () => Profile()),
      GetPage(name: '/detail-order', page: () => DetailOrder()),
      GetPage(name: '/current-orders', page: () => CurrentOrders()),
      // GetPage(name: '/about-order', page: () => AboutOrder()),
    ],
    // onGenerateRoute: RouteGenerator.generateRoute,
  ));
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print(settings);
    print(settings.name);
    switch (settings.name) {
      case '/login':
        return GetPageRoute(
          settings: settings,
          page: () => Login(),
          routeName: 'login',
          transition: Transition.rightToLeft,
        );
      case '/':
        return GetPageRoute(
          settings: settings,
          page: () => Index(),
          transition: Transition.rightToLeft,
        );
      default:
        return GetPageRoute(
          settings: settings,
          page: () => Login(),
          transition: Transition.rightToLeft,
        );
    }
  }
}
