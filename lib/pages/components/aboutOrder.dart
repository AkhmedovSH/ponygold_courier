import 'package:flutter/material.dart';
import 'package:ponygold_courier/globals.dart' as globals;

class AboutOrder extends StatefulWidget {
  final item;
  const AboutOrder({Key? key, this.item}) : super(key: key);

  @override
  _AboutOrderState createState() => _AboutOrderState();
}

class _AboutOrderState extends State<AboutOrder> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.item['user']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 5),
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
                    widget.item['user']['name'] +
                        ', ' +
                        globals.formatPhone(widget.item['user']['phone']),
                    style: TextStyle(fontSize: 16, color: globals.grey),
                  ),
                ],
              )),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/google-map');
              // _getCurrentLocation();
            },
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15, top: 10),
                  child: Icon(
                    Icons.location_on,
                    color: globals.blue,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15, top: 10),
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
                  margin: EdgeInsets.only(bottom: 15, top: 10),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: globals.blue,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
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
                widget.item['payment_type'] == '0'
                    ? 'Наличные'
                    : widget.item['payment_type'] == '1'
                        ? 'Пластиковой картой курьеру'
                        : widget.item['payment_type'] == '2'
                            ? 'Payme'
                            : '',
                style:
                    TextStyle(color: globals.grey, fontWeight: FontWeight.bold),
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
                    '${globals.formatMoney(widget.item['total_amount'])}сум.',
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
                    '${globals.formatMoney(widget.item['total_amount'])}сум.',
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
                    '${globals.formatMoney(widget.item['total_amount'])}сум.',
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
                    '${globals.formatMoney(widget.item['total_amount'])}сум.',
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
              for (var i = 0; i < widget.item['order_products'].length; i++)
                Stack(
                  children: [
                    Container(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        width: double.infinity,
                        // margin: EdgeInsets.only(left: 15, bottom: 15),
                        child: Text(
                          widget.item['order_products'][i]['name_uz'],
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
                          margin: EdgeInsets.only(right: 15, bottom: 10),
                          child: Text(
                            'x' +
                                widget.item['order_products'][i]['quantity']
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
    );
  }
}
