
import 'package:flutter/material.dart';
import 'package:milk/components/ProdsSearchList.dart';
import 'package:milk/entities/Prod.dart';
import 'package:milk/pages/ProdPage.dart';

class ProdsPage extends StatefulWidget {

	const ProdsPage({Key? key}) : super(key: key);

	@override
	_ProdsPageState createState() => _ProdsPageState();
}

class _ProdsPageState extends State<ProdsPage> {

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text('Товары')),
		body: ProdsSearchList(key: UniqueKey(), onTap: _onProdTap),
		floatingActionButton: FloatingActionButton(
			child: const Icon(Icons.add),
			onPressed: () => _onProdTap(null)
		));

	_onProdTap(Prod? prod) => Navigator.push(context, MaterialPageRoute(builder: (c) => ProdPage(prod, () => setState(() {}))));
}
