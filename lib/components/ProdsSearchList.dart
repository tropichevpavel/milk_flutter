
import 'package:flutter/material.dart';
import 'package:milk/components/LoadListView.dart';
import 'package:milk/components/SearchListView.dart';
import 'package:milk/core.dart';
import 'package:milk/entities/Prod.dart';

import 'HighlightText.dart';

class ProdsSearchList extends StatelessWidget {

	final Function onTap;
	final bool toSell;

	const ProdsSearchList({required this.onTap, this.toSell = false, Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) => LoadListView(getData: toSell ? core.getProds4Order : core.getProds, builder: (data) => SearchListView(data: data, filter: _filter, builder: _listView));

	bool _filter(Prod p, search) => p.name.toLowerCase().contains(search);

	Widget _listView(List<Prod> list, String search) => ListView.builder(
		itemCount: list.length,
		itemBuilder: (c, i) => _listItem(list[i], search));

	Widget _listItem(Prod prod, String search) => ListTile(
		onTap: () => onTap(prod),
		title: HighlightText(prod.name, search));
}
