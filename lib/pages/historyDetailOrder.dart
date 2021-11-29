import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ponygold_courier/globals.dart' as globals;
import 'package:ponygold_courier/pages/components/aboutOrder.dart';
import 'package:ponygold_courier/pages/components/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ponygold_courier/widgets.dart';

class HistoryDetailOrder extends StatefulWidget {
  HistoryDetailOrder({Key? key}) : super(key: key);

  @override
  _HistoryDetailOrderState createState() => _HistoryDetailOrderState();
}

class _HistoryDetailOrderState extends State<HistoryDetailOrder> {
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
    print(response);
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
        title: Text('Подробности заказа'),
        centerTitle: true,
        backgroundColor: globals.blue,
      ),
      body: loading
          ? SingleChildScrollView(
              child: Container(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          'Заказ№${order['id']}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: globals.grey),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: globals.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          Container(
                              child: Text(
                            'Доставлено'.toString(),
                            style: TextStyle(
                                color: globals.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ))
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/google-map');
                          // _getCurrentLocation();
                        },
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10, top: 10),
                              child: Icon(
                                Icons.location_on,
                                color: globals.blue,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10, top: 10),
                              child: Text(
                                'Геолокация',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: globals.blue,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10, top: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: globals.blue,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Забрали из: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Flexible(
                              child: Text(
                                'Evos,Юнусабад, Ц - 1, ул. Уйгур Сафат',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Доставка в: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Flexible(
                            child: Text(
                              'Ташкент, массив Кушбеги, д 14, кв 14, напротив магазина Азия',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Image.asset('images/car.png'),
                              ),
                              Text(
                                'Курьеру: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                globals.formatMoney(
                                        order['total_amount'].toString()) +
                                    ' сум',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: globals.green),
                              ),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 5, top: 10),
                          child: Row(
                            children: [
                              Text(
                                'Заказчик: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF313131)),
                              ),
                              Text(
                                order['user']['name'] +
                                    ', ' +
                                    globals.formatPhone(order['user']['phone']),
                                style: TextStyle(
                                    fontSize: 16, color: globals.grey),
                              ),
                            ],
                          )),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 1.0, color: globals.green),
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 15,
                            ),
                            child: Text(
                              'Форма оплаты: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: globals.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Text(
                              order['payment_type'] == '0'
                                  ? 'Наличные'
                                  : order['payment_type'] == '1'
                                      ? 'Пластиковой картой курьеру'
                                      : order['payment_type'] == '2'
                                          ? 'Payme'
                                          : '',
                              style: TextStyle(
                                  color: globals.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ]),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 15, right: 10),
                              child: Image.asset('images/car.png'),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Text('Товары: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: globals.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Text(
                                  '${globals.formatMoney(order['total_amount'])}сум.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: globals.grey,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 15, right: 10),
                              child: Image.asset('images/ponyGold.png'),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Text('Курьеру: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: globals.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Text(
                                  '${globals.formatMoney(order['total_amount'])}сум.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: globals.green,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 15, right: 10),
                              child: Image.asset('images/card.png'),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Text('Pony Gold: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: globals.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Text(
                                  '${globals.formatMoney(order['total_amount'])}сум.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: globals.grey,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 15, right: 10),
                              child: Image.asset('images/box.png'),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Text('Сумма заказа: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: globals.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Text(
                                  '${globals.formatMoney(order['total_amount'])}сум.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: globals.grey,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text('Состав заказа',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: globals.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Column(
                          children: [
                            for (var i = 0;
                                i < order['order_products'].length;
                                i++)
                              Stack(
                                children: [
                                  Container(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 15),
                                      width: double.infinity,
                                      // margin: EdgeInsets.only(left: 15, bottom: 15),
                                      child: Text(
                                        order['order_products'][i]['name_uz'],
                                        style: TextStyle(
                                            color: globals.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: 15, bottom: 10),
                                        child: Text(
                                          'x' +
                                              order['order_products'][i]
                                                      ['quantity']
                                                  .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: globals.black,
                                          ),
                                        ),
                                      ))
                                ],
                              )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 15)),
                      ],
                    ),
                  )
                ],
              ),
            ))
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
