import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ponygold_courier/globals.dart' as globals;
// Pages

import 'package:ponygold_courier/pages/login.dart';
import 'package:ponygold_courier/pages/index.dart';
import 'package:ponygold_courier/pages/detailOrder.dart';
import 'package:ponygold_courier/pages/profile.dart';
import 'package:ponygold_courier/pages/currentOrders.dart';
import 'package:ponygold_courier/pages/historyOrders.dart';
import 'package:ponygold_courier/pages/historyDetailOrder.dart';
import 'package:ponygold_courier/pages/googleMap.dart';

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
    theme: ThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        primaryColor: globals.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: globals.blue,
          ),
        ),
        fontFamily: 'ProDisplay'),
    initialRoute: initialRoute,
    getPages: [
      GetPage(name: '/login', page: () => Login()),
      GetPage(name: '/', page: () => Index()),
      GetPage(name: '/profile', page: () => Profile()),
      GetPage(name: '/detail-order', page: () => DetailOrder()),
      GetPage(name: '/current-orders', page: () => CurrentOrders()),
      GetPage(name: '/history-orders', page: () => Historyorders()),
      GetPage(name: '/history-detail-order', page: () => HistoryDetailOrder()),
      GetPage(name: '/google-map', page: () => MapSample()),
    ],
    // onGenerateRoute: RouteGenerator.generateRoute,
  ));
}
