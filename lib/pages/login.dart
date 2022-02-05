import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ponygold_courier/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phone = '';
  dynamic password = '';
  bool loading = true;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+### ## ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  void login(context) async {
    setState(() {
      loading = false;
      phone = maskFormatter.getUnmaskedText();
    });
    final response = await globals.post('/api/auth/login',
        <String, String>{'phone': phone, 'password': password}, true);
    print(response['user']['role'] == '8');
    if (response['user']['role'] == '8') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', response['access_token']);
      prefs.setString('user', jsonEncode(response['user']));
      prefs.setString('password', password);

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      globals.showDangerToast('Вы не курьер');
    }
    
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: globals.blue,),
        body: Center(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Вход',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              inputFormatters: [
                                // LengthLimitingTextInputFormatter(16),
                                maskFormatter
                              ],
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Обязательное поле';
                                }
                                if (value.length < 9) {
                                  return 'Минимум 9 символов';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '+998 99 999-99-99',
                                // prefixIcon: Padding(
                                //   padding: EdgeInsets.only(left: 10, bottom: 2),
                                //   child: Text(
                                //     "+998",
                                //     style: TextStyle(fontSize: 16),
                                //   ),
                                // ),
                                prefixIconConstraints:
                                    BoxConstraints(minWidth: 0, minHeight: 0),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  phone = value;
                                });
                              },
                            )),
                      ),
                      Form(
                        key: _formKey2,
                        child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Обязательное поле';
                                }
                                if (value.length < 4) {
                                  return 'Минимум 4 символа';
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Пароль',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              onFieldSubmitted: (val) {
                                if (_formKey.currentState!.validate() &&
                                    _formKey2.currentState!.validate()) {
                                  login(context);
                                }
                              },
                            )),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _formKey2.currentState!.validate()) {
                              login(context);
                            }
                          },
                          child: Text(
                            'Войти',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50)),
                        ),
                      ),
                      Container(
                        child: TextButton(
                          onPressed: () {
                            // Navigator.pushNamed(context, '/password-recovery-get');
                          },
                          child: Text('Забыли пароль?',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF747474),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                                'Обратитесь в службу поддержки: \n +998 99 314 43 63',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF747474),
                                    fontWeight: FontWeight.w600))),
                      ),
                    ],
                  ),
                ),
                loading
                    ? Container()
                    : Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          ),
        ));
  }
}
