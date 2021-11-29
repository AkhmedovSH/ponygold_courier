import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ponygold_courier/globals.dart' as globals;
import 'package:ponygold_courier/widgets.dart';

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
    setState(() {
      loading = false;
    });
    getOrders();
  }

  getOrders() async {
    final response = await globals.get('/api/courier/own-orders');
    setState(() {
      orders = response;
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Текущие заказы'),
        backgroundColor: globals.blue,
      ),
      body: loading
          ? orders.length > 0
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          globals.formatDate(
                                              orders[i]['created_at']),
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
                                        color: globals.blue,
                                      ))),
                                  Positioned(
                                      // left: 6,
                                      bottom: 4,
                                      child: Container(
                                          child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child:
                                                Image.asset('images/car.png'),
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
                  child: Text('Нет текущих заказов'),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: BottomBar(
        active: 1,
      ),
    );
  }
}
