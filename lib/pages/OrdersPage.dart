
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:milk/components/ConfirmDialog.dart';
import 'package:milk/components/HeaderListView.dart';
import 'package:milk/components/LoadListView.dart';
import 'package:milk/core.dart';
import 'package:milk/entities/Order.dart';
import 'package:milk/pages/OrderPage.dart';
import 'package:milk/theme.dart';
import 'package:milk/utils/DateTimeExt.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersPage extends StatefulWidget {
	const OrdersPage({Key? key}) : super(key: key);

	@override
	_OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

	@override
	Widget build(BuildContext context) =>
		Scaffold(
			appBar: AppBar(title: const Text('Список заказов')),
			body: LoadListView(
				key: UniqueKey(),
				getData: core.getOrders,
				builder: (data) => HeaderListView(
					sections: _orders2Section(data),
					builder: _ordersSection,
				),
			),
			floatingActionButton: FloatingActionButton(
				child: const Icon(Icons.add), onPressed: () => _onOrderTap(null))
		);

	_onOrderTap(Order? order) => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => OrderPage(order, _getOrders)));

	_getOrders() { setState(() {}); }

	_orders2Section(List<dynamic> ordersList) {
		List<ListViewSection> sections = [];

		List<Order> orders = [];
		DateTimeExt date = DateTimeExt(1970);

		for (Order order in ordersList) {
			if (date.year == order.date.year &&
				date.month == order.date.month &&
				date.day == order.date.day) {

				orders.add(order);

			} else {
				if (orders.isNotEmpty) {
					sections.add(ListViewSection(date.getDM('.'), orders));
				}

				orders = [order];
				date = order.date;
			}
		}

		if (orders.isNotEmpty) {
			sections.add(ListViewSection(date.getDM('.'), orders));
		}

		return sections;
	}

	Widget _ordersSection(String header, List<dynamic> orders) =>
		SliverStickyHeader(
			header: Container(
				padding: EdgeInsets.only(
					right: ThemeSize.mainPadding, left: ThemeSize.mainPadding),
				alignment: Alignment.center,
				child: Row(children: [
					Expanded(
						child: Text(header,
							textAlign: TextAlign.center,
							style: const TextStyle(
								fontWeight: FontWeight.bold, fontSize: 20))),
					Align(
						alignment: Alignment.centerRight,
						child: ElevatedButton(
							onPressed: () => _urlLaunch('http://milk.bidone.ru/api/v1/orders/2022-${header.substring(3, 5)}-${header.substring(0, 2)}/excel'),
							child: const Text('Excel'),
							style: ElevatedButton.styleFrom(primary: Colors.green)))
				]),
				color: Colors.white
			),
			sliver: SliverList(
				delegate: SliverChildBuilderDelegate(
						(context, i) => ListTile(
							leading: InkWell(
								onTap: () =>
									_urlLaunch('tel:+${orders[i].agent?.phone}'),
								child: const Icon(Icons.phone)),
							title: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text('${orders[i].agent?.name}'),
									Text('${orders[i].agent?.phone} - ${orders[i].agent?.adress}', style: const TextStyle(color: Colors.grey)),
								],
							),
							onTap: () => _onOrderTap(orders[i]),
							trailing: InkWell(
								onTap: () => _onOrderDelete(orders[i]),
								child: const Icon(Icons.delete))),
					childCount: orders.length)));

	_onOrderDelete(Order order) =>
		ConfirmDialog(context,
			'Вы точно хотите удалить данный заказ?\n\nДанное действие необратимо!',
			() async { await core.delOrder(order); setState(() {}); });

	_urlLaunch(String url) async {
		if (!await launch(url)) throw 'Could not launch';
	}
}
