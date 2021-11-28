import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ponygold_courier/globals.dart' as globals;
import 'package:ponygold_courier/pages/components/aboutOrder.dart';
import 'package:ponygold_courier/pages/components/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ponygold_courier/widgets.dart';

class DetailOrder extends StatefulWidget {
  DetailOrder({Key? key}) : super(key: key);

  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  dynamic id = 0;
  dynamic order = {};
  dynamic totalAmount = 0;
  int currentIndex = 0;
  bool loading = true;
  bool currentOrder = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      id = Get.arguments;
      loading = false;
    });
    getOrder();
  }

  getOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = jsonDecode(prefs.getString('user').toString());
    final response = await globals.get('/api/courier/order/$id');
    print(user);
    setState(() {
      if (int.parse(response['courier_id']) == user['id']) {
        currentOrder = false;
      }
      print(currentOrder);
      order = response;
      totalAmount = response['delivery_price'];
      loading = true;
    });
  }

  cancelOrder() async {
    final response =
        await globals.post('/api/courier/cancel-order/$id', {}, false);
    Get.offAllNamed('/');
  }

  acceptOrder() async {
    final response =
        await globals.post('/api/courier/accept-order/$id', {}, false);
    print(response);
    Get.offAllNamed('/current-orders');
  }

  closeOrder() async {
    globals.post('/api/courier/close-order/$id', {}, false);
    Get.offAllNamed('/history-orders');
  }

  show(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(''),
        titlePadding: EdgeInsets.all(0),
        content: const Text(
          'Вы действительно хотите отказаться от доставки данного заказа?',
          style: TextStyle(
              color: Color(0xFF313131),
              fontWeight: FontWeight.w500,
              fontSize: 18),
          textAlign: TextAlign.center,
        ),
        contentPadding: EdgeInsets.all(0),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('ОТМЕНИТЬ'),
              ),
              TextButton(
                onPressed: () => cancelOrder(),
                child: const Text('ПОДТВЕРДИТЬ'),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Доступные заказы'),
        centerTitle: true,
      ),
      body: loading
          ? SingleChildScrollView(
              child: Container(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DefaultTabController(
                    length: 2,
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      indicatorWeight: 2,
                      labelColor: globals.blue,
                      unselectedLabelColor: globals.grey,
                      labelStyle: TextStyle(
                          fontSize: 16.0,
                          color: globals.blue,
                          fontWeight: FontWeight.bold),
                      unselectedLabelStyle:
                          TextStyle(fontSize: 16.0, color: globals.grey),
                      // controller: ,
                      tabs: const [
                        Tab(
                          text: 'О заказе',
                        ),
                        Tab(
                          text: 'Подробности',
                        ),
                      ],
                    ),
                  ),
                  currentIndex == 0
                      ? Detail(
                          item: order,
                          totalAmount: totalAmount,
                        )
                      : AboutOrder(
                          item: order,
                        ),
                ],
              ),
            ))
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: loading
          ? currentIndex == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 30,
                        bottom: 15,
                      ),
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: currentOrder
                                ? globals.white
                                : Colors.transparent,
                            elevation: currentOrder ? 1 : 0),
                        onPressed: () {
                          currentOrder ? cancelOrder() : show(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              child: currentOrder
                                  ? Text(
                                      'Отклонить',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )
                                  : Text(
                                      'Отменить доставку',
                                      style: TextStyle(
                                          color: globals.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 30,
                      ),
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: globals.blue),
                        onPressed: () {
                          currentOrder ? acceptOrder() : closeOrder();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              child: currentOrder
                                  ? Text(
                                      'Принять',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      'Доставлено',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Container()
          : Container(),
      bottomNavigationBar: BottomBar(),
    );
  }
}
