
import 'package:flutter/material.dart';

import 'package:milk/entities/Agent.dart';
import 'package:milk/core.dart';

class SearchListView extends StatefulWidget {
  final Function onCallback;

  const SearchListView(this.onCallback, [Key? key]) : super(key: key);

  @override
  _SearchListViewState createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> {

  List<Agent> _agents = [];
  final List<Agent> _agentsFilter = [];

  String search = "";

  @override
  initState() {
    super.initState();
    _getAgents();
  }

  _getAgents() async {
    _agentsFilter.addAll(_agents = await core.getAgents());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _createSearchView(),
      Expanded(child: _agentsListView(_agents.where((e) => _filter(e)).toList()))
    ]
  );

  Widget _createSearchView() => Container(
      decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: TextField(
        onChanged: (s) { setState(() { search = s.toLowerCase(); }); },
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Поиск по имени/адресу/телефону",
          hintStyle: TextStyle(color: Colors.grey[300]),
        ),
        textAlign: TextAlign.center));

  Widget _agentsListView(List<Agent> agents) =>
      ListView.builder(
        itemCount: agents.length,
        itemBuilder: (c, i) => _agentsListItem(agents[i]));

  Widget _agentsListItem(Agent agent) =>
      ListTile(
        onTap: () => widget.onCallback(agent),
        title: _spanHighlight(agent.name),
        subtitle: _spanHighlight('${agent.phone} - ${agent.adress}'));

  Widget _spanHighlight(String s) {
    List<TextSpan> span = [];
    int last = 0, cur = 0;

    while ((search.isNotEmpty && (cur = s.toLowerCase().indexOf(search, last)) != -1) || last != s.length) {

      span.add(TextSpan(text: (search.isEmpty || cur == -1) ? s.substring(last) : s.substring(last, cur)));

      if (search.isNotEmpty && cur != -1) {
        span.add(TextSpan(
            text: s.substring(cur, cur + search.length),
            style: const TextStyle(
              color: Colors.white,
              backgroundColor: Colors.blue)));
      }

      last = (search.isEmpty || cur == -1) ? s.length : (cur + search.length);
    }

    return Text.rich(TextSpan(children: span));
  }

  bool _filter(Agent a) => a.name.toLowerCase().contains(search) || a.adress.toLowerCase().contains(search) || '${a.phone}'.contains(search);
}