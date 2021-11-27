import 'package:flutter/material.dart';
import 'package:ponygold_courier/globals.dart' as globals;

class Detail extends StatefulWidget {
  final item;
  final totalAmount;
  const Detail({Key? key, this.item, this.totalAmount}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  cancelOrder() async {
    final response = await globals.post(
        '/api/courier/cancel-order' + widget.item['id'], {}, true);
    print(response);
  }

  acceptOrder() async {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 10)),
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Text(
            'Заказ№${widget.item['id']}',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: globals.grey),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            globals.formatDate(widget.item['created_at']),
            style: TextStyle(color: Color(0xFF747474)),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Отгрузить: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Еvos, Юнусабад Сараф Ц-1',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Доставить в: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Image.asset('images/car.png'),
                ),
                Text(
                  'Курьеру: ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  globals.formatMoney(widget.totalAmount.toString()) + ' сум',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: globals.green),
                ),
              ],
            )),
      ],
    );
  }
}
