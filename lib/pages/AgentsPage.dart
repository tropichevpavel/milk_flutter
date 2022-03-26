
import 'package:flutter/material.dart';
import 'package:milk/components/AgentEditForm.dart';
import 'package:milk/components/ConfirmDialog.dart';

import '../entities/Agent.dart';
import '../core.dart';

class AgentsPage extends StatefulWidget {

  const AgentsPage({Key? key}) : super(key: key);

  @override
  _AgentsPageState createState() => _AgentsPageState();
}

class _AgentsPageState extends State<AgentsPage> {

  List<Agent> agents = [];

  Agent? curAgent;

  _AgentsPageState() {
    _getAgents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Контрагенты')),
      body: Column(
        children: [
          Visibility(
            child: const Text('Загрузка...', textAlign: TextAlign.center),
            visible: agents.isEmpty),
          Expanded(child: _agentsListView(agents)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAgentEditForm(context, null, () => _getAgents()),
      ),
    );
  }

  Widget _agentsListView(List<Agent> agents) {
    return ListView.builder(
      itemCount: agents.length,
      itemBuilder: (context, index) {
        return _agentsListItem(agents[index]);
      },
    );
  }

  Widget _agentsListItem(Agent agent) {
    return ListTile(
        onTap: () => _showAgentEditForm(context, agent, () => _getAgents()),
        title: Text(agent.name),
        subtitle: Text('${agent.phone} - ${agent.adress}'),
        trailing: InkWell(
          onTap: () => ConfirmDialog(context, 'Вы точно хотите удалить данного контрагента?\n\nДанное действие необратимо!', () => _onDeleteCallback(agent)),
          child: const Icon(Icons.delete),
        )
    );
  }

  _getAgents() async {
    agents = await core.getAgents();
    setState(() {});
  }

  _onDeleteCallback(Agent agent) async {
    if (await core.delAgent(agent)) {
      _getAgents();
    }
  }
}

_showAgentEditForm(BuildContext context, Agent? agent, Function onSave) => showDialog(
  context: context,
  builder: (context) => AgentEditForm(agent, onSave)
);
