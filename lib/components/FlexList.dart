
import 'package:flutter/material.dart';

class FlexList extends StatelessWidget {

	final List<dynamic> data;
	final Function itemBuilder;

	const FlexList({required this.data, required builder, Key? key}) :
			itemBuilder = builder,
			super(key: key);

	@override
	Widget build(BuildContext context) => Wrap(children: data.map((e) => itemBuilder(e)).toList().cast());
}