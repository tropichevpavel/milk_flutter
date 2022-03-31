
import 'package:flutter/material.dart';

class SearchListView extends StatefulWidget {

	final List<dynamic> data;
	final Function filter, listViewBuilder;
	final Widget? emptySearch;
	final Function(Function)? searchView;

	const SearchListView({required this.data, required this.filter, required builder, this.emptySearch, this.searchView, Key? key}) :
			listViewBuilder = builder,
			super(key: key);

	@override
	_SearchListViewState createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> {

	String search = "";

	@override
	Widget build(BuildContext context) => Column(children: [
		widget.searchView == null ? _createSearchView() : widget.searchView!(_search),
		Expanded(child: widget.listViewBuilder(widget.data.where((e) => widget.filter(e, search)).toList(), search))
	]);

	void _search(String s) => setState(() => search = s.toLowerCase());

	Widget _createSearchView() => Container(
		decoration: BoxDecoration(border: Border.all(width: 1.0)),
		child: TextField(
			onChanged: _search,
			autofocus: true,
			decoration: InputDecoration(
				hintText: "Поиск по имени/адресу/телефону",
				hintStyle: TextStyle(color: Colors.grey[300]),
			),
			textAlign: TextAlign.center));
}
