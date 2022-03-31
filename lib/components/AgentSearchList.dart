
import 'package:flutter/material.dart';
import 'package:milk/components/LoadListView.dart';
import 'package:milk/components/SearchListView.dart';
import 'package:milk/core.dart';
import 'package:milk/entities/Agent.dart';

import 'AgentEditForm.dart';
import 'HighlightText.dart';

class AgentSearchList extends StatelessWidget {

	final Function onTap;
	final Function? onDel;

	const AgentSearchList({required this.onTap, this.onDel, Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) => Scaffold(
		body: LoadListView(getData: core.getAgents, builder: (data) => SearchListView(data: data, filter: _filter, builder: _listView)),
		floatingActionButton: FloatingActionButton(child: const Icon(Icons.add), onPressed: () => _showAgentEditForm(context))
	);

	bool _filter(Agent a, search) =>
		a.name.toLowerCase().contains(search) ||
		a.adress.toLowerCase().contains(search) ||
		'${a.phone}'.contains(search);

	Widget _listView(List<Agent> agents, String search) => ListView.builder(
		itemCount: agents.length,
		itemBuilder: (c, i) => _listItem(agents[i], search));

	Widget _listItem(Agent agent, String search) => ListTile(
		onTap: () => onTap(agent),
		title: HighlightText(agent.name, search),
		subtitle: HighlightText('${agent.phone} - ${agent.adress}', search),
		trailing: onDel == null ? null
			: InkWell(
				onTap: () => onDel!(agent),
				child: const Icon(Icons.delete),
			));

	void _showAgentEditForm(BuildContext context) => showDialog(
		context: context,
		builder: (context) => AgentEditForm(null, onTap)
	);
}
