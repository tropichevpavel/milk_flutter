
import 'package:flutter/material.dart';

class HeaderListView extends StatelessWidget {

	final Function sectionBuilder;
	final List<ListViewSection> sections;

	const HeaderListView({required this.sections, required builder, Key? key}) :
			sectionBuilder = builder,
			super(key: key);

	@override
	Widget build(BuildContext context) =>
		CustomScrollView(
			slivers: sections
				.map((item) => sectionBuilder(item.header, item.data))
				.toList()
				.cast<Widget>());

}

class ListViewSection {
	String header;
	List<dynamic> data;

	ListViewSection(this.header, this.data);
}
