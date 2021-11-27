import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ponygold_courier/globals.dart' as globals;

class CurrentOrders extends StatefulWidget {
  CurrentOrders({Key? key}) : super(key: key);

  @override
  _CurrentOrdersState createState() => _CurrentOrdersState();
}

class _CurrentOrdersState extends State<CurrentOrders> {
  bool loading = true;
  dynamic orders = [];

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = json.decode(prefs.getString('user').toString());
    final response = await globals.get('/api/courier/orders');
    final arr = [];
    for (var i = 0; i < response['data'].length; i++) {
      print((user['id']) + int.parse(response['data'][i]['courier_id']));
      print((user['id']) == int.parse(response['data'][i]['courier_id']));
      if ((user['id']) == int.parse(response['data'][i]['courier_id'])) {
        arr.add(response['data'][i]);
        // print(response['data'][i]['courier_id']);
      } else {
        // print("ERROR " + response['data'][i]['courier_id']);
      }
    }
    setState(() {
      orders = arr;
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Текущий заказ'),
      ),
      body: loading
          ? SingleChildScrollView(
              child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 15)),
                  for (var i = 0; i < orders.length; i++)
                    GestureDetector(
                      onTap: () {
                        Get.toNamed("/detail-order",
                            arguments: orders[i]['id']);
                      },
                      child: Container(
                          height: 110,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              border: Border.all(color: Color(0xFFECECEC))),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'Заказ №${orders[i]['id']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      globals
                                          .formatDate(orders[i]['created_at']),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF747474)),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                  right: 8,
                                  child: Container(
                                      child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Color(0xFF5986E2),
                                  ))),
                              Positioned(
                                  // left: 6,
                                  bottom: 4,
                                  child: Container(
                                      child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Image.asset('images/car.png'),
                                      ),
                                      Text(
                                        'Курьеру: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        globals.formatMoney(orders[i]
                                                    ['total_amount']
                                                .toString()) +
                                            ' сум',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: globals.green),
                                      ),
                                    ],
                                  ))),
                            ],
                          )),
                    )
                ],
              ),
            ))
          : Center(
              child: CircularProgressIndicator(
                color: globals.blue,
              ),
            ),
      bottomNavigationBar: globals.bottomBar,
    );
  }
}
