import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:ponygold_ios/pages/orders.dart';
import 'package:simple_moment/simple_moment.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

String otp = '';
String phone = '';
bool loading = false;
double latitude = 0.0;
double longitude = 0.0;
int id = 1;

Color white = Color(0xFFFFFFFF);
Color black = Color(0xFF313131);
Color blue = Color(0xFF00B4AA);
Color lightGrey = Color(0xFF313131);
Color light = Color(0xFFECECEC);
Color red = Color(0xFFEB6465);
Color yellow = Color(0xFF313131);
Color green = Color(0xFF39B499);
Color grey = Color(0xFF747474);
Color grey3 = Color(0xFF828282);
Color disabled = Color(0xFF5986E2);
Color purple = Color(0xFFB439A7);

formatMoney(price) {
  var value = price;
  value = value.replaceAll(RegExp(r'\D'), '');
  value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ' ');
  return value;
}

showToast(context, error) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Color(0xFFEB6465),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(error),
          Icon(
            Icons.arrow_downward,
            color: Colors.white,
            size: 16,
          )
        ],
      ),
      duration: Duration(milliseconds: 5000),
      width: 300, // Width of the SnackBar.
      padding: EdgeInsets.symmetric(
          horizontal: 8.0, // Inner padding for SnackBar content.
          vertical: 8.0),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
  );
}

formatDate(date) {
  Moment rawDate = Moment.parse(date);
  return rawDate.format("dd.MM.yyyy HH:mm");
}

formatPhone(phone) {
  var x = phone.substring(0, 3);
  var y = phone.substring(3, 5);
  var z = phone.substring(5, 8);
  var d = phone.substring(8, 10);
  var q = phone.substring(10, 12);
  return '+' + x + ' ' + y + ' ' + z + ' ' + d + ' ' + q;
}

String baseUrl = 'https://ponygold.uz';

get(url) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dynamic token = prefs.getString('access_token');
  final response = await http.get(
    Uri.parse(baseUrl + url),
    headers: {
      // HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    },
  );
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 400) {
    return jsonDecode(response.body);
  }
  if (response.statusCode == 401) {
    final test = await login(url, {});
    return test;
  }
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
}

post(url, payload, showToast) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dynamic token = prefs.getString('access_token');
  final response = await http.post(
    Uri.parse(baseUrl + url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    },
    body: jsonEncode(payload),
  );
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 400) {
    showDangerToast(jsonDecode(response.body)['error']);
    return jsonDecode(response.body);
  }
  if (response.statusCode == 401) {
    print(111);
    final test = await login(url, payload);
    return test;
  }
  if (response.statusCode == 200) {
    if (showToast) {
      showSuccessToast('');
    }
    return jsonDecode(response.body);
  }
}

login(url, payload) async {
  print(payload);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getString('user'));
  final user = jsonDecode(prefs.getString('user').toString());
  print(user);
  dynamic token = prefs.getString('access_token');
  final password = jsonDecode(prefs.getString('password').toString());
  print(prefs.getString('user'));
  print(user);
  final login = await http.post(
    Uri.parse('https://ponygold.uz/api/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'phone': user['phone'],
      'password': password.toString()
    }),
  );
  print(login.body);
  if (login.statusCode == 200) {
    final responseJson = jsonDecode(login.body);
    prefs.setString('access_token', responseJson['access_token']);
    prefs.setString('user', jsonEncode(responseJson['user']));
    prefs.setString('password', password.toString());
    final response = await http.post(
      Uri.parse(baseUrl + url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode(payload),
    );
    return jsonDecode(response.body);
  }
}

showDangerToast(text) {
  Get.snackbar('Ошибка', '$text',
      colorText: Color(0xFFFFFFFF),
      onTap: (_) => print('DADA'),
      duration: Duration(seconds: 2),
      animationDuration: Duration(milliseconds: 600),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xFFEB6465));
}

showSuccessToast(text) {
  Get.snackbar('Успешно', '$text',
      colorText: Color(0xFFFFFFFF),
      onTap: (_) => print('DADA'),
      duration: Duration(seconds: 2),
      animationDuration: Duration(milliseconds: 600),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xFF39B499));
}

int active = 0;

onItemTab(int index) {
  if (index != active) {
    active = index;
    switch (index) {
      case 0:
        Get.offAllNamed("/");
        break;
      case 1:
        Get.offAllNamed(
          "/current-orders",
        );
        break;
      case 2:
        Get.offAllNamed("/history-orders");
        break;
      case 3:
        Get.offAllNamed(
          "/profile",
        );
        break;
    }
    bottomBar = BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: onItemTab,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory, color: active == 0 ? blue : grey3),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt, color: active == 1 ? blue : grey3),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.pending_actions,
                  color: active == 2 ? blue : grey3),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: active == 3 ? blue : grey3,
              ),
              label: ''),
        ]);
  }
}

Widget bottomBar = BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    onTap: onItemTab,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.inventory, color: active == 0 ? blue : grey3),
        label: '',
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.list_alt, color: active == 1 ? blue : grey3),
          label: ''),
      BottomNavigationBarItem(
          icon: Icon(Icons.pending_actions, color: active == 2 ? blue : grey3),
          label: ''),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: active == 3 ? blue : grey3,
          ),
          label: ''),
    ]);
