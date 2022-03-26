
import 'package:milk/utils/DateTimeExt.dart';

import 'Agent.dart';
import 'ProdUnit.dart';

class Order {

  int? id;
  DateTimeExt date;
  Agent? agent;
  List<ProdUnit> prods = [];
  double cost = 0;

  Order.empty() : date = DateTimeExt.now();

  Order.fromOrder(Order order) :
        id = order.id,
        date = order.date,
        agent = order.agent,
        prods = order.prods,
        cost = order.cost;

  Order.fromJSON(Map<String, dynamic> json) :
        id = json['id'],
        date = str2Date(json['date']),
        cost = json['cost'].toDouble(),
        agent = Agent.fromJSON(json['agent']);

  toJSON() {
    updPrice();
    print(cost);
    String json = '{"agent":${agent?.id}, "date":"${date.getYMD()}", "cost":$cost, "prods":[';

    for (ProdUnit prod in prods) {
      json += '{"id":${prod.id}, "count":${prod.count}},';
    }

    return '${json.substring(0, json.length - 1)}]}';
  }

  addProd(ProdUnit prod) {
    for (ProdUnit _prod in prods) {
      if (_prod.id == prod.id) {
        _prod.count += prod.count;
        updPrice();
        return;
      }
    }

    prods.add(prod);
    updPrice();
  }

  delProd(ProdUnit prod) {
    prods.remove(prod);
    updPrice();
  }

  updPrice() {
    cost = 0;
    for (ProdUnit prod in prods) {
      cost += prod.count * prod.price;
    }
  }

  static DateTimeExt str2Date(String str) {
    List<String> date = str.split('-');
    return DateTimeExt(int.parse(date[0]), int.parse(date[1]), int.parse(date[2].substring(0, 2)));
  }
}