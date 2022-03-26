
import 'package:flutter/material.dart';
import 'package:milk/entities/Unit.dart';
import 'package:milk/theme.dart';

import 'DropDownButton.dart';

class ProdUnitEditForm extends StatefulWidget {

  final Unit unit;
  final List<Unit> units;
  final Function(Unit) onSave;

  ProdUnitEditForm(Unit? unit, this.units, this.onSave, {Key? key}) : unit = unit ?? Unit.empty(), super(key: key);

  @override
  _ProdUnitEditFormState createState() => _ProdUnitEditFormState();
}

class _ProdUnitEditFormState extends State<ProdUnitEditForm> {

  late Unit _unit;

  @override
  void initState() {
    _unit = Unit.fromUnit(widget.unit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Dialog(
      insetPadding: EdgeInsets.all(ThemeSize.mainPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Text(
              widget.unit.id == null ? 'Добавление упаковки' : 'Редактирование упаковки',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                        padding: const EdgeInsets.only(right: 15),
                        child: DropDownButton('Ед изм', widget.units, _unit.id, widget.unit.puID == null ? (uID) => _onChange(uID) : null))
                ),
                Container(
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Цена:'),
                ),
                Expanded(
                    flex: 3,
                    child: TextFormField(
                        initialValue: _unit.price == 0 ? '' : '${_unit.price}',
                        autofocus: true,
                        onChanged: (v) => setState(() => _unit.price = v.isNotEmpty ? double.parse(v) : 0),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.0',
                        ))),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: const Text('руб.'),
                )
              ]
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена')),
                TextButton(
                    onPressed: _unit.id != null && _unit.price > 0 ? () => _onSave() : null,
                    child: const Text('Сохранить'))
              ],
            ),
          )
        ],
      ),
  );

  _onChange(int? uID) {
    for (Unit unit in widget.units) {
      if (unit.id == uID) {
        setState(() {
          _unit.id = unit.id;
          _unit.name = unit.name;
        });
      }
    }
  }

  _onSave() {
    Navigator.pop(context);
    widget.onSave(_unit);
  }
}