
import 'package:flutter/material.dart';
import 'package:milk/core.dart';

import '../theme.dart';

class MainPage extends StatefulWidget {

	const MainPage({Key? key}) : super(key: key);

	@override
	_MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text('Молочное производство')),
		body: Container(
			padding: EdgeInsets.all(ThemeSize.mainPadding),
			child: GridView(
				gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
					crossAxisCount: core.isWeb ? 6 : 2,
					crossAxisSpacing: ThemeSize.gridViewPadding,
					mainAxisSpacing: ThemeSize.gridViewPadding
				),
				children: [
					mainMenuButton('/prods', 'Товары', Icons.widgets),
					mainMenuButton('/docs', 'Документы', Icons.article_rounded),
					mainMenuButton('/agents', 'Контрагенты', Icons.account_circle),
					mainMenuButton('/orders', 'Заказы', Icons.apartment),
					// mainMenuButton('/deliveries', 'Доставка', Icons.airport_shuttle)
				])));

	Widget mainMenuButton(String route, String title, IconData icon) =>
		ElevatedButton(
			onPressed: () => Navigator.pushNamed(context, route),
			child: Container(
				padding: EdgeInsets.all(ThemeSize.mainPadding),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Container(
							padding: EdgeInsets.only(bottom: ThemeSize.mainPadding),
							child: Icon(icon, size: ThemeSize.buttonIconMainSize),
						),
						Text(title)
					])));
}
