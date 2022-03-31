

import 'package:flutter/material.dart';

class LoadTitle extends StatefulWidget {

	final Function? load;
	final Function onLoad;

	const LoadTitle({required this.load, required this.onLoad, Key? key}) : super(key: key);

	@override
	_LoadTitleState createState() => _LoadTitleState();
}

class _LoadTitleState extends State<LoadTitle> {

	bool _isLoading = true;
	Object _data = [];

	@override
	initState() {
		super.initState();
		_startLoad();
	}

	@override
	Widget build(BuildContext context) => Visibility(
		child: Container(
			width: double.infinity,
			padding: const EdgeInsets.only(top: 20),
			alignment: Alignment.center,
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					Container(
						width: 30,
						height: 20,
						padding: const EdgeInsets.only(right: 10),
						child: const CircularProgressIndicator(
							color: Colors.blue,
							strokeWidth: 3)),
					const Text('Загрузка...', textAlign: TextAlign.center)
				],
			),
		),
		visible: _isLoading);

	void _startLoad() async {
		if (widget.load != null) {
			_data = await widget.load!();
			setState(() => _isLoading = false);
			widget.onLoad(_data);
		}
	}
}