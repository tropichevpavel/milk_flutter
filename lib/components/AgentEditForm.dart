
import 'package:flutter/material.dart';
import 'package:milk/core.dart';
import 'package:milk/entities/Agent.dart';

import 'LoadButton.dart';

class AgentEditForm extends StatefulWidget {

  final Agent agent;
  final Function ui;

  AgentEditForm(Agent? agent, this.ui, {Key? key}) : agent = agent ?? Agent.empty(), super(key: key);

  @override
  _AgentEditFormState createState() => _AgentEditFormState();
}

class _AgentEditFormState extends State<AgentEditForm> {

  @override
  Widget build(BuildContext context) => Dialog(
      insetPadding: const EdgeInsets.all(15.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                  widget.agent.id == null ? 'Создание контрагента' : 'Редактирование контрагента',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold))
            ),
            TextFormField(
                initialValue: widget.agent.name,
                onChanged: (text) => setState(() => widget.agent.name = text),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    // border: InputBorder.none,
                    hintText: 'Имя контрагента',
                    icon: Icon(Icons.account_circle))
            ),
            TextFormField(
                initialValue: widget.agent.id == null ? '' : '${widget.agent.phone}',
                onChanged: (text) => setState(() => widget.agent.phone = int.parse(text)),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    hintText: 'Телефон контрагента',
                    icon: Icon(Icons.phone))
            ),
            TextFormField(
                initialValue: widget.agent.adress,
                onChanged: (text) => setState(() => widget.agent.adress = text),
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                    // border: InputBorder.none,
                    hintText: 'Адрес контрагента',
                    icon: Icon(Icons.location_pin)
                )
            ),
            Container(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена')),
                  LoadButton(
                      onTap: widget.agent.id == null ? () => core.addAgent(widget.agent) : () => core.updAgent(widget.agent),
                      ui: () {
                        Navigator.pop(context);
                        widget.ui();
                      },
                      disabled: widget.agent.name.isEmpty || widget.agent.phone == 0 || widget.agent.adress.isEmpty)
                ]
              )
            )
          ]
        )
      )
    );
}

