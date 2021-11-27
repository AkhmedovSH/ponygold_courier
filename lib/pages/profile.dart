import 'package:flutter/material.dart';
import 'package:ponygold_courier/globals.dart' as globals;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  dynamic user = {};
  bool loading = true;
  List filter = [
    {
      "id": 1,
      "name": 'Доставленные, незакрытые',
    },
    {
      "id": 2,
      "name": 'Доставленные, закрытые',
    }
  ];
  String dropdownValue = 'Доставленные, незакрытые';

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    getUser();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('https://ponygold.uz/api/auth/me'),
      headers: {
        // HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    setState(() {
      user = jsonDecode(response.body);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Мой профиль'),
          centerTitle: true,
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      margin: EdgeInsets.only(bottom: 24),
                      height: 180,
                      width: double.infinity,
                      color: Color(0xFFF4F7FA),
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            user['name'],
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF3133131),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'ID: ${user['id']}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF747474),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(globals.formatPhone(user['phone']),
                              style: TextStyle(
                                  fontSize: 18, color: globals.black)),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Cлужба поддержки: +998 99 314 43 63',
                            style: TextStyle(
                              color: globals.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Center(
                      child: Text(
                        'Расчет с Pony Gold',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                        // value: dropdownValue,
                        hint: Text('${filter[0]['name']}'),
                        icon: const Icon(Icons.chevron_right),
                        iconSize: 24,
                        iconEnabledColor: globals.blue,
                        elevation: 16,
                        style: const TextStyle(color: const Color(0xFF313131)),
                        underline: Container(
                          height: 2,
                          color: globals.blue,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: filter.map((item) {
                          return DropdownMenuItem<String>(
                            value: '${item['id']}',
                            child: Text(item['name']),
                          );
                        }).toList(),
                      ),
                    )
                    // DropdownButton(
                    //     // onChanged: (value) {

                    //     // },
                    //     items: [
                    //       DropdownMenuItem(child: Text('data')),
                    //       DropdownMenuItem(child: Text('data')),
                    //       DropdownMenuItem(child: Text('data')),
                    //     ])
                  ],
                ),
              ),
        bottomNavigationBar: globals.bottomBar,
      ),
    );
  }
}
