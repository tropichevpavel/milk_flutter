
import 'package:flutter/material.dart';
import 'package:milk/components/AgentEditForm.dart';
import 'package:milk/components/AgentSearchList.dart';
import 'package:milk/components/ConfirmDialog.dart';

import '../entities/Agent.dart';
import '../core.dart';

class AgentsPage extends StatefulWidget {

	const AgentsPage({Key? key}) : super(key: key);

	@override
	_AgentsPageState createState() => _AgentsPageState();
}

class _AgentsPageState extends State<AgentsPage> {

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text('Контрагенты')),
		body: AgentSearchList(
			key: UniqueKey(),
			onTap: (agent) => _showAgentEditForm(context, agent, () => setState(() {})),
			onDel: (agent) => ConfirmDialog(context, 'Вы точно хотите удалить данного контрагента?\n\nДанное действие необратимо!', () => _onDeleteCallback(agent)),
		)
	);

	void _showAgentEditForm(BuildContext context, Agent? agent, Function onSave) => showDialog(
		context: context,
		builder: (context) => AgentEditForm(agent, onSave)
	);

	void _onDeleteCallback(Agent agent) async { if (await core.delAgent(agent)) setState(() {}); }
}
