
import 'package:flutter/material.dart';
import 'package:milk/components/LoadTitle.dart';

class LoadListView extends StatefulWidget {
	final Function getData, listViewBuilder;
	final Function? onLoad;

	const LoadListView({required this.getData, required builder, this.onLoad, Key? key}) :
			listViewBuilder = builder,
			super(key: key);

	@override
	_LoadListViewState createState() => _LoadListViewState();
}

class _LoadListViewState extends State<LoadListView> {
	bool isLoading = true;

	List<dynamic> data = [];

	// @override
	// initState() {
	// 	super.initState();
	// 	getData();
	// }

	@override
	Widget build(BuildContext context) => Column(
		children: [
			LoadTitle(load: widget.getData, onLoad: (d) => setState(() => data = d)),
			if (data.isNotEmpty) Expanded(child: widget.listViewBuilder(data))
		]);

	// @override
	// Widget build(BuildContext context) => Column(
	// 	children: [
	// 		// LoadTitle(isLoading),
	// 		Expanded(child: widget.listViewBuilder(data))
	// 	]);
	//
	// void getData() async {
	// 	setState(() => isLoading = true);
	//
	// 	data = await widget.getData();
	// 	if (widget.onLoad != null) widget.onLoad!(data);
	//
	// 	setState(() => isLoading = false);
	// }
}
